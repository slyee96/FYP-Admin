import 'package:flutter/material.dart';
import 'package:latest_chattydocadmin/data.dart';

void main() => runApp(ScreenAdmin2());

class ScreenAdmin2 extends StatefulWidget {
  final Admin admin;

  ScreenAdmin2({Key key, this.admin});
  @override
  _ScreenPatient1State createState() => _ScreenPatient1State();
}

class _ScreenPatient1State extends State<ScreenAdmin2> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        backgroundColor: Colors.green[100],
        appBar: AppBar(
          title: Text('Notification'),
          backgroundColor: Colors.green,
        ),
        body: Center(
          child: Container(
            child: Text('Hello World'),
          ),
        ),
      ),
    );
  }
}
