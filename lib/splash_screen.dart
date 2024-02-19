import 'package:flutter/material.dart';
import 'package:tourlism_root_641463008/mainmenu.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'ยินดีต้อนรับ',
              style: TextStyle(
                fontSize: 30,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            // Adjusted the Image.asset to have a fixed height
            SizedBox(
              height: 150.0,
              child: Image.asset('images/ตราราชภัฏเชียงราย.png'),
            ),
            SizedBox(height: 20.0),
            SizedBox(
              width: 300.0,
              height: 50.0,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => MainMenu(),
                  ));
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: Color.fromARGB(255, 164, 128, 225),
                    width: 2.0,
                  ),
                  backgroundColor: Color.fromARGB(255, 164, 128, 225),
                ),
                child: Text(
                  'หน้าหลัก',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
