import 'package:flutter/material.dart';

AppBar constantAppBar({
  List<Widget>? actionWidgets,
  bool showBackButton = false,
  String? title,
}) {
  return AppBar(
    centerTitle: true,
    leading: showBackButton ? null : Container(),
    title: Text(title == null ? "Smart Attendance App" : title),
    actions: actionWidgets,
  );
}
