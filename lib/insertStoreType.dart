import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InsertStoreTypeScreen extends StatefulWidget {
  @override
  _InsertStoreTypeScreenState createState() => _InsertStoreTypeScreenState();
}

class _InsertStoreTypeScreenState extends State<InsertStoreTypeScreen> {
  TextEditingController storeTypeNameController = TextEditingController();
  String? selectedStoreTypeCode;
  late Future<List<String>> storeTypeCodes;

  void _showSaveSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Successfully'),
          content: Text('Store type information saved successfully'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close AlertDialog
                Navigator.pop(context); // Close InsertStoreTypeScreen
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<List<String>> _getStoreTypeCodes() async {
    final apiUrl = 'http://localhost/tourlism_root_db/get_store_type_codes.php';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => item['store_type_code'].toString()).toList();
    } else {
      throw Exception(
          'Error fetching store type codes: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    storeTypeCodes = _getStoreTypeCodes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Store Type Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 20.0),
            FutureBuilder(
              future: storeTypeCodes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<String> storeTypeCodeItems =
                      snapshot.data as List<String>;
                  return DropdownButtonFormField(
                    value: selectedStoreTypeCode,
                    items: storeTypeCodeItems.map((code) {
                      return DropdownMenuItem(
                        value: code,
                        child: Text(code),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedStoreTypeCode = value;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Store Type Code'),
                  );
                }
              },
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: storeTypeNameController,
              decoration: InputDecoration(labelText: 'Store Type Name'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _saveStoreTypeInfo();
              },
              child: Text('Save Store Type Information'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveStoreTypeInfo() async {
    final apiUrl =
        'http://localhost/tourlism_root_db/update_store_type_info.php';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'case': '1', // Use case '1' for saving store type information
          'store_type_code': selectedStoreTypeCode!,
          'store_type_name': storeTypeNameController.text,
        },
      );

      if (response.statusCode == 200) {
        print('Store type information saved successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Store type information saved successfully'),
            duration: Duration(seconds: 2),
          ),
        );

        // Show the success dialog
        _showSaveSuccessDialog();
      } else {
        print('Error saving store type information: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving store type information'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
