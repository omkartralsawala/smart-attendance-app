import 'package:flutter/material.dart';
import 'package:smart_attendance_app/screens/landing_screen.dart';
import 'package:smart_attendance_app/widgets/appbar/appbar.dart';
import 'package:smart_attendance_app/widgets/buttons/submit_button.dart';

class EntryScreen extends StatelessWidget {
  const EntryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: constantAppBar(),
      body: SafeArea(
        child: Column(children: [
          Text("Select Login Type"),
          Spacer(),
          SubmitButton(
            text: "Faculty Login",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => LandingScreen(
                          userType: "Faculty",
                        )),
              );
            },
          ),
          SubmitButton(
            text: "Student Login",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => LandingScreen(
                          userType: "Student",
                        )),
              );
            },
          ),
        ]),
      ),
    );
  }
}
