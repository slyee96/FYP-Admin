import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latest_chattydocadmin/data.dart';
import 'package:latest_chattydocadmin/loginscreen.dart';
import 'dart:convert';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

File _image;
String urlUploadAdmin =
    "http://myondb.com/latestChattyDocs/php/registerAdmin.php";
final TextEditingController _rolecontroller = TextEditingController();
final TextEditingController _usernamecontroller = TextEditingController();
final TextEditingController _passcontroller = TextEditingController();
final TextEditingController _namecontroller = TextEditingController();
final TextEditingController _emailcontroller = TextEditingController();
final TextEditingController _phonecontroller = TextEditingController();
String _role, _username, _password, _name, _email, _phone;
bool _isChecked = false;

final Admin admin = new Admin();

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
  const RegisterScreen({Key key, File image}) : super(key: key);
}

class _RegisterUserState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        backgroundColor: Colors.green[100],
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('New Admin Registration'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
            child: RegisterWidget(),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressAppBar() {
    _image = null;
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
    return Future.value(false);
  }
}

class RegisterWidget extends StatefulWidget {
  @override
  RegisterWidgetState createState() => RegisterWidgetState();
}

class RegisterWidgetState extends State<RegisterWidget> {
  bool _validate = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
            onTap: _choose,
            child: Container(
              width: 180,
              height: 200,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: _image == null
                        ? AssetImage('assets/images/profile.png')
                        : FileImage(_image),
                    fit: BoxFit.fill,
                  )),
            )),
        SizedBox(
          height: 10,
        ),
        Text('Click on image above to get your profile photo'),
        SizedBox(
          height: 10,
        ),
        TextFormField(
            autovalidate: _validate,
            controller: _rolecontroller,
            validator: validateUsername,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Role',
              icon: Icon(Icons.person),
            )),
        TextFormField(
            autovalidate: _validate,
            controller: _usernamecontroller,
            validator: validateUsername,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Admin ID',
              icon: Icon(Icons.person),
            )),
        TextFormField(
          autovalidate: _validate,
          controller: _passcontroller,
          validator: validatePassword,
          keyboardType: TextInputType.text,
          decoration:
              InputDecoration(labelText: 'Password', icon: Icon(Icons.lock)),
          obscureText: true,
        ),
        TextFormField(
            autovalidate: _validate,
            controller: _namecontroller,
            validator: validateName,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Full Name',
              icon: Icon(Icons.person),
            )),
        TextFormField(
            autovalidate: _validate,
            controller: _emailcontroller,
            validator: validateEmail,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              icon: Icon(Icons.email),
            )),
        TextFormField(
            autovalidate: _validate,
            controller: _phonecontroller,
            validator: validatePhone,
            keyboardType: TextInputType.phone,
            decoration:
                InputDecoration(labelText: 'Phone', icon: Icon(Icons.phone))),
        SizedBox(
          height: 20,
        ),
        Row(
          children: <Widget>[
            Checkbox(
              value: _isChecked,
              onChanged: (bool value) {
                _onChange(value);
              },
            ),
            Text('I agree to ChattyDocs ', style: TextStyle(fontSize: 12)),
            GestureDetector(
                child: Text("(Terms and Condition)",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blue,
                        fontSize: 10)),
                onTap: () {
                  launch(
                      'http://myondb.com/myNelayanLY/php/termandcondition.php');
                  // do what you need to do when "Click here" gets clicked
                })
          ],
        ),
        SizedBox(
          height: 20,
        ),
        MaterialButton(
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: Colors.black, width: 2, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(20.0)),
          minWidth: 200,
          height: 50,
          child: Text('Register'),
          color: Colors.lightGreen,
          textColor: Colors.black,
          elevation: 15,
          onPressed: _onRegister,
        ),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
            onTap: _onBackPress,
            child: Text('Already Register', style: TextStyle(fontSize: 16))),
      ],
    );
  }

  String validateUsername(String value) {
    if (value.length == 0) {
      return "Username is Required";
    }
    return null;
  }

  String validatePassword(String value) {
    if (value.length == 0) {
      return "Password is Required";
    } else if (value.length < 6) {
      return "Password must at least 6 characters";
    } else {
      return null;
    }
  }

  String validateName(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Full name is required";
    } else if (!regExp.hasMatch(value)) {
      return "Full name must contain only letters.";
    }
    return null;
  }

  String validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  String validatePhone(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Phone Number is Required";
    } else if (value.length < 9 || value.length > 11) {
      return "Phone Number must 10-11 digits";
    } else if (!regExp.hasMatch(value)) {
      return "Phone Number must be digits";
    }
    return null;
  }

  void _choose() async {
    final imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Select the image source"),
              actions: <Widget>[
                MaterialButton(
                  child: Text("Camera"),
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                ),
                MaterialButton(
                  child: Text("Gallery"),
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                )
              ],
            ));

    if (imageSource != null) {
      final file = await ImagePicker.pickImage(source: imageSource);
      if (file != null) {
        setState(() => _image = file);
      }
    }
  }

  void _onRegister() {
    print('onRegister Button from RegisterUser()');
    print(_image.toString());
    uploadData();
  }

  void _onBackPress() {
    _image = null;
    print('onBackpress from RegisterUser');
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
  }

  void uploadData() {
    _role = _rolecontroller.text;
    _username = _usernamecontroller.text;
    _password = _passcontroller.text;
    _name = _namecontroller.text;
    _email = _emailcontroller.text;
    _phone = _phonecontroller.text;
    print(_password);
    if ((_isEmailValid(_email)) &&
        (_password.length > 5) &&
        (_image != null) &&
        (_phone.length > 9 || _phone.length < 12)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Registration in progress");
      pr.show();

      String base64Image = base64Encode(_image.readAsBytesSync());
      http.post(urlUploadAdmin, body: {
        "encoded_string": base64Image,
        "role": _role,
        "username": _username,
        "password": _password,
        "name": _name,
        "email": _email,
        "phone": _phone,
      }).then((res) {
        print(res.statusCode);
        if (res.body == "success") {
          Toast.show(res.body, context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          _image = null;
          savepref(_username, _password);
          _rolecontroller.text;
          _usernamecontroller.text;
          _passcontroller.text;
          _namecontroller.text;
          _emailcontroller.text;
          _phonecontroller.text;
          pr.dismiss();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginPage()));
        }
      }).catchError((err) {
        print(err);
      });
    } else {
      setState(() {
        _validate = true;
      });
      Toast.show("Check your registration information", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  bool _isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
    });
  }

  void savepref(String username, String password) async {
    print('Inside savepref');
    _username = _usernamecontroller.text;
    _password = _passcontroller.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //true save pref
    await prefs.setString('username', username);
    await prefs.setString('pass', password);
    print('Save pref $_username');
    print('Save pref $_password');
  }
}
