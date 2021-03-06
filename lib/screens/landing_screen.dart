import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_attendance_app/screens/student/student_home_screen.dart';

import '/screens/faculty/faculty_home_screen.dart';

import '/providers/auth.dart';
import '/models/user.dart';
import 'authentication/sign_in_screen.dart';

class LandingScreen extends StatefulWidget {
  static const routeName = '/landing';
  final String userType;

  const LandingScreen({Key? key, required this.userType}) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final ThemeData theme = Theme.of(context);
    final AuthBase auth = Provider.of<Auth>(context, listen: false);
    return StreamBuilder<UserModel?>(
      stream: auth.onAuthStateChanged(widget.userType),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          UserModel? user = snapshot.data;
          return user != null
              ? widget.userType == "Faculty"
                  ? FacultyHomeScreen(user: user)
                  : StudentHomeScreen(user: user)
              : SignInPage(userType: widget.userType);
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'SMA',
                style: theme.appBarTheme.textTheme!.headline1,
              ),
            ),
            body: Card(
              child: SizedBox(
                  height: 0.95 * height,
                  child: Text(
                    "Please check your internet connection!",
                    style: theme.textTheme.headline1,
                  )),
            ),
          );
        }
      },
    );
  }
}
