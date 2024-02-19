import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tourlism_root_641463008/gpstracking.dart';

class TouristLocationsScreen extends StatefulWidget {
  @override
  _TouristLocationsScreenState createState() => _TouristLocationsScreenState();
}

class _TouristLocationsScreenState extends State<TouristLocationsScreen> {
  TextEditingController locationCodeController = TextEditingController();
  TextEditingController locationNameController = TextEditingController();
  TextEditingController locationDetailsController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();

  void _showSaveSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Successfully'),
          content: Text('Tourist location information saved successfully'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close AlertDialog
                Navigator.pop(context); // Close TouristLocationsScreen
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveTouristLocationInfo() async {
    final apiUrl =
        'http://localhost/tourlism_root_db/update_tourist_location_info.php';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'case': '1', // Use case '1' for saving tourist location information
          'location_code': locationCodeController.text,
          'location_name': locationNameController.text,
          'location_details': locationDetailsController.text,
          'latitude': latitudeController.text,
          'longitude': longitudeController.text,
        },
      );

      if (response.statusCode == 200) {
        print('Tourist location information saved successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tourist location information saved successfully'),
            duration: Duration(seconds: 2),
          ),
        );

        // Show the success dialog
        _showSaveSuccessDialog();
      } else {
        print(
            'Error saving tourist location information: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving tourist location information'),
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
        title: Text('Tourist Location Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 20.0),
            TextFormField(
              controller: locationNameController,
              decoration: InputDecoration(labelText: 'Location Name'),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: locationDetailsController,
              decoration: InputDecoration(labelText: 'Location Details'),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: latitudeController,
              decoration: InputDecoration(labelText: 'Latitude'),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: longitudeController,
              decoration: InputDecoration(labelText: 'Longitude'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _saveTouristLocationInfo,
              child: Text('Save Tourist Location Information'),
            ),
          ],
        ),
      ),
    );
  }
}
