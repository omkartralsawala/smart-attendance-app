import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  @required
  final Widget child;
  final Color color;
  final double borderRadius;
  final double height;
  final VoidCallback? onPressed;
  CustomRaisedButton({
    required this.child,
    required this.color,
    this.borderRadius: 5.0,
    this.height: 50.0,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        child: child,
        style: ElevatedButton.styleFrom(
          primary: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
