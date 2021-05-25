import 'package:flutter/material.dart';

AppBar constantAppBar({List<Widget>? actionWidgets}) {
  return AppBar(
    centerTitle: true,
    title: Text("Smart Attendance App"),
    actions: actionWidgets,
  );
}
