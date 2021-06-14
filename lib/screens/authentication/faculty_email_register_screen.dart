import 'package:flutter/material.dart';
import 'package:smart_attendance_app/widgets/appbar/appbar.dart';

import '../../widgets/forms/faculty_email_register_form.dart';

class FacultyRegisterEmailPage extends StatelessWidget {
  static const routeName = '/register-page';
  final String userType;

  const FacultyRegisterEmailPage({Key? key, required this.userType})
      : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: constantAppBar(showBackButton: true),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(8.0),
        child: FacultyRegisterEmailForm(userType: userType),
      ),
    );
  }
}
