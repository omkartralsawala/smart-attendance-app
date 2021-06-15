import 'package:flutter/material.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:smart_attendance_app/screens/faculty/faculty_report_Screen.dart';

import '/models/user.dart';
import '/widgets/listview/students_list.dart';
import '/models/course.dart';
import '/providers/database.dart';
import '/widgets/appbar/appbar.dart';
import '/widgets/ripple_animation.dart';

class FacultyCourseScreen extends StatefulWidget {
  final Course course;

  FacultyCourseScreen({Key? key, required this.course}) : super(key: key);

  @override
  _FacultyCourseScreenState createState() => _FacultyCourseScreenState();
}

class _FacultyCourseScreenState extends State<FacultyCourseScreen> {
  late TimeOfDay startTime;
  late TimeOfDay endTime;
  dynamic tagData;
  final String today = DateTime.now().toString().split(" ")[0];
  bool _isLoading = false;
  bool _sensorEnabled = false;
  bool _scanning = false;

  void updateStartTime(TimeOfDay time) => setState(() => startTime = time);
  void updateEndTime(TimeOfDay time) => setState(() => endTime = time);

  bool get _timeUpdated =>
      startTime != returnTimeOfDay(widget.course.startTime) ||
      endTime != returnTimeOfDay(widget.course.endTime);

  Future<void> _showTimePicker(
    TimeOfDay timeOfDay,
    void Function(TimeOfDay) handler,
  ) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: timeOfDay,
      helpText: "Select lecture start time",
    );
    if (time != null) {
      handler(time);
    }
  }

  TimeOfDay returnTimeOfDay(String dateString) {
    List<String> hm = dateString.split(" ")[0].split(":");
    return TimeOfDay(hour: int.parse(hm[0]), minute: int.parse(hm[1]));
  }

  Future<void> _submit() async {
    final Database database = Provider.of<Database>(context, listen: false);
    setState(() {
      _isLoading = true;
    });
    try {
      await database.updateCourse(
        widget.course.copyWith(
          startTime: startTime.format(context).toString(),
          endTime: endTime.format(context).toString(),
        ),
      );
    } catch (error) {
      Fluttertoast.showToast(msg: error.toString());
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      startTime = returnTimeOfDay(widget.course.startTime);
      endTime = returnTimeOfDay(widget.course.endTime);
    });
  }

  void startNfcSession() async {
    setState(() => _scanning = true);
    final Database database = Provider.of<Database>(context, listen: false);
    Fluttertoast.showToast(msg: "Session started");
    try {
      FlutterNfcReader.onTagDiscovered().listen(
        (onData) async {
          Fluttertoast.showToast(msg: "Tag Detected");
          UserModel user = await database.getUser(onData.id);
          Fluttertoast.showToast(msg: "User Found");
          try {
            await database.setAttendance(today, user, widget.course).then(
                (value) async => await database
                    .updateCourse(
                      widget.course.copyWith(
                        lecturesHeld: widget.course.lecturesHeld + 1,
                      ),
                    )
                    .whenComplete(() => Fluttertoast.showToast(
                        msg: "Total Lectures incremented")));
          } catch (err) {
            Fluttertoast.showToast(msg: err.toString());
          }
        },
      );
    } catch (error) {
      Fluttertoast.showToast(msg: error.toString());
    }
  }

  Future<void> stopNfcSession() async {
    FlutterNfcReader.stop().then((value) {
      Fluttertoast.showToast(msg: "Session Stoped");
      setState(() {
        _scanning = false;
      });
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: constantAppBar(
        showBackButton: true,
        actionWidgets: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => FacultyReportScreen(course: widget.course)),
            ),
            icon: Icon(Icons.data_usage),
          ),
          if (_timeUpdated)
            IconButton(
              onPressed: _submit,
              icon: Icon(Icons.done),
            )
        ],
      ),
      body: SafeArea(
        child: !_isLoading
            ? Column(
                children: [
                  rowElement(
                    [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Course Name",
                          style: theme.textTheme.headline5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          widget.course.name,
                          style: theme.textTheme.headline4,
                        ),
                      )
                    ],
                  ),
                  rowElement(
                    [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Course Code",
                          style: theme.textTheme.headline5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          widget.course.code,
                          style: theme.textTheme.headline4,
                        ),
                      )
                    ],
                  ),
                  rowElement(
                    [
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () => _showTimePicker(
                                startTime,
                                (value) => updateStartTime(value),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                color: theme.primaryColor,
                                child: Text(
                                  startTime.format(context).toString(),
                                  style: theme.textTheme.headline4!
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                "Start",
                                style: theme.textTheme.bodyText1,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () => _showTimePicker(
                                endTime,
                                (value) => updateEndTime(value),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                color: theme.primaryColor,
                                child: Text(
                                  endTime.format(context).toString(),
                                  style: theme.textTheme.headline4!
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text("End"),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 80),
                        child: Center(
                            child: Stack(
                          children: [
                            if (_sensorEnabled && _scanning)
                              Positioned(child: RipplesAnimation()),
                            StudentList(
                                dateString: today, course: widget.course),
                          ],
                        )),
                      ))
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_sensorEnabled) {
            stopNfcSession();
          } else {
            startNfcSession();
          }
          setState(() => _sensorEnabled = !_sensorEnabled);
        },
        elevation: 9,
        tooltip: "Will start NFC attendance",
        label: Text("${_sensorEnabled ? "Stop" : "Start"} Attendance"),
        icon: Icon(Icons.people),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

Widget rowElement(List<Widget> children) => Expanded(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    ));
