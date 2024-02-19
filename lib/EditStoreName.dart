import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditStoreNameScreen extends StatefulWidget {
  final Map<String, dynamic> storeData;

  EditStoreNameScreen({required this.storeData});

  @override
  _EditStoreNameScreenState createState() => _EditStoreNameScreenState();
}

class _EditStoreNameScreenState extends State<EditStoreNameScreen> {
  TextEditingController storeCodeController = TextEditingController();
  TextEditingController storeNameController = TextEditingController();
  TextEditingController storeTypeCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    storeCodeController.text = widget.storeData['store_code'] ?? '';
    storeNameController.text = widget.storeData['store_name'] ?? '';
    storeTypeCodeController.text = widget.storeData['store_type_code'] ?? '';
  }

  Future<void> _saveEditedStoreName() async {
    final apiUrl =
        'http://localhost/tourlism_root_db/update_store_name_info.php';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'case': '2',
          'store_code': storeCodeController.text,
          'store_name': storeNameController.text,
          'store_type_code': storeTypeCodeController.text,
        },
      );

      if (response.statusCode == 200) {
        print('Store name updated successfully');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Store name updated successfully'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(true); // Close AlertDialog with success result
                    Navigator.pop(context,
                        true); // Close EditStoreNameScreen with success result
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        print('Error updating store name: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating store name'),
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
        title: Text('Edit Store Name'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: storeCodeController,
              decoration: InputDecoration(labelText: 'Store Code'),
              readOnly: true,
            ),
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
              onPressed: _saveEditedStoreName,
              child: Text('Save Edited Store Name'),
            ),
          ],
        ),
      ),
    );
  }
}
