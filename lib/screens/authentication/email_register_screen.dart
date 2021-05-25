import 'package:flutter/material.dart';
import 'package:smart_attendance_app/widgets/appbar.dart';

import '../../widgets/forms/email_register.dart';

class RegisterEmailPage extends StatelessWidget {
  static const routeName = '/register-page';

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: constantAppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(8.0),
        child: RegisterEmailForm(),
      ),
    );
  }
}
