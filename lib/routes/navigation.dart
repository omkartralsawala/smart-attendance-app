import 'package:flutter/material.dart';
import 'package:smart_attendance_app/models/user.dart';
import 'package:smart_attendance_app/screens/faculty/faculty_create_course_screen.dart';
import 'package:smart_attendance_app/screens/landing_screen.dart';

void navigateToLanding(BuildContext context, String userType) =>
    Navigator.pushNamed(
      context,
      LandingScreen.routeName,
      arguments: LandingScreenArgs(userType: userType),
    );

void navigateToFacultyCreateCourse(BuildContext context, UserModel user) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FacultyCreateCourseScreen(userModel: user),
      ),
    );
