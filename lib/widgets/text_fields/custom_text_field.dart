import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? errorText;
  final bool enabled;
  final bool obscureText;
  final bool autoFocus;
  final Function(String) onChanged;
  final Function onEditingComplete;
  final String? hintText;
  final String labelText;
  final TextInputAction inputAction;
  final TextInputType inputType;
  CustomTextField({
    required this.controller,
    required this.focusNode,
    this.enabled = true,
    this.errorText,
    required this.onChanged,
    required this.onEditingComplete,
    required this.labelText,
    this.autoFocus = false,
    this.obscureText = false,
    this.hintText,
    this.inputAction = TextInputAction.next,
    this.inputType = TextInputType.text,
  });
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.black,
      ),
      child: TextField(
        style: TextStyle(color: Colors.black),
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          labelStyle: TextStyle(
            fontSize: 17,
            color: Colors.black,
          ),
          labelText: labelText,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          focusColor: Colors.black,
          errorText: errorText,
        ),
        cursorColor: Colors.black,
        autocorrect: false,
        autofocus: autoFocus,
        enabled: enabled,
        keyboardType: inputType,
        textInputAction: inputAction,
        onChanged: onChanged,
        onEditingComplete: () => onEditingComplete,
        obscureText: obscureText,
      ),
    );
  }
}
