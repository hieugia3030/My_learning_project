import 'package:flutter/material.dart';
import 'package:untitled/app/landing-page.dart';
import 'package:untitled/services/auth.dart';
import 'package:provider/provider.dart';

void main () => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) =>  Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
  title: 'Time Tracker',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: LandingPage(),
      ),
    );
  }
}
