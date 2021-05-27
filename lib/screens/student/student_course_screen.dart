// Specific student selected course showing his attendance percentage and list of entries in this subject
import 'package:flutter/material.dart';
import 'package:smart_attendance_app/models/course.dart';
import 'package:smart_attendance_app/models/user.dart';
import 'package:smart_attendance_app/widgets/appbar/appbar.dart';

class StudentCourseScreen extends StatelessWidget {
  final Course course;
  final UserModel user;

  const StudentCourseScreen(
      {Key? key, required this.course, required this.user})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: constantAppBar(),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Expanded(
                  child: Column(
                    children: [
                      _rowElement([
                        subTitleText(context, "Name"),
                        titleText(context, course.name),
                      ]),
                      _rowElement([
                        subTitleText(context, "Code"),
                        titleText(context, course.code),
                      ]),
                      _rowElement([
                        subTitleText(context, "Starts At"),
                        titleText(context, course.startTime),
                      ]),
                      _rowElement([
                        subTitleText(context, "endsAt"),
                        titleText(context, course.endTime),
                      ])
                    ],
                  ),
                ),
              ),
              Spacer(),
              Expanded(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Attendance List"),
                    Text("Attendance Entries"),
                  ],
                ),
              ),
              Spacer()
            ],
          ),
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
