import 'package:flutter/material.dart';
import 'package:smart_attendance_app/widgets/appbar/appbar.dart';

import '../../widgets/forms/forgot_password_form.dart';

class ForgotPasswordPage extends StatelessWidget {
  static const routeName = '/forgot-password-page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: constantAppBar(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            alignment: Alignment.centerLeft,
            image: AssetImage(
                "assets/Login/drawable-hdpi/table-in-vintage-restaurant-6267.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(1),
              BlendMode.dstATop,
            ),
          ),
        ),
        padding: const EdgeInsets.all(8.0),
        child: ForgotPasswordForm(),
      ),
    );
  }
}
