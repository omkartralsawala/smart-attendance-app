import 'package:flutter/material.dart';
import 'package:smart_attendance_app/models/attendance_entry.dart';

class AttendanceCard extends StatelessWidget {
  final AttendanceEntry entry;

  const AttendanceCard({Key? key, required this.entry}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final TextTheme theme = Theme.of(context).textTheme;
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              entry.name,
              style: theme.headline4,
            ),
            Text(
              entry.id,
              style: theme.bodyText2,
            ),
          ],
        ),
      ),
    );
  }
}
