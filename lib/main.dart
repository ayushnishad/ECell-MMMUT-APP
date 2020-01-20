import 'dart:ui' as prefix0;

import 'package:ecell/EcellGallery.dart';
import 'package:ecell/EventPage.dart' as prefix1;
import 'package:ecell/HappeningList.dart';
import 'package:ecell/Members.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ecell/EventPage.dart';
import 'EventPage.dart';
import 'package:ecell/FirestoreSlideshow.dart';
import 'Members.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  _openUrl(var url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  final PageController ctrl = PageController();

  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                FlatButton(
                  onPressed: () => _openUrl(
                      'https://ecellmmmut.000webhostapp.com/index.php'),
                  child: Text("Website",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  shape:
                      CircleBorder(side: BorderSide(color: Colors.transparent)),
                ),
              ],
              title: //(
                  Text(
                "Dashboard",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              //),
              backgroundColor: Color(1),
              iconTheme: new IconThemeData(color: Colors.black),
              elevation:
                  debugDefaultTargetPlatformOverride == TargetPlatform.android
                      ? 5.0
                      : 0.0,
            ),
            drawer: new Drawer(
              // column holds all the widgets in the drawer
              child: Column(
                children: <Widget>[
                  Expanded(
                    // ListView contains a group of widgets that scroll inside the drawer
                    child: ListView(
                      children: <Widget>[
                        DrawerHeader(
                          //child: Text('Drawer Header'),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('images/ecell_logo.png'),
                              fit: BoxFit.fitHeight,
                            ),
                            color: Color(1),
                          ),
                        ),
                        Builder(
                          builder: (context) => ListTile(
                            leading: Icon(Icons.dashboard),
                            title: Text("Dashboard"),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Events(),
                        MembersTile(),
                        Gallery(),
                        Developer(),
                        Help(),
                      ],
                    ),
                  ),
                  // This container holds the align
                  Divider(),
                  Text(
                    "Follow us on:",
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  Container(
                      // This align moves the children to the bottom
                      child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          // This container holds all the children that will be aligned
                          // on the bottom and should not scroll with the above ListView
                          child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  FloatingActionButton(
                                    heroTag: 'yt',
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 25,
                                      child: Image.asset("images/yt1.png"),
                                    ),
                                    onPressed: () => _openUrl(
                                        'https://www.youtube.com/channel/UCK_kllYk_0jhv4U89-jE80w'),
                                  ),
                                  FloatingActionButton(
                                      heroTag: 'fb',
                                      backgroundColor: Colors.white38,
                                      child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 25,
                                          child: Image.asset("images/fb1.png")),
                                      onPressed: () => _openUrl(
                                          'https://www.fb.com/ecell.mmmut')
                                      //_openUrl('https://wa.me/919005007279'),
                                      ),
                                  FloatingActionButton(
                                    heroTag: 'insta',
                                    backgroundColor: Colors.white38,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 25,
                                      child: Image.asset("images/insta.png"),
                                    ),
                                    onPressed: () => _openUrl(
                                        'https://www.instagram.com/ecell_mmmut'),
                                  ),
                                ],
                              ))))
                ],
              ),
            ),
            body: Column(
              children: <Widget>[
                /*Container(
                  height: 30,
                  width: double.infinity,
                ),*/
                Container(
                  width: double.infinity,
                  height: 230,
                  child: Center(
                    child: FirestoreSlideshow(),
                  ),
                ),
                Text(
                  "Happenings",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                HappeningList(),
                UpcomingEvents(),
//                Workshop(),

                Flexible(
                  child: FlatButton(
                    child: Text(
                      'ABOUT US',
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                    onPressed: () => _openUrl(
                        'https://ecellmmmut.000webhostapp.com/index.php'),
                  ),
                )
              ],
            )));
  }
}

class Events extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.event),
      title: Text("Events"),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventPage('Events'),
        ),
      ),
    );
  }
}

class UpcomingEvents extends StatefulWidget {
  @override
  _UpcomingEventsState createState() => _UpcomingEventsState();
}

