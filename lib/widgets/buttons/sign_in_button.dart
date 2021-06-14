import 'package:flutter/material.dart';

import './custom_raised_button.dart';

class SignInButton extends CustomRaisedButton {
  SignInButton({
    required String text,
    required Color color,
    required Color textColor,
    VoidCallback? onPressed,
  }) : super(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              letterSpacing: 1.5,
              fontSize: 19.0,
            ),
          ),
          color: color,
          onPressed: onPressed,
        );
}
