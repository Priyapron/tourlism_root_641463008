import 'package:flutter/material.dart';
import 'package:tourlism_root_641463008/InsertStoreName_screen.dart'; // Updated import
import 'package:tourlism_root_641463008/storeNameData.dart';

class StoreNameMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Menu'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // First Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: buildStyledImageButton(
                      'images/phon-menu-icon.jpeg',
                      'เพิ่มชื่อร้านค้า',
                      InsertStoreNameScreen(), // Updated destination
                      context,
                    ),
                  ),
                  Expanded(
                    child: buildStyledImageButton(
                      'images/sos-menu-icon.png',
                      'จัดการชื่อร้านค้า',
                      StoreDataPage(),
                      context,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStyledImageButton(String imagePath, String buttonText,
      Widget destination, BuildContext context) {
    return Container(
      width: 180,
      height: 220,
      margin: EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: Colors.blue, width: 2.0),
          ),
          elevation: 5.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 100,
              height: 100,
            ),
            SizedBox(height: 15),
            Text(
              buttonText,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
