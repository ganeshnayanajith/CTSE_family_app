import 'package:ctsefamilyapp/firestore.dart';
import 'package:flutter/material.dart';
import 'package:ctsefamilyapp/loginsignup/root_page.dart';
import 'package:ctsefamilyapp/loginsignup/authentication.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Authentication AndroidVille',
      theme: ThemeData(
          primarySwatch: Colors.pink
      ),
      home: RootPage(
        auth: new Auth(),
        store: new Store(),
      ),
    );
  }
}
