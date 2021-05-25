import 'package:flutter/material.dart';
import 'package:smart_attendance_app/widgets/appbar.dart';

import '../../widgets/forms/email_sign_in_form.dart';

class EmailSignInPage extends StatelessWidget {
  static const routeName = "/email-sign-in";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: constantAppBar(),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: EmailSignInForm(),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
