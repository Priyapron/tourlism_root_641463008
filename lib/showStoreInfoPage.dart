import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShowStoreInfoPage extends StatefulWidget {
  final String storeId;

  ShowStoreInfoPage({required this.storeId});

  @override
  _ShowStoreInfoPageState createState() => _ShowStoreInfoPageState();
}

class _ShowStoreInfoPageState extends State<ShowStoreInfoPage> {
  late Future<Map<String, dynamic>> _storeInfo;

  Future<Map<String, dynamic>> _fetchStoreInfo() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost/tourlism_root_db/show_store_info.php'),
        body: {'store_code': widget.storeId},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> parsed = json.decode(response.body);
        return parsed;
      } else {
        throw Exception('Failed to load store information');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to load store information');
    }
  }

  @override
  void initState() {
    super.initState();
    _storeInfo = _fetchStoreInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Store Information'),
        backgroundColor: Color.fromARGB(255, 56, 136, 255),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _storeInfo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No store information found'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Store Information',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Table(
                    border: TableBorder.all(
                      color: Color.fromARGB(255, 0, 0, 0),
                      width: 2.0,
                    ),
                    columnWidths: {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(3),
                    },
                    children: [
                      buildTableRow('Store Code', snapshot.data!['store_code']),
                      buildTableRow('Store Name', snapshot.data!['store_name']),
                      buildTableRow(
                          'Store Type', snapshot.data!['store_type_code']),
                      // Add more rows if needed
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  TableRow buildTableRow(String label, dynamic value) {
    return TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              value.toString(),
              style: TextStyle(
                color: Colors.black, // Set text color to black
              ),
            ),
          ),
        ),
      ],
    );
  }
}
