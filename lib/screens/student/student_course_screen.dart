// Specific student selected course showing his attendance percentage and list of entries in this subject
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_attendance_app/models/course.dart';
import 'package:smart_attendance_app/models/user.dart';
import 'package:smart_attendance_app/services/api_path.dart';
import 'package:smart_attendance_app/widgets/appbar/appbar.dart';

class StudentCourseScreen extends StatefulWidget {
  final Course course;
  final UserModel user;

  const StudentCourseScreen(
      {Key? key, required this.course, required this.user})
      : super(key: key);

  @override
  _StudentCourseScreenState createState() => _StudentCourseScreenState();
}

class _StudentCourseScreenState extends State<StudentCourseScreen> {
  int lecturesAttended = 0;
  bool _isLoading = false;
  Future<void> fetchAttendance() async {
    setState(() {
      _isLoading = true;
    });
    FirebaseFirestore.instance
        .collection(ApiPath.attendanceCollection())
        .snapshots()
        .map((attendanceEvent) {
      // attendanceEvent.docs.forEach((element) {
      //   print(element.id);
      // });

      return attendanceEvent.docs.map((attendanceDoc) async {
        print(attendanceDoc.id);
        print(widget.user.uid);
        bool docExists = await FirebaseFirestore.instance
            .collection(ApiPath.courseAttendanceDate(
                widget.course.id!, attendanceDoc.id))
            .where('studentId', isEqualTo: widget.user.uid)
            .get()
            .then((value) => value.docs.length == 1);
        print(docExists);
        if (docExists) {
          setState(() {
            lecturesAttended = lecturesAttended += 1;
          });
        }
        print("Inner Loop" + lecturesAttended.toString());
      }).toList();
    }).toList();
    print("Outer loop" + lecturesAttended.toString());
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchAttendance();
  }

  calcAttendance(int totalLectures, int attendedLectures) =>
      ((attendedLectures / totalLectures) * 100).roundToDouble();
  @override
  Widget build(BuildContext context) {
    final TextTheme theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: constantAppBar(showBackButton: true),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    _rowElement([
                      subTitleText(context, "Name"),
                      titleText(context, widget.course.name),
                    ]),
                    _rowElement([
                      subTitleText(context, "Code"),
                      titleText(context, widget.course.code),
                    ]),
                    _rowElement([
                      subTitleText(context, "Starts At"),
                      titleText(context, widget.course.startTime),
                    ]),
                    _rowElement([
                      subTitleText(context, "endsAt"),
                      titleText(context, widget.course.endTime),
                    ])
                  ],
                ),
              ),
            ),
            Expanded(
              child: !_isLoading
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _rowElement([
                            Text(
                              "Total Lectures",
                              style: theme.headline6,
                            ),
                            Text(
                              widget.course.lecturesHeld.toString(),
                              style: theme.headline5,
                            ),
                          ]),
                          _rowElement([
                            Text(
                              "Lectures Attended",
                              style: theme.headline6,
                            ),
                            Text(
                              lecturesAttended.toString(),
                              style: theme.headline5,
                            ),
                          ]),
                          Text(
                            "${calcAttendance(widget.course.lecturesHeld, lecturesAttended).toString()} %",
                            style: theme.headline4,
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _rowElement(List<Widget> children) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children,
      );

  Widget titleText(BuildContext context, String text) =>
      Text(text, style: Theme.of(context).textTheme.headline4);

  Widget subTitleText(BuildContext context, String text) =>
      Text(text, style: Theme.of(context).textTheme.headline5);
}
