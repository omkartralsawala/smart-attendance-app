import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_app/providers/auth.dart';
import 'package:student_app/providers/database.dart';
import 'package:student_app/screens/landing_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Auth>(create: (_) => Auth()),
        Provider<Database>(create: (_) => Database())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Attendance App',
        theme: ThemeData(
          primaryColor: Colors.lime,
          accentColor: Colors.limeAccent,
        ),
        home: LandingScreen(),
      ),
    );
  }
}
