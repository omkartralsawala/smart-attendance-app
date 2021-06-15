import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_attendance_app/models/attendance_entry.dart';
import 'package:smart_attendance_app/models/course.dart';
import 'package:smart_attendance_app/services/api_path.dart';

class AttendanceCard extends StatefulWidget {
  final AttendanceEntry entry;
  final Course course;

  const AttendanceCard({Key? key, required this.entry, required this.course})
      : super(key: key);

  @override
  _AttendanceCardState createState() => _AttendanceCardState();
}

class _AttendanceCardState extends State<AttendanceCard> {
  bool _isLoading = false;
  int lecturesAttended = 0;

  @override
  void initState() {
    super.initState();
    fetchAttendance();
  }

  Future<void> fetchAttendance() async {
    setState(() {
      _isLoading = true;
    });
    FirebaseFirestore.instance
        .collection(ApiPath.attendanceCollection())
        .snapshots()
        .map((attendanceEvent) {
      return attendanceEvent.docs.map((attendanceDoc) async {
        print(attendanceDoc.id);
        print(widget.entry.uid);
        bool docExists = await FirebaseFirestore.instance
            .collection(ApiPath.courseAttendanceDate(
                widget.course.id!, attendanceDoc.id))
            .where('studentId', isEqualTo: widget.entry.uid)
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
  Widget build(BuildContext context) {
    final TextTheme theme = Theme.of(context).textTheme;
    return Card(
      child: !_isLoading
          ? Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        widget.entry.name,
                        style: theme.headline4,
                      ),
                      Text(
                        widget.entry.id,
                        style: theme.bodyText2,
                      ),
                    ],
                  ),
                  Text(lecturesAttended.toString())
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
