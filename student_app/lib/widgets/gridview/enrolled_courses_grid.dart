import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_app/models/course.dart';
import 'package:student_app/models/user.dart';
import 'package:student_app/providers/database.dart';
import 'package:student_app/screens/student/student_course_screen.dart';
import 'package:student_app/widgets/card/course_card.dart';

class EnrolledCourses extends StatefulWidget {
  final UserModel user;
  final List<String> enrolledCourseList;
  const EnrolledCourses(
      {Key? key, required this.enrolledCourseList, required this.user})
      : super(key: key);

  @override
  _EnrolledCoursesState createState() => _EnrolledCoursesState();
}

class _EnrolledCoursesState extends State<EnrolledCourses> {
  List<Course> courses = [];
  bool _isLoading = false;

  void _getCourseFromIds() async {
    final Database database = Provider.of<Database>(context, listen: false);
    setState(() {
      _isLoading = true;
    });
    widget.enrolledCourseList.map((courseId) async {
      Course course = await database.getCourse(courseId);
      setState(() {
        courses.add(course);
      });
    }).toList();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getCourseFromIds();
  }

  @override
  Widget build(BuildContext context) {
    return !_isLoading
        ? GridView(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            children: courses
                .map((selectedCourse) => CourseCard(
                      course: selectedCourse,
                      user: widget.user,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StudentCourseScreen(
                            course: selectedCourse,
                            user: widget.user,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
