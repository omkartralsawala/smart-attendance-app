import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:smart_attendance_app/models/user.dart';
import 'package:smart_attendance_app/providers/database.dart';

import '../Validators/validators.dart';
import '../buttons/submit_button.dart';
import '../dialog_box/platform_exception_alert_dialog.dart';
import '../text_fields/custom_text_field.dart';

import '../../providers/auth.dart';

class FacultyRegisterEmailForm extends StatefulWidget with Validators {
  final String userType;

  FacultyRegisterEmailForm({Key? key, required this.userType}) : super(key: key);
  @override
  _FacultyRegisterEmailFormState createState() => _FacultyRegisterEmailFormState();
}

class _FacultyRegisterEmailFormState extends State<FacultyRegisterEmailForm> {
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
      final Database database = Provider.of<Database>(context, listen: false);
      final UserModel? user = await auth.createUserWithEmailAndPassword(
          _email, _password, widget.userType);
      if (user != null) {
        await database.setUser(user);
      }
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionALertDialog(
        title: 'Sign in failed',
        exception: e,
      ).show(context);
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
    final primaryText = 'Create an account';

    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordVaidator.isValid(_password) &&
        !_isLoading;

    return [
      Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: Text(
          "Welcome to Smart Attendance App!!",
          style: Theme.of(context).textTheme.headline4!,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: Text("Let's get you started!",
            style: Theme.of(context).textTheme.headline5!),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
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
        ),
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
