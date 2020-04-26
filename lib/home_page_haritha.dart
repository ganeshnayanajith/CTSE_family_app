import 'package:ctsefamilyapp/loginsignup/authentication.dart';
import 'package:ctsefamilyapp/family_member_upload.dart';
import 'package:ctsefamilyapp/photo_upload.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:ctsefamilyapp/models/posts.dart';


class HomePage extends StatefulWidget {

  HomePage({
    this.auth,
    this.onSignedOut,

  });

  final BaseAuth auth;
  final VoidCallback onSignedOut;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  List<Posts> postsList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    DatabaseReference postsRef = FirebaseDatabase.instance.reference().child("Members");

    postsRef.once().then((DataSnapshot snap){

      var KEYS = snap.value.keys;
      var DATA = snap.value;

      postsList.clear();


      for(var individualKey in KEYS){

        Posts posts = new Posts(
          DATA[individualKey]['image'],
          DATA[individualKey]['description'],
          DATA[individualKey]['date'],
          DATA[individualKey]['time'],
        );

        postsList.add(posts);
      }


      setState(() {
        print('Length : $postsList.length' );
      });
    });
  }




  void _logoutUser() async{

    try{

      await widget.auth.signOut();
      widget.onSignedOut();

    }
    catch(e){

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

        child: postsList.length == 0 ? Text('No Posts') : new ListView.builder(
          itemBuilder: (_,index){
            return PostsUI(

              postsList[index].image,
              postsList[index].description,
              postsList[index].date,
              postsList[index].time,


            );
          },
          itemCount: postsList.length,



        ),
      ),

      bottomNavigationBar: BottomAppBar(

        color: Colors.pink,

        child: Container(

          margin: EdgeInsets.only(left: 50.0,right: 50.0),

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

              IconButton(
                icon: Icon(Icons.add_a_photo),
                iconSize: 50,
                color: Colors.white,
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context){
                            return new UploadPhotoPage();
                          }
                      )

                  );
                },

              ),


              IconButton(
                icon: Icon(Icons.question_answer),

                iconSize: 50,
                color: Colors.white,
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context){
                            return new FamilyMemberUpload();
                          }
                      )

                  );
                },

              ),




            ],
          ),
        ),

      ),

    );
  }



  Widget PostsUI(String image, String description, String date, String time){

    return new Card(

      elevation: 10.0,
      margin: EdgeInsets.all(15.0),
      child: new Container(
        padding: new EdgeInsets.all(14.0),

        child: new Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: <Widget>[

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: <Widget>[
                new Text(
                  date,
                  style: Theme.of(context).textTheme.subtitle,
                  textAlign: TextAlign.center,

                ),

                new Text(
                  time,
                  style: Theme.of(context).textTheme.subtitle,
                  textAlign: TextAlign.center,

                ),
              ],
            ),

            SizedBox(height: 10.0,),

            Image.network(image, fit: BoxFit.cover,),


            SizedBox(height: 10.0,),

            Text(
              description,
              style: Theme.of(context).textTheme.subhead,
              textAlign: TextAlign.center,

            ),




          ],
        ),

      ),

    );


  }
}
