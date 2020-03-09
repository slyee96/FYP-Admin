import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latest_chattydocadmin/data.dart';
import 'package:latest_chattydocadmin/mainscreen.dart';
import 'package:latest_chattydocadmin/registerscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(routes: <String, WidgetBuilder>{});
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String urlLoginAdmin =
      "http://myondb.com/latestChattyDocs/php/loginAdmin.php";
  final TextEditingController _usernamecontroller = TextEditingController();
  String _username = "";
  final TextEditingController _passcontroller = TextEditingController();
  String _password = "";
  bool _isChecked = false;

  @override
  void initState() {
    loadpref();
    print('Init: $_username');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressAppBar,
        child: Scaffold(
          backgroundColor: Colors.green[200],
          resizeToAvoidBottomPadding: false,
          body: new Container(
            padding: EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/admin.png',
                  width: 230,
                  height: 200,
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                    controller: _usernamecontroller,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding:
                            new EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0),
                        border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.white),
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        labelText: 'ID',
                        icon: Icon(Icons.account_circle))),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: _passcontroller,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding:
                          new EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      labelText: 'Password',
                      icon: Icon(Icons.lock)),
                  obscureText: true,
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  children: <Widget>[
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Colors.black,
                              width: 2,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(15.0)),
                      minWidth: 200,
                      height: 50,
                      child: Text('Sign In'),
                      color: Colors.lightGreen,
                      textColor: Colors.black,
                      elevation: 15,
                      onPressed: _onLogin,
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: _isChecked,
                      onChanged: (bool value) {
                        _onChange(value);
                      },
                    ),
                    Text('Remember Me', style: TextStyle(fontSize: 16))
                  ],
                ),
                GestureDetector(
                    onTap: _onForgot,
                    child:
                        Text('Forgot Account', style: TextStyle(fontSize: 18))),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                    onTap: _onRegister,
                    child: Text('Register New Account',
                        style: TextStyle(fontSize: 18))),
              ],
            ),
          ),
        ));
  }

  void _onLogin() {
    print('onLOGIN');
    _username = _usernamecontroller.text;
    _password = _passcontroller.text;
    if (_password.length > 4) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Login in");
      pr.show();
      http.post(urlLoginAdmin, body: {
        "username": _username,
        "password": _password,
      }).then((res) {
        print(res.statusCode);
        var string = res.body;
        List dres = string.split(",");
        print(dres);
        Toast.show(dres[0], context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        if (dres[0] == "success") {
          pr.dismiss();
          print(dres);
          Admin admin = new Admin(
              role: dres[1],
              adminid: dres[2],
              password: dres[3],
              name: dres[4],
              email: dres[5],
              phone: dres[6]);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MainScreenAdmin(admin: admin)));
        } else {
          pr.dismiss();
        }
      }).catchError((err) {
        pr.dismiss();
        print(err);
      });
    } else {}
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
      savepref(value);
    });
  }

  void _onRegister() {
    print('onRegister');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterScreen()));
  }

  void _onForgot() {
    print('Forgot');
  }

  void savepref(bool value) async {
    print('Inside savepref');
    _username = _usernamecontroller.text;
    _password = _passcontroller.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      //true save pref
      if (_password.length > 5) {
        await prefs.setString('username', _username);
        await prefs.setString('pass', _password);
        print('Save pref $_username');
        print('Save pref $_password');
        Toast.show("Preferences have been saved", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else {
        print('No email');
        setState(() {
          _isChecked = false;
        });
        Toast.show("Check your credentials", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    } else {
      await prefs.setString('username', '');
      await prefs.setString('pass', '');
      setState(() {
        _usernamecontroller.text = '';
        _passcontroller.text = '';
        _isChecked = false;
      });
      print('Remove pref');
      Toast.show("Preferences have been removed", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  Future<bool> _onBackPressAppBar() async {
    SystemNavigator.pop();
    print('Backpress');
    return Future.value(false);
  }

  void loadpref() async {
    print('Inside loadpref()');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _username = (prefs.getString('email'));
    _password = (prefs.getString('pass'));
    print(_username);
    print(_password);
    if (_username.length > 5) {
      _usernamecontroller.text = _username;
      _passcontroller.text = _password;
      setState(() {
        _isChecked = true;
      });
    } else {
      print('No pref');
      setState(() {
        _isChecked = false;
      });
    }
  }
}
