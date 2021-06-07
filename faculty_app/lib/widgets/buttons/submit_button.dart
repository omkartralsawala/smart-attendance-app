import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import './custom_raised_button.dart';

class SubmitButton extends CustomRaisedButton {
  SubmitButton({
    required String text,
    Color color = Colors.white,
    VoidCallback? onPressed,
  }) : super(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          height: 50.0,
          color: color,
          borderRadius: 10.0,
          onPressed: onPressed,
        );
}
