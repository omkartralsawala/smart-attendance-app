import 'package:flutter/material.dart';

import './custom_raised_button.dart';

class SocialSignInButton extends CustomRaisedButton {
  SocialSignInButton({
    required String assetName,
    required String text,
    Color color = Colors.white,
    Color textColor = Colors.black,
    VoidCallback? onPressed,
  }) : super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset(assetName),
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
              Opacity(
                child: Image.asset(assetName),
                opacity: 0.0,
              )
            ],
          ),
          color: color,
          onPressed: onPressed,
        );
}
