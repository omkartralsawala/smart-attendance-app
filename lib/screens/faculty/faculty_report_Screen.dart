import 'package:flutter/material.dart';
import 'package:horizontal_calendar_widget/horizontal_calendar.dart';
import 'package:provider/provider.dart';
import 'package:smart_attendance_app/models/attendance_entry.dart';
import 'package:smart_attendance_app/models/course.dart';
import 'package:smart_attendance_app/providers/database.dart';
import 'package:smart_attendance_app/widgets/appbar/appbar.dart';
import 'package:smart_attendance_app/widgets/card/attendance_card.dart';

class FacultyReportScreen extends StatefulWidget {
  final Course course;

  const FacultyReportScreen({Key? key, required this.course}) : super(key: key);

  @override
  _FacultyReportScreenState createState() => _FacultyReportScreenState();
}

class _FacultyReportScreenState extends State<FacultyReportScreen> {
  final DateTime today = DateTime.now();
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedDate = today;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Database database = Provider.of<Database>(context, listen: false);
    final String dateString = _selectedDate.toString().split(" ")[0];
    print(dateString);
    print('----------------------------');
    return Scaffold(
      appBar: constantAppBar(showBackButton: true),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.black,
                  child: HorizontalCalendar(
                    firstDate: DateTime(2021, 1, 1),
                    lastDate: today,
                    initialSelectedDates: [today],
                    onDateSelected: (dateTime) =>
                        setState(() => _selectedDate = dateTime),
                    dateTextStyle: TextStyle(fontSize: 20, color: Colors.white),
                    monthTextStyle:
                        TextStyle(fontSize: 18, color: Colors.white),
                    weekDayTextStyle:
                        TextStyle(fontSize: 18, color: Colors.white),
                    maxSelectedDateCount: 1,
                    selectedDateTextStyle:
                        TextStyle(fontSize: 30, color: Colors.grey[800]),
                    padding: EdgeInsets.only(left: 10, right: 10),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: StreamBuilder<List<AttendanceEntry>>(
                    stream:
                        database.streamAttendance(dateString, widget.course),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        if (snapshot.hasData) {
                          List<AttendanceEntry>? data = snapshot.data;
                          return ListView(
                            children: data!
                                .map((e) => AttendanceCard(
                                      entry: e,
                                      course: widget.course,
                                    ))
                                .toList(),
                          );
                        }
                        return Center(
                          child: Text("Snapshot has no data"),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else
                        return Center(
                          child: Text("Check internet connection"),
                        );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
