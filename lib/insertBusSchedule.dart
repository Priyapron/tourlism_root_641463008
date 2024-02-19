import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BusScheduleScreen extends StatefulWidget {
  @override
  _BusScheduleScreenState createState() => _BusScheduleScreenState();
}

class _BusScheduleScreenState extends State<BusScheduleScreen> {
  TextEditingController sequenceController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  String? selectedLocationCode;
  late Future<List<String>> locationCodes;

  void _showSaveSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Successfully'),
          content: Text('Bus schedule information saved successfully'),
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

  Future<List<String>> _getLocationCodes() async {
    final apiUrl = 'http://localhost/tourlism_root_db/get_location_codes.php';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => item['location_code'].toString()).toList();
    } else {
      throw Exception('Error fetching location codes: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    locationCodes = _getLocationCodes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Schedule Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 20.0),
            FutureBuilder(
              future: locationCodes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<String> locationCodeItems =
                      snapshot.data as List<String>;
                  return DropdownButtonFormField(
                    value: selectedLocationCode,
                    items: locationCodeItems.map((code) {
                      return DropdownMenuItem(
                        value: code,
                        child: Text(code),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedLocationCode = value;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Location Code'),
                  );
                }
              },
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: timeController,
              decoration: InputDecoration(labelText: 'Time'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _saveBusScheduleInfo();
              },
              child: Text('Save Bus Schedule Information'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveBusScheduleInfo() async {
    final apiUrl =
        'http://localhost/tourlism_root_db/update_bus_schedule_info.php';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'case': '1', // Use case '1' for saving bus schedule information
          'sequence_number': sequenceController.text,
          'location_code': selectedLocationCode!,
          'time': timeController.text,
        },
      );

      if (response.statusCode == 200) {
        print('Bus schedule information saved successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bus schedule information saved successfully'),
            duration: Duration(seconds: 2),
          ),
        );

        // Show the success dialog
        _showSaveSuccessDialog();

        // Delay the navigation by 2 seconds (the duration of the Snackbar)
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(context, '/mainmenu');
        });
      } else {
        print('Error saving bus schedule information: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving bus schedule information'),
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
