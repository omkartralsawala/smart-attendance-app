import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../../widgets/Validators/validators.dart';
import '../../widgets/buttons/submit_button.dart';
import '../../widgets/dialog_box/platform_exception_alert_dialog.dart';
import '../../widgets/text_fields/custom_text_field.dart';

import '../../providers/auth.dart';

class ForgotPasswordForm extends StatefulWidget with Validators {
  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  String get _email => _emailController.text;
  bool _submitted = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: _buildChildren(),
    );
  }

  Widget _buildChildren() {
    final Size size = MediaQuery.of(context).size;
    final ThemeData theme = Theme.of(context);
    bool submitEnabled = widget.emailValidator.isValid(_email) && !_isLoading;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(height: 0.15 * size.height),
        Center(
          child: Text(
            "Forgot Password",
            style: theme.textTheme.headline1!.copyWith(
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 0.05 * size.height),
        Image.asset(
          "assets/ForgetPassword/drawable-hdpi/password.png",
          height: 200,
          width: 100,
        ),
        SizedBox(height: 0.18 * size.height),
        _buildEmailTextField(),
        SizedBox(height: 0.09 * size.height),
        SubmitButton(
          color: Theme.of(context).primaryColor,
          text: 'Submit',
          onPressed: submitEnabled ? _submit : null,
        ),
        SizedBox(height: 0.05 * size.height),
      ],
    );
  }

  CustomTextField _buildEmailTextField() {
    bool showErrorText = _submitted && !widget.emailValidator.isValid(_email);
    return CustomTextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      labelText: 'Email',
      hintText: 'test@test.com',
      errorText: showErrorText ? widget.invalidEmailError : null,
      enabled: _isLoading == false,
      inputType: TextInputType.emailAddress,
      inputAction: TextInputAction.next,
      onChanged: (email) => _updateState(),
      onEditingComplete: _submit,
    );
  }

  _updateState() {
    setState(() {});
  }

  Future<void> _submit() async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      await auth.resetPassword(_email);
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionALertDialog(
        title: 'sending reset email failed',
        exception: e,
      ).show(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
