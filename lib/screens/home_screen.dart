import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_attendance_app/models/course.dart';
import 'package:smart_attendance_app/providers/database.dart';
import 'package:smart_attendance_app/screens/create_course_screen.dart';
import 'package:smart_attendance_app/widgets/appbar/appbar.dart';
import 'package:smart_attendance_app/widgets/card/course_card.dart';
import '../widgets/dialog_box/platform_alert_dialog.dart';
import '../providers/auth.dart';
import '../models/user.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home_screen";
  final UserModel user;
  HomeScreen({required this.user});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
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

  void navigateTo() => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CreateCourseScreen(
            userModel: widget.user,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Database database = Provider.of(context, listen: false);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: constantAppBar(
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
        child: Container(
          child: StreamBuilder<List<Course>>(
              stream: database.streamCourses(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    List<Course>? data = snapshot.data;
                    return data!.isNotEmpty
                        ? GridView(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            children:
                                data.map((e) => CourseCard(course: e)).toList())
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  '''Dont see your course? 
                                  \nWhy not create One?''',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 25),
                                ),
                              ),
                            ],
                          );
                  } else
                    return Center(
                      child: Text('Snapshot has no data'),
                    );
                } else if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                else
                  return Center(
                    child: Text('Check internet connection'),
                  );
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => navigateTo(),
      ),
    );
  }
}
