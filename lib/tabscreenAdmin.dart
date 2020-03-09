import 'package:flutter/material.dart';
import 'package:latest_chattydocadmin/data.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:latest_chattydocadmin/tabPatientDetails.dart';
import 'package:latest_chattydocadmin/tabPsychiatristscreen.dart';

void main() => runApp(ScreenAdmin1());

class ScreenAdmin1 extends StatefulWidget {
  final Admin admin;
  final Patient patient;
  final Psychiatrist psychiatrist;
  ScreenAdmin1({Key key, this.admin, this.patient, this.psychiatrist});
  @override
  _ScreenPatient1State createState() => _ScreenPatient1State();
}

class _ScreenPatient1State extends State<ScreenAdmin1>
    with SingleTickerProviderStateMixin {
  GlobalKey<RefreshIndicatorState> refreshKey;
  List data;
  Animation<double> animation;
  AnimationController controller;
  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = new Tween(begin: 0.0, end: 18.0).animate(controller)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    Widget carousel = new Carousel(
      boxFit: BoxFit.cover,
      images: [
        new AssetImage('assets/images/motivational1.png'),
        new AssetImage('assets/images/motivational2.png'),
        new AssetImage('assets/images/motivational3.png'),
        new AssetImage('assets/images/motivational4.png'),
      ],
      animationCurve: Curves.fastOutSlowIn,
      animationDuration: Duration(seconds: 1),
    );

    Widget banner = new Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 20.0),
      child: new Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0)),
          color: Colors.amber.withOpacity(0.5),
        ),
        padding: const EdgeInsets.all(10.0),
        child: new Text(
          'Motivational Quate',
          style: TextStyle(
            fontFamily: 'fira',
            fontSize: animation.value, //18.0,
            //color: Colors.white,
          ),
        ),
      ),
      // ),
      //  ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.green[100],
        appBar: AppBar(
          title: Text('WELCOME TO ADMIN PAGE'),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Card(
                      child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(20.0),
                                      height: screenHeight / 2,
                                      child: new ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        child: new Stack(
                                          children: [
                                            carousel,
                                            banner,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]))),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Card(
                      child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Text('The Patient Details',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Column(
                                      children: <Widget>[
                                        MaterialButton(
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Colors.black,
                                                  width: 2,
                                                  style: BorderStyle.solid),
                                              borderRadius:
                                                  BorderRadius.circular(20.0)),
                                          minWidth: 200,
                                          height: 50,
                                          child:
                                              Text('Available Patient Today'),
                                          color: Colors.lightGreen,
                                          textColor: Colors.black,
                                          elevation: 15,
                                          onPressed: _clickAvailablePatient,
                                        ),
                                        SizedBox(height: 15),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]))),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Card(
                      child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Text('The Psychiatrist Details',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Column(
                                      children: <Widget>[
                                        MaterialButton(
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Colors.black,
                                                  width: 2,
                                                  style: BorderStyle.solid),
                                              borderRadius:
                                                  BorderRadius.circular(20.0)),
                                          minWidth: 200,
                                          height: 50,
                                          child: Text(
                                              'Available Psychiatrist Today'),
                                          color: Colors.lightGreen,
                                          textColor: Colors.black,
                                          elevation: 15,
                                          onPressed:
                                              _clickAvailablePsychiatrist,
                                        ),
                                        SizedBox(height: 15),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _clickAvailablePatient() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PatientScreen(
                  patient: widget.patient,
                  psychiatrist: widget.psychiatrist,
                )));
  }

  void _clickAvailablePsychiatrist() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PsychiatristScreen(
                  psychiatrist: widget.psychiatrist,
                  patient: widget.patient,
                )));
  }
}
