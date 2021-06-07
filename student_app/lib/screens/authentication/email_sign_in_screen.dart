import 'package:flutter/material.dart';
import 'package:student_app/widgets/appbar/appbar.dart';

import '../../widgets/forms/email_sign_in_form.dart';

class EmailSignInPage extends StatelessWidget {
  static const routeName = "/email-sign-in";
  final String userType;

  const EmailSignInPage({Key? key, required this.userType}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: constantAppBar(showBackButton: true),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child:
            SingleChildScrollView(child: EmailSignInForm(userType: userType)),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
