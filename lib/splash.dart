/*Created by IT17106016-Lokugamage G.N.
referenced code from https://morioh.com/p/98894cc3a48d */

//import packages
import 'package:ctsefamilyapp/firestore.dart';
import 'package:ctsefamilyapp/loginsignup/authentication.dart';
import 'package:ctsefamilyapp/loginsignup/root_page.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => new _SplashState();
}

/*This class build the splash widget on the start of the application*/
class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      //Number of seconds splash screen shows
        seconds: 4,
        //After above defined seconds app navigate to the RootPage
        //pass the instance of Auth class and Store class to the RootPage by using constructor
        navigateAfterSeconds: new RootPage(
          auth: new Auth(),
          store: new Store(),
        ),
        title: new Text(
          'WeFamily',
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        image: new Image(
          image: AssetImage('splash.png'),
        ),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 150.0,
        loaderColor: Colors.red);
  }
}

