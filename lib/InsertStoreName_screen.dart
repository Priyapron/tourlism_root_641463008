import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InsertStoreNameScreen extends StatefulWidget {
  @override
  _StoreNameScreenState createState() => _StoreNameScreenState();
}

class _StoreNameScreenState extends State<InsertStoreNameScreen> {
  TextEditingController storeNameController = TextEditingController();
  TextEditingController storeTypeCodeController = TextEditingController();

  void _showSaveSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Successfully'),
          content: Text('Store name information saved successfully'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close AlertDialog
                Navigator.pop(context); // Close StoreNameScreen
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveStoreNameInfo() async {
    final apiUrl =
        'http://localhost/tourlism_root_db/update_store_name_info.php';

    try {
      // Generate store_code (you can replace this logic with your own method)
      String storeCode = DateTime.now().millisecondsSinceEpoch.toString();

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'case': '1', // Use case '1' for saving store name information
          'store_code': storeCode,
          'store_name': storeNameController.text,
          'store_type_code': storeTypeCodeController.text,
        },
      );

      if (response.statusCode == 200) {
        print('Store name information saved successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Store name information saved successfully'),
            duration: Duration(seconds: 2),
          ),
        );

        // Show the success dialog
        _showSaveSuccessDialog();
      } else {
        print('Error saving store name information: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving store name information'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Store Name Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Remove store_code TextFormField
            SizedBox(height: 20.0),
            TextFormField(
              controller: storeNameController,
              decoration: InputDecoration(labelText: 'Store Name'),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: storeTypeCodeController,
              decoration: InputDecoration(labelText: 'Store Type Code'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _saveStoreNameInfo,
              child: Text('Save Store Name Information'),
            ),
          ],
        ),
      ),
    );
  }
}
