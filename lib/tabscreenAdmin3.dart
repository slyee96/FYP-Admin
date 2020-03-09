import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:latest_chattydocadmin/data.dart';
import 'package:latest_chattydocadmin/loginscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'dart:io';

String urlgetuser = "http://myondb.com/projectLY/php/getAdmin.php";
String urluploadImage =
    "http://myondb.com/projectLY/php/uploadProfileImageAdmin.php";
File _image;
int number = 0;
String _value;

class ScreenAdmin3 extends StatefulWidget {
  final Admin admin;

  ScreenAdmin3({Key key, this.admin});
  @override
  _ScreenPatient1State createState() => _ScreenPatient1State();
}

class _ScreenPatient1State extends State<ScreenAdmin3> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.green[100],
          appBar: AppBar(
            title: Text('More'),
            centerTitle: true,
            backgroundColor: Colors.green,
          ),
          body: ListView.builder(
              //Step 6: Count the data
              itemCount: 6,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    decoration: new BoxDecoration(color: Colors.white),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 5,
                                ),
                                Center(
                                  child: Text("Profile",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                GestureDetector(
                                  onTap: _takePicture,
                                  child: Container(
                                      width: 180.0,
                                      height: 180.0,
                                      decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          border:
                                              Border.all(color: Colors.green),
                                          image: new DecorationImage(
                                              fit: BoxFit.cover,
                                              image: new NetworkImage(
                                                  "http://myondb.com/projectLY/profile/${widget.admin.email}.jpg?dummy=${(number)}'")))),
                                ),
                                SizedBox(height: 5),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(width: 10),
                                Column(
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        'Role: ' +
                                                widget.admin.role
                                                    ?.toUpperCase() ??
                                            'Not register',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Container(
                                      child: Text(
                                        'Name: ' +
                                                widget.admin.name
                                                    ?.toUpperCase() ??
                                            'Not register',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Container(
                                      child: Text(
                                        'Email: ' + widget.admin.email,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.phone_android,
                                            ),
                                            Text(widget.admin.phone ??
                                                'not registered'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          color: Colors.green,
                          child: Center(
                            child: Text("Account ",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                      ],
                    ),
                  );
                }
                if (index == 1) {
                  return Container(
                    color: Colors.green[100],
                    padding: EdgeInsets.all(2.0),
                    child: Column(children: <Widget>[
                      ListTile(
                        title: Text('Edit Account'),
                        onTap: () {
                          /*Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfilePatient(),
                            ),
                          );*/
                        },
                      ),
                      ListTile(
                        title: Text('My Journey'),
                      ),
                      ListTile(
                        title: Text('Settings'),
                      ),
                      ListTile(
                        title: Text('Report a fault'),
                      ),
                      ListTile(
                        title: Text('About the App'),
                      ),
                      ListTile(
                        title: Text('Log out'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                      ),
                    ]),
                  );
                }
              }),
        ));
  }

  void _takePicture() async {
    if (widget.admin.name == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Take new profile picture?"),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () async {
                Navigator.of(context).pop();
                _image =
                    await ImagePicker.pickImage(source: ImageSource.camera);

                String base64Image = base64Encode(_image.readAsBytesSync());
                http.post(urluploadImage, body: {
                  "encoded_string": base64Image,
                  "username": widget.admin.adminid
                }).then((res) {
                  print(res.body);
                  if (res.body == "success") {
                    setState(() {
                      number = new Random().nextInt(100);
                      print(number);
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
