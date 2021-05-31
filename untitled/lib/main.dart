import 'package:flutter/material.dart';
import 'package:untitled/app/landing-page.dart';
import 'package:untitled/services/auth.dart';

void main () => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  title: 'Time Tracker',
      theme: ThemeData(
        primarySwatch: Colors.indigo,

      ),
      home: LandingPage(
        auth: Auth(),
      ),
    );
  }
}
