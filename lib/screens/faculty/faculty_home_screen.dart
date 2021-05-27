import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:smart_attendance_app/routes/navigation.dart';
import 'package:smart_attendance_app/widgets/appbar/appbar.dart';
import 'package:smart_attendance_app/widgets/gridview/all_courses_grid.dart';
import 'package:smart_attendance_app/widgets/gridview/faculty_course_grid.dart';
import '../../widgets/dialog_box/platform_alert_dialog.dart';
import '../../providers/auth.dart';
import '../../models/user.dart';

class FacultyHomeScreen extends StatefulWidget {
  static const String routeName = "/home_screen";
  final UserModel user;
  FacultyHomeScreen({required this.user});
  @override
  _FacultyHomeScreenState createState() => _FacultyHomeScreenState();
}

class _FacultyHomeScreenState extends State<FacultyHomeScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final Auth auth = Provider.of<Auth>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Logut',
      content: Text(
        'Are you sure about logging out?',
        style: Theme.of(context).textTheme.bodyText1,
      ),
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    print(widget.user.userType);
    print('-------------------------------');
    return new WillPopScope(
      onWillPop: () async {
        Fluttertoast.showToast(msg: "Cant go back");
        return false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: constantAppBar(
          title: "Faculty Home Screen",
          actionWidgets: <Widget>[
            TextButton(
              onPressed: () => _confirmSignOut(context),
              child: Text(
                'Logout',
                style: theme.textTheme.button,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Container(child: FacultyCourseGrid(user: widget.user)),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => navigateToFacultyCreateCourse(context, widget.user),
        ),
      ),
    );
  }
}