class _UpcomingEventsState extends State<UpcomingEvents> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  final databaseReference = Firestore.instance;

  String path;

  void getData() {
    databaseReference
        .collection("UPCOMING EVENT")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => {path = f.data['event']});
    });
  }

  @override
  Widget build(BuildContext context) {
    return
        InkWell(
      onTap: () {
        getData();
        if (path != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => prefix1.DetailPage(event: path),
            ),
          );
        }
      },
      child: Container(
        height: 180,
        width: 300,
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Image.network(
            'https://miro.medium.com/max/780/1*RclhQUBEB0yOPKd1HavI8A.gif',
            fit: BoxFit.fill,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
          margin: EdgeInsets.all(10),
        ),
      ),
    );
    //);
  }
}

class Developer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.developer_mode),
      title: Text("Developer"),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyDetailPage()));
      },
    );
  }
}

class Gallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.photo_library),
      title: Text("Ecell-Gallery"),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => EcellGallery()));
      },
    );
  }
}

class Help extends StatelessWidget {
  _openUrl(var url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(Icons.mail),
        title: Text("Help & Support"),
        onTap: () => _openUrl('mailto:ecell.mmmut@gmail.com'));
  }
}

class MembersTile extends StatelessWidget {
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon(Icons.assignment_ind),
      title: Text("Members"),
      children: <Widget>[
        ListTile(
            title: Text('Final year'),
            onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Members('Final Year'),
                  ),
                )),
        ListTile(
            title: Text('3\u02b3\u1d48 year'),
            onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Members('3rd year'),
                  ),
                )),
        ListTile(
            title: Text('2\u207f\u1d48 year'),
            onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Members('2nd year'),
                  ),
                )),
      ],
    );
  }
}

class MyDetailPage extends StatelessWidget {
  _openUrl(var url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Developer Profile',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height - 82,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
              ),
              Positioned(
                top: 75,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(45.0),
                        topRight: Radius.circular(45.0)),
                    color: Colors.white,
                  ),
                  height: MediaQuery.of(context).size.height - 100,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              Positioned(
                top: 30,
                left: (MediaQuery.of(context).size.width / 2) - 100,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(
                      'https://scontent.famd1-2.fna.fbcdn.net/v/t1.0-9/73395353_2439085993010849_3525904335944810496_n.jpg?_nc_cat=106&_nc_oc=AQl370lfWKU4mlj1mq11Te64IeHPQzdeYB7OitWwEFgh9-3xxGfeZTX6DPQvA1IZGSdRbEDS7ONgInqZorbJVWof&_nc_ht=scontent.famd1-2.fna&oh=e4f67743404682be5a30274e39ffa508&oe=5E48C0FA'),
                  radius: 100,
                ),
              ),
              Positioned(
                  top: 250,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text('Ayush Nishad',
                          style: TextStyle(
                            fontSize: 28,
                          )),
                    ),
                  )),
              Positioned(
                  top: 290,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text('Technical Head',
                          style: TextStyle(
                            fontSize: 17,
                          )),
                    ),
                  )),
              Positioned(
                  top: 350,
                  left: 20,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(
                            Icons.pin_drop,
                          )),
                          Text(
                            'Gorakhpur',
                            style: TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                    ),
                  )),
              Positioned(
                  top: 470,
                  /*
                  left: 33,
                  right: 33,*/
                  child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    width: MediaQuery.of(context).size.width,
                    child: Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: MaterialButton(
                                child: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: 40,
                                    child: Image.asset('images/dialer.png')),
                                onPressed: () => _openUrl('tel:9005007279'),
                              ),
                            ),
                            Expanded(
                              child: MaterialButton(
                                  child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 40,
                                      child: Image.asset('images/fb1.png')),
                                  onPressed: () => _openUrl(
                                      'https://www.fb.com/ayushnishadcr7')),
                            ),
                            Expanded(
                              child: MaterialButton(
                                  child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 40,
                                      child: Image.asset('images/insta.png')),
                                  onPressed: () => _openUrl(
                                      'https://www.instagram.com/ayn.exe')),
                            ),
                            Expanded(
                              child: MaterialButton(
                                  child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 40,
                                      child: Image.asset(
                                        'images/wp.png',
                                        fit: BoxFit.fitHeight,
                                      )),
                                  onPressed: () =>
                                      _openUrl('https://wa.me/+919005007279')),
                            ),
                          ],
                        )),
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
