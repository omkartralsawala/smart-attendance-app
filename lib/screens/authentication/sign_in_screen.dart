import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:smart_attendance_app/providers/auth.dart';
import 'package:smart_attendance_app/widgets/appbar.dart';

import '../../widgets/buttons/social_sign_in_button.dart';
import '../../widgets/buttons/sign_in_button.dart';
import '../../screens/authentication/email_sign_in_screen.dart';

class SignInPage extends StatefulWidget {
  static const routeName = "/sign-in-page";
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isLoading = false;

  void _showSignInError(BuildContext context, PlatformException exception) {
    Fluttertoast.showToast(msg: exception.message.toString());
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      setState(() => _isLoading = true);
      final auth = Provider.of<Auth>(context, listen: false);
      await auth.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: constantAppBar(),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    // final Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Spacer(flex: 2),
          Expanded(
            flex: 6,
            child: SizedBox(
              height: 50.0,
              child: _buildHeader(),
            ),
          ),
          Spacer(flex: 2),
          Expanded(
            child: SocialSignInButton(
              assetName: "assets/images/google-logo.png",
              text: 'Sign in with Google',
              textColor: Colors.black87,
              color: Colors.white,
              onPressed: _isLoading ? null : () => _signInWithGoogle(context),
            ),
          ),
          Spacer(),
          Expanded(
            child: Text(
              'or',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: SignInButton(
              text: 'Sign in with email',
              textColor: Colors.black,
              color: Theme.of(context).primaryColor,
              onPressed: _isLoading ? null : () => _signInWithEmail(context),
            ),
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      'Sign in',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headline4!,
    );
  }
}
