import 'package:ctsefamilyapp/loginsignup/authentication.dart';
import 'package:ctsefamilyapp/models/family_memeber.dart';
import 'package:ctsefamilyapp/family_member_upload.dart';
import 'package:ctsefamilyapp/photo_upload.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class HomePageFamily extends StatefulWidget {
  HomePageFamily({
    this.auth,
    this.onSignedOut,
  });

  final BaseAuth auth;
  final VoidCallback onSignedOut;

  @override
  _HomePageFamilyState createState() => _HomePageFamilyState();
}

class _HomePageFamilyState extends State<HomePageFamily> {
  List<FamilyMember> familyMemberList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    DatabaseReference postsRef =
        FirebaseDatabase.instance.reference().child("FamilyMembers");

    postsRef.once().then((DataSnapshot snap) {
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      familyMemberList.clear();

      for (var individualKey in KEYS) {
        FamilyMember familyMember = new FamilyMember(
          DATA[individualKey]['givenName'],
          DATA[individualKey]['familyName'],
          DATA[individualKey]['birthDate'],
          DATA[individualKey]['gender'],
          DATA[individualKey]['age'],
          DATA[individualKey]['image'],
        );

        familyMemberList.add(familyMember);
      }

      setState(() {
        print('Length : $familyMemberList.length');
      });
    });
  }

  void _logoutUser() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Family Members'),
      ),
      body: Container(
        child: familyMemberList.length == 0
            ? Text('No Posts')
            : new ListView.builder(
                itemBuilder: (_, index) {
                  return FamilyMemberUI(
                    familyMemberList[index].image,
                    familyMemberList[index].givenName,
                    familyMemberList[index].familyName,
                    familyMemberList[index].birthDate,
                    familyMemberList[index].gender,
                    familyMemberList[index].age,
                  );
                },
                itemCount: familyMemberList.length,
              ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.pink,
        child: Container(
          margin: EdgeInsets.only(left: 50.0, right: 50.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.local_car_wash),
                iconSize: 50,
                color: Colors.white,
                onPressed: _logoutUser,
              ),

//              IconButton(
//                icon: Icon(Icons.add_a_photo),
//                iconSize: 50,
//                color: Colors.white,
//                onPressed: (){
//                  Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                          builder: (context){
//                            return new UploadPhotoPage();
//                          }
//                      )
//
//                  );
//                },
//
//              ),

              IconButton(
                icon: Icon(Icons.question_answer),
                iconSize: 50,
                color: Colors.white,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return new FamilyMemberUpload();
                  }));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget FamilyMemberUI(String image, String givenName, String familyName,
      String birthDate, String gender, String age) {
    return new Card(
      elevation: 30.0,
      color: Colors.amber,
      margin: EdgeInsets.all(15.0),
      child: new Container(
        padding: new EdgeInsets.all(14.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(image),
            ),
            SizedBox(
              width: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.tree),
                    new Text(
                      givenName,
                      style: Theme.of(context).textTheme.subtitle,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(
                  width: 20.0,
                ),
                Column(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.heart),
                    new Text(
                      givenName,
                      style: Theme.of(context).textTheme.subtitle,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(
                  width: 20.0,
                ),
                Column(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.calendarDay),
                    new Text(
                      birthDate,
                      style: Theme.of(context).textTheme.subtitle,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
