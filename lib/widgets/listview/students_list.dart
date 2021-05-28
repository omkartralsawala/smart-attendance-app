import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_attendance_app/models/attendance_entry.dart';
import 'package:smart_attendance_app/models/course.dart';
import 'package:smart_attendance_app/providers/database.dart';
import 'package:smart_attendance_app/widgets/card/attendance_card.dart';

class StudentList extends StatelessWidget {
  final String dateString;
  final Course course;

  const StudentList({Key? key, required this.dateString, required this.course})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Database database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<AttendanceEntry>>(
        stream: database.streamAttendance(dateString, course),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              List<AttendanceEntry>? data = snapshot.data;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Today's attendance length",
                          style: theme.textTheme.headline5),
                      Text("${data!.length}", style: theme.textTheme.headline4),
                    ],
                  )),
                  // Spacer(),
                  SizedBox(height: 10),
                  Expanded(
                      flex: 6,
                      child: ListView(
                        children: data
                            .map((e) => Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: AttendanceCard(entry: e),
                                ))
                            .toList(),
                      ))
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
        });
  }
}
