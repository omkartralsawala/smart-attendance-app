import 'package:flutter/material.dart';
import '../screens/landing_screen.dart';
import 'package:smart_attendance_app/widgets/appbar.dart';

class EntryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: constantAppBar(),
      body: SafeArea(
        child: Container(
          height: size.height,
          width: size.width,
          // padding: EdgeInsets.only(bottom: 0.2 * size.height),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Spacer(flex: 2),
              Expanded(
                  flex: 2,
                  child: Text(
                    "Smart Attendance App",
                    style: TextStyle(fontSize: 30),
                  )),
              Spacer(flex: 2),
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LandingScreen(),
                    ),
                  ),
                  child: SizedBox(
                    width: 0.7 * size.width,
                    child: Center(
                      child: Text(
                        "Faculty Login",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                ),
              ),
              Spacer(),
              Expanded(
                child: TextButton(
                  onPressed: () {},
                  child: SizedBox(
                    width: 0.7 * size.width,
                    child: Center(
                      child: Text(
                        "Student Login",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                ),
              ),
              Spacer(flex: 2)
            ],
          ),
        ),
      ),
    );
  }
}
