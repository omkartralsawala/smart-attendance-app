import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_attendance_app/widgets/appbar.dart';
import '../widgets/dialog_box/platform_alert_dialog.dart';
import '../providers/auth.dart';
import '../models/user.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home_screen";
  final UserModel? user;
  HomeScreen({this.user});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // bool _isSubscribed = false;
  // bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _initTabController();
  }

  void _initTabController() {
    _tabController = TabController(length: 3, initialIndex: 0, vsync: this);
    _tabController.addListener(_handleTabIndex);
  }

  void _handleTabIndex() => setState(() {});

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Logut',
      content: Text(
        'Are you sure about logging out?',
        style: Theme.of(context).textTheme.bodyText1,
      ),
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: constantAppBar(
        actionWidgets: <Widget>[
          TextButton(
            onPressed: () => _confirmSignOut(context),
            child: Text(
              'Logout',
              style: theme.textTheme.button,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
