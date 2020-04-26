import 'dart:io';
import 'package:ctsefamilyapp/home_page_haritha.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';



class UploadPhotoPage extends StatefulWidget {
  @override
  _UploadPhotoPageState createState() => _UploadPhotoPageState();

}

class _UploadPhotoPageState extends State<UploadPhotoPage> {



  File sampleImage;
  String _myValue;
  String url;
  final formKey = new GlobalKey<FormState>();

  Future getImage() async{





    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = tempImage;
    });

  }

  Future getImageFromCamera() async{





    var tempImage = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      sampleImage = tempImage;
    });

  }

  showImageSelectDialog() {

    // set up the buttons
    Widget galleryButton = FlatButton(
      child: Text("Select From Gallery"),
      onPressed:  getImage,
    );
    Widget cameraButton = FlatButton(
      child: Text("Select From Camera"),
      onPressed:  getImageFromCamera,
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text("Add Your Family Member"),
      actions: [
        galleryButton,
        cameraButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  bool validateAndSave(){

    final form = formKey.currentState;

    if(form.validate()){
      form.save();
      return true;
    }
    else{
      return false;
    }

  }


  void uploadStatusImage() async{

    if(validateAndSave()){

      final StorageReference postImageRef = FirebaseStorage.instance.ref().child("Member Images");

      var timeKey = DateTime.now();

      final StorageUploadTask uploadTask = postImageRef.child(timeKey.toString() + ".jpg").putFile(sampleImage);

      var ImageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();

      url = ImageUrl.toString();

      print("Image URL = " + url);

      goToHomePage();

      saveToDatabase(url);

    }
  }


  void saveToDatabase(url){

    var dbTimeKey = DateTime.now();
    var formatDate = DateFormat('MMM d, yyyy');
    var formatTime = DateFormat('EEEE, hh:mm aaa');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    DatabaseReference  ref = FirebaseDatabase.instance.reference();

    var data = {
      "image" : url,
      "description": _myValue,
      "date": date,
      "time": time
    };


    ref.child("Members").push().set(data);



  }



  void goToHomePage(){
    Navigator.push(context,
        MaterialPageRoute(
            builder: (context){

              return new HomePage();
            }
        )
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Members'),
        centerTitle: true,

      ),

      body: Center(
        child: sampleImage == null ? Text("Select an Image") : enableUpload(),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: showImageSelectDialog,
        tooltip: 'Add Image',
        child: Icon(Icons.add),
      ),



    );
  }

  Widget enableUpload(){

    return Container(
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            Image.file(sampleImage, height: 310.0, width: 600.0,),

            SizedBox(height: 15.0,),

            TextFormField(
              decoration: InputDecoration(
                labelText: 'Description',

              ),
              validator: (value){
                return value.isEmpty ? 'Enter Description' : null;
              },
              onSaved: (value){
                return _myValue = value;
              },
            ),

            SizedBox(height: 15.0,),

            RaisedButton(

              elevation: 10.0,
              child: Text('Add Post'),
              textColor: Colors.white,
              color: Colors.pink,
              onPressed: uploadStatusImage,
            ),
          ],
        ),
      ),
    );



  }
}
