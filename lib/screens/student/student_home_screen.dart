// Lsit of courses student has enrolled in
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:smart_attendance_app/models/user.dart';
import 'package:smart_attendance_app/providers/auth.dart';
import 'package:smart_attendance_app/providers/database.dart';
import 'package:smart_attendance_app/widgets/appbar/appbar.dart';
import 'package:smart_attendance_app/widgets/dialog_box/platform_alert_dialog.dart';
import 'package:smart_attendance_app/widgets/gridview/all_courses_grid.dart';
import 'package:smart_attendance_app/widgets/gridview/enrolled_courses_grid.dart';

class StudentHomeScreen extends StatefulWidget {
  final UserModel user;

  const StudentHomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _StudentHomeScreenState createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  bool _isLoading = false;
  bool _addCourse = false;
  Future<void> _signOut() async {
    try {
      final Auth auth = Provider.of<Auth>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    checkUserType();
  }

  void checkUserType() {
    if (widget.user.userType != "Student") {
      Fluttertoast.showToast(msg: "Faculty cannot login in Student Account");
      _signOut();
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
      _signOut();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Database database = Provider.of(context, listen: false);
    print(widget.user);
    final ThemeData theme = Theme.of(context);
    return StreamBuilder<UserModel>(
        stream: database.streamUser(widget.user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              UserModel? newUser = snapshot.data;
              return Scaffold(
                appBar: constantAppBar(
                  title: "Student Home Screen",
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
                  child: Center(
                    child: !_isLoading
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: newUser!.enrolledCourses!.length == 0 ||
                                    _addCourse
                                ? [
                                    Spacer(),
                                    Text("""Add Courses\n\n\n\n All Courses""",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6),
                                    Spacer(),
                                    Expanded(
                                        flex: 6,
                                        child: AllCoursesGrid(user: newUser))
                                  ]
                                : [
                                    Expanded(
                                      child: EnrolledCourses(
                                        enrolledCourseList:
                                            newUser.enrolledCourses!,
                                        user: newUser,
                                      ),
                                    )
                                  ],
                          )
                        : CircularProgressIndicator(),
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  child: Icon(!_addCourse ? Icons.add : Icons.done),
                  onPressed: () => setState(() => _addCourse = !_addCourse),
                  tooltip: "Add a new Course",
                ),
              );
            }
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
