/*
* Created by IT17106016-Lokugamage G.N.
* Implementation of welcome page
* */

//import packages
import 'package:ctsefamilyapp/firestore.dart';
import 'package:ctsefamilyapp/loginsignup/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class WelcomeFragment extends StatefulWidget {
  WelcomeFragment(
      {Key key, this.auth, this.store, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final BaseStore store;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _WelcomeFragmentState();
}

class _WelcomeFragmentState extends State<WelcomeFragment> {
  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  Material myItems(IconData icon, String heading, Color color) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      shadowColor: Colors.black,
      borderRadius: BorderRadius.circular(24.0),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        heading,
                        style: TextStyle(color: color, fontSize: 20.0),
                      ),
                    ),
                  ),
                  Material(
                    color: color,
                    borderRadius: BorderRadius.circular(24.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(
                        icon,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StaggeredGridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: <Widget>[
          myItems(FontAwesomeIcons.tree, "Family Tree", Colors.green),
          myItems(FontAwesomeIcons.idCard, "Members", Colors.red),
          myItems(LineAwesomeIcons.user, "Profile", Colors.deepPurple),
          myItems(LineAwesomeIcons.user_plus, "Add Members", Colors.grey),
          myItems(LineAwesomeIcons.question_circle, "About", Colors.amber),
          myItems(LineAwesomeIcons.exclamation, "Help", Colors.pink),
        ],
        staggeredTiles: [
          StaggeredTile.extent(2, 130),
          StaggeredTile.extent(1, 150),
          StaggeredTile.extent(1, 150),
          StaggeredTile.extent(2, 240),
          StaggeredTile.extent(1, 150),
          StaggeredTile.extent(1, 150),
        ],
      ),
    );
  }
}
