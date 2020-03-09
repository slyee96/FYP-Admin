import 'package:flutter/material.dart';
import 'package:latest_chattydocadmin/data.dart';
import 'package:latest_chattydocadmin/tabscreenAdmin.dart';
import 'package:latest_chattydocadmin/tabscreenAdmin2.dart';
import 'package:latest_chattydocadmin/tabscreenAdmin3.dart';

void main() => runApp(MainScreenAdmin());

class MainScreenAdmin extends StatefulWidget {
  final Admin admin;

  const MainScreenAdmin({Key key, this.admin}) : super(key: key);

  @override
  _MainScreenPatientState createState() => _MainScreenPatientState();
}

class _MainScreenPatientState extends State<MainScreenAdmin> {
  List<Widget> tabs;

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabs = [
      ScreenAdmin1(admin: widget.admin),
      ScreenAdmin2(admin: widget.admin),
      ScreenAdmin3(admin: widget.admin),
    ];
  }

  String $pagetitle = "ChattyDocs";

  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapped,
        currentIndex: currentTabIndex,
        //backgroundColor: Colors.blueGrey,
        type: BottomNavigationBarType.fixed,

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
            ),
            title: Text("Notification"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.message,
            ),
            title: Text("Account"),
          ),
        ],
      ),
    );
  }
}
