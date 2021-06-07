import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './platform_widget.dart';

class PlatformAlertDialog extends PlatformWidget {
  final String title;
  final Widget content;
  final String? cancelActionText;
  final String defaultActionText;
  final Function? actionHandler;
  PlatformAlertDialog({
    required this.content,
    required this.defaultActionText,
    this.cancelActionText,
    required this.title,
    this.actionHandler,
  });
  Future<bool?> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog<bool>(
            context: context,
            builder: (context) => this,
          )
        : await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (context) => this,
          );
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        title,
        style: Theme.of(context).textTheme.subtitle1,
      ),
      content: content,
      actions: _buildActions(context),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      content: content,
      // Text(
      //   content,
      //   style: Theme.of(context).textTheme.subtitle1,
      // ),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final actions = <Widget>[];
    if (cancelActionText != null) {
      actions.add(
        PlatformAlertDialogAction(
          child: Text(cancelActionText!),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      );
    }
    actions.add(
      PlatformAlertDialogAction(
        child: Text(defaultActionText),
        onPressed: actionHandler != null
            ? () => actionHandler
            : () => Navigator.of(context).pop(true),
      ),
    );
    return actions;
  }
}

class PlatformAlertDialogAction extends PlatformWidget {
  final Widget child;
  final VoidCallback onPressed;
  PlatformAlertDialogAction({
    required this.child,
    required this.onPressed,
  });

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoDialogAction(
      child: child,
      onPressed: onPressed,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return TextButton(
      child: child,
      onPressed: onPressed,
    );
  }
}
