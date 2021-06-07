import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './platform_alert_dialog.dart';

class PlatformExceptionALertDialog extends PlatformAlertDialog {
  PlatformExceptionALertDialog({
    required String title,
    required PlatformException exception,
  }) : super(
          title: title,
          content: Text(exception.message!),
          defaultActionText: 'OK',
        );

  static String message(PlatformException exception) {
    print(exception);
    return _errors[exception.code] ?? exception.message!;
  }

  static Map<String, String> _errors = {
    'ERROR_WEAK_PASSWORD': 'the password is not strong enough',
    'ERROR_INVALID_EMAIL': 'the email address is incorrect',
    'ERROR_EMAIL_ALREADY_IN_USE':
        'the email is already in use by a different account',
    'ERROR_WRONG_PASSWORD': 'The password is invalid',
    'ERROR_USER_NOT_FOUND':
        'there is no user corresponding to the given email address',
    'ERROR_USER_DISABLED': 'If the user has been disabled',
    'ERROR_TOO_MANY_REQUESTS':
        'If there was too many attempts to sign in as this user',
    'ERROR_OPERATION_NOT_ALLOWED': 'Email & Password accounts are not enabled',
  };
}
