/*
* Created by IT17106016-Lokugamage G.N.
* Implementation of main page
* */

//import packages
import 'package:ctsefamilyapp/splash.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WeFamily',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: Splash(),
    );
  }
}
