import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/screens/faculty/faculty_home_screen.dart';
import '/screens/student/student_home_screen.dart';

import '/providers/auth.dart';
import '/models/user.dart';
import 'authentication/sign_in_screen.dart';

class LandingScreenArgs {
  final String userType;

  const LandingScreenArgs({required this.userType});
}

class LandingScreen extends StatefulWidget {
  static const routeName = '/landing';

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final ThemeData theme = Theme.of(context);
    final LandingScreenArgs args =
        ModalRoute.of(context)!.settings.arguments as LandingScreenArgs;
    final AuthBase auth = Provider.of<Auth>(context, listen: false);
    return StreamBuilder<UserModel?>(
      stream: auth.onAuthStateChanged(args.userType),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          UserModel? user = snapshot.data;
          return user != null
              ? user.userType == 'Faculty'
                  ? FacultyHomeScreen(user: user)
                  : StudentHomeScreen(user: user)
              : SignInPage(userType: args.userType);
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
