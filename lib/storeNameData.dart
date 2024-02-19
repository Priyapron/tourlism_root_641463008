import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tourlism_root_641463008/showStoreInfoPage.dart';
import 'package:tourlism_root_641463008/EditStoreName.dart';

class StoreDataPage extends StatefulWidget {
  @override
  _StoreDataPageState createState() => _StoreDataPageState();
}

class _StoreDataPageState extends State<StoreDataPage> {
  late Future<List<Map<String, dynamic>>> _storeData;

  Future<List<Map<String, dynamic>>> _fetchStoreData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://localhost/tourlism_root_db/selectstore.php')); // Adjust the API endpoint
      print(response.statusCode);
      if (response.statusCode == 200) {
        final List<dynamic> parsed = json.decode(response.body);
        return parsed.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to connect to data. Please check.');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to connect to data. Please check.');
    }
  }

  Future<void> _deleteStoreData(String storeCode) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://localhost/tourlism_root_db/update_store_name_info.php'),
        body: {
          'case': '3',
          'store_code': '$storeCode',
        },
      );

      if (response.statusCode == 200) {
        print('Store data deleted successfully');
      } else {
        print(
            'Failed to delete store data. Server returned status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error deleting store data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _storeData = _fetchStoreData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 56, 136, 255),
        leading: IconButton(
          icon: Icon(Icons.home),
          color: Colors.white,
          onPressed: () {
            Navigator.pushNamed(context, '/mainmenu');
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Store Data',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _storeData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No data available'));
            } else {
              return Align(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Center(
                          child: DataTable(
                            columns: <DataColumn>[
                              DataColumn(label: Text(' ')),
                              DataColumn(label: Text('Store Name')),
                              DataColumn(label: Text('Type')),
                              DataColumn(label: Text('Search')),
                              DataColumn(label: Text('Edit')),
                              DataColumn(label: Text('Delete')),
                            ],
                            rows: snapshot.data!.map((data) {
                              return DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(' ')),
                                  DataCell(Text(
                                      data['store_name']?.toString() ?? 'N/A')),
                                  DataCell(Text(
                                      data['store_type_code']?.toString() ??
                                          'N/A')),
                                  DataCell(
                                    IconButton(
                                      icon: Icon(Icons.search),
                                      color: Colors.green,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ShowStoreInfoPage(
                                              storeId: data['store_code']
                                                      ?.toString() ??
                                                  '',
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  DataCell(
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      color: Colors.blue,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditStoreNameScreen(
                                              storeData: data,
                                            ),
                                          ),
                                        ).then((result) {
                                          if (result != null && result) {
                                            // กระทำหลังจากการแก้ไขเสร็จสมบูรณ์
                                            setState(() {
                                              _storeData =
                                                  _fetchStoreData(); // รีเซ็ทหน้า storeNameData.dart
                                            });
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  DataCell(
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      color: Colors.red,
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  Text('Delete Confirmation'),
                                              content: Text(
                                                'Are you sure you want to delete this store data?',
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    await _deleteStoreData(
                                                      data['store_code']
                                                              ?.toString() ??
                                                          '',
                                                    );
                                                    Navigator.of(context).pop();
                                                    setState(() {
                                                      _storeData =
                                                          _fetchStoreData();
                                                    });
                                                  },
                                                  child: Text('Delete'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
