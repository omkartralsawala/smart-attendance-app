import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:smart_attendance_app/screens/authentication/student_email_regiser_screen.dart';

import '../../widgets/Validators/validators.dart';
import '../../widgets/buttons/submit_button.dart';
import '../../widgets/dialog_box/platform_exception_alert_dialog.dart';
import '../../widgets/text_fields/custom_text_field.dart';

import '../../screens/authentication/faculty_email_register_screen.dart';
import '../../screens/authentication/forgot_password_screen.dart';

import '../../providers/auth.dart';

class EmailSignInForm extends StatefulWidget with Validators {
  final String userType;

  EmailSignInForm({Key? key, required this.userType}) : super(key: key);
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  bool _submitted = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      final Auth auth = Provider.of<Auth>(context, listen: false);
      await auth.signInWithEmailAndPassword(_email, _password, widget.userType);
      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _emailEditingComplete() {
    final newFocus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  List<Widget> _buildChildren() {
    final primaryText = 'Sign in';
    final secondaryText = 'Need an account? Register';

    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordVaidator.isValid(_password) &&
        !_isLoading;

    return [
      Text(
        'Sign in to your ${widget.userType} account!',
        style: Theme.of(context).textTheme.headline4!,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10),
        child: _buildEmailTextField(),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: _buildPasswordTextField(),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: SubmitButton(
          text: primaryText,
          onPressed: submitEnabled ? _submit : null,
          color: Theme.of(context).primaryColor,
        ),
      ),
      TextButton(
        child: Text(
          secondaryText,
          style: Theme.of(context).textTheme.bodyText1!,
        ),
        onPressed: !_isLoading
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => widget.userType == 'Faculty'
                        ? FacultyRegisterEmailPage(userType: widget.userType)
                        : StudentEmailRegisterScreen(userType: widget.userType),
                  ),
                );
              }
            : null,
      ),
      TextButton(
        child: Text(
          "Forgot password",
          style: Theme.of(context).textTheme.bodyText2!,
        ),
        onPressed: !_isLoading
            ? () =>
                Navigator.of(context).pushNamed(ForgotPasswordPage.routeName)
            : null,
      ),
    ];
  }

  CustomTextField _buildPasswordTextField() {
    bool showErrorText =
        _submitted && !widget.passwordVaidator.isValid(_password);
    return CustomTextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      labelText: 'Password',
      errorText: showErrorText ? widget.invalidPasswordError : null,
      enabled: _isLoading == false,
      obscureText: true,
      inputAction: TextInputAction.done,
      onChanged: (password) => _updateState(),
      onEditingComplete: _submit,
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
      onEditingComplete: _emailEditingComplete,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: _buildChildren(),
    );
  }

  void _updateState() {
    setState(() {});
  }
}
