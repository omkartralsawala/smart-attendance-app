import 'package:flutter/material.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '/models/user.dart';
import '/providers/auth.dart';
import '/providers/database.dart';
import '/widgets/appbar/appbar.dart';
import '/widgets/buttons/submit_button.dart';
import '/widgets/text_fields/custom_text_field.dart';

class StudentEmailRegisterScreen extends StatefulWidget {
  final String userType;

  const StudentEmailRegisterScreen({Key? key, required this.userType})
      : super(key: key);

  @override
  _StudentEmailRegisterScreenState createState() =>
      _StudentEmailRegisterScreenState();
}

class _StudentEmailRegisterScreenState
    extends State<StudentEmailRegisterScreen> {
  bool _isLoading = false;
  String nfcTagId = "2725696041";
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameNode = FocusNode();
  String get _name => _nameController.text;

  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailNode = FocusNode();
  String get _email => _emailController.text;
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordNode = FocusNode();
  String get _password => _passwordController.text;
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode _confirmPasswordNode = FocusNode();
  String get _confirmPassword => _confirmPasswordController.text;

  bool get submitEnable =>
      _name.isNotEmpty &&
      _email.isNotEmpty &&
      _password.isNotEmpty &&
      _confirmPassword.isNotEmpty &&
      _password == _confirmPassword;

  void updateState() => setState(() {});

  void onNameEditingComplete() {
    FocusNode newNode = _name.isNotEmpty ? _emailNode : _nameNode;
    newNode.requestFocus();
  }

  void onEmailEditingComplete() {
    FocusNode newNode = _email.isNotEmpty ? _passwordNode : _emailNode;
    newNode.requestFocus();
  }

  void onPasswordEditingComplete() {
    FocusNode newNode =
        _password.isNotEmpty ? _confirmPasswordNode : _passwordNode;
    newNode.requestFocus();
  }

  void onConfirmPasswordEditingComplete() {
    if (submitEnable) _submit();
  }

  void _scan() async => await FlutterNfcReader.read()
      .then((scanData) => setState(() => nfcTagId = scanData.id));

  void _submit() async {
    final Auth auth = Provider.of<Auth>(context, listen: false);
    final Database database = Provider.of<Database>(context, listen: false);
    _isLoading = true;
    updateState();
    try {
      UserModel? user = await auth.createUserWithEmailAndPassword(
          _email, _password, widget.userType);
      if (user != null) {
        if (nfcTagId.startsWith("Scan")) {
          Fluttertoast.showToast(msg: "Tag must be scanned to proceed");
          return;
        }
        UserModel updatedUser =
            user.copyWith(name: _name, enrolledCourses: [], nfcTag: nfcTagId);
        await database.setUser(updatedUser);
      }
      _isLoading = false;
      updateState();
      Navigator.pop(context);
    } catch (error) {
      Fluttertoast.showToast(msg: error.toString());
      _isLoading = false;
      updateState();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: constantAppBar(showBackButton: true),
      body: SafeArea(
        child: !_isLoading
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        "Student Registration",
                        style: TextStyle(fontSize: 25),
                      ),
                      constantPadding(_buildNameTextField()),
                      constantPadding(_buildEmailTextField()),
                      constantPadding(_buildPasswordTextField()),
                      constantPadding(_buildConfirmPasswordTextField()),
                      constantPadding(Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(nfcTagId, style: theme.textTheme.headline5),
                          IconButton(
                            onPressed: () => _scan(),
                            icon: Icon(Icons.nfc),
                          ),
                        ],
                      )),
                      constantPadding(SubmitButton(
                        text: "Submit",
                        color: theme.primaryColor,
                        onPressed: _submit,
                      )),
                    ],
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Widget constantPadding(Widget child) => Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10), child: child);

  CustomTextField _buildNameTextField() {
    return CustomTextField(
      controller: _nameController,
      focusNode: _nameNode,
      onChanged: (value) => updateState(),
      onEditingComplete: () => onNameEditingComplete(),
      labelText: "Full Name",
      hintText: "John Wick",
    );
  }

  CustomTextField _buildEmailTextField() {
    return CustomTextField(
      controller: _emailController,
      focusNode: _emailNode,
      onChanged: (value) => updateState(),
      onEditingComplete: () => onEmailEditingComplete(),
      labelText: "Email",
      hintText: "john.wick@edithautotech.com",
    );
  }

  CustomTextField _buildPasswordTextField() {
    return CustomTextField(
      controller: _passwordController,
      focusNode: _passwordNode,
      onChanged: (value) => updateState(),
      onEditingComplete: () => onPasswordEditingComplete(),
      labelText: "Password",
      obscureText: true,
    );
  }

  CustomTextField _buildConfirmPasswordTextField() {
    return CustomTextField(
      controller: _confirmPasswordController,
      focusNode: _confirmPasswordNode,
      onChanged: (value) => updateState(),
      onEditingComplete: () => onConfirmPasswordEditingComplete(),
      labelText: "Confirm Password",
      obscureText: true,
    );
  }
}
