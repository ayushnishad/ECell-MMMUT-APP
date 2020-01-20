import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flip_card/flip_card.dart';

class EventPage extends StatefulWidget {
  String name;

  EventPage(var name) {
    this.name = name;
  }

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.help_outline,
            color: Colors.black,
            size: 50,
          ),
          backgroundColor: Colors.white,
          onPressed: () => showDialog(
              context: context,
              child: new AlertDialog(
                title: new Text("Need help?"),
                content: new Text(
                    "- Make sure internet is working.\n- For detail click on any event."),
              )),
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 15, left: 10),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    color: Colors.black,
                    onPressed: () => {Navigator.of(context).pop(true)},
                  )
                ],
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            Center(
              child: Text(
                widget.name,
                style: TextStyle(
                    fontSize: 50,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              height: MediaQuery.of(context).size.height - 185.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(65.0))),
              child: EventList(widget.name),
            )
          ],
        ));
  }
}

class EventList extends StatefulWidget {
  String name;

  EventList(var name) {
    this.name = name;
  }

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  Future _data;

  Future getPosts() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection(widget.name).getDocuments();
    return qn.documents;
  }

  navigateToDetail(String event) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DetailPage(event: event)));
  }

  void initState() {
    // TODO: implement initState
    _data = getPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: _data,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text('Loading...'),
            );
          } else {
            return ListView.builder(
                primary: false,
                padding: EdgeInsets.only(left: 40, right: 20, top: 40),
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  return ListTile(
                      contentPadding: EdgeInsets.all(5),
                      title: Text(
                        snapshot.data[index].data['event name'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () => {
                            navigateToDetail(
                                snapshot.data[index].data['event name']),
                      });
                });
          }
        },
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  final String event;

  DetailPage({this.event});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Future _data;

  Future getPosts() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection(widget.event).getDocuments();
    return qn.documents;
  }

  void initState() {
    // TODO: implement initState
    _data = getPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.help_outline,
            color: Colors.black,
            size: 50,
          ),
          backgroundColor: Colors.white,
          onPressed: () => showDialog(
              context: context,
              child: new AlertDialog(
                title: new Text("Need help?"),
                content: new Text(
                    "- Make sure internet is working.\n- For detail click on any event."),
              )),
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 15, left: 10),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    color: Colors.black,
                    onPressed: () => {Navigator.of(context).pop(true)},
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Center(
              //padding: EdgeInsets.only(left: 40.0),
              child: Text(
                widget.event,
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
                height: MediaQuery.of(context).size.height - 185.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(65.0))),
                child: Container(
                  child: FutureBuilder(
                    future: _data,
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Text('Loading...'),
                        );
                      } else {
                        return ListView.builder(
                            primary: false,
                            padding:
                                EdgeInsets.only(left: 40, right: 40, top: 40),
                            itemCount: snapshot.data.length,
                            itemBuilder: (_, index) {
                              return Padding(
                                  padding: EdgeInsets.only(bottom: 20),
                                  child: FlipCard(
                                    front: Container(
                                        height: 350,
                                        child: Center(
                                          child: FadeInImage(
                                            image: NetworkImage(snapshot
                                                .data[index].data['front']),
                                            fit: BoxFit.cover,
                                            placeholder:
                                                AssetImage('images/loader.gif'),
                                          ),
                                        )),
                                    back: FadeInImage(
                                      image: NetworkImage(
                                          snapshot.data[index].data['back']),
                                      fit: BoxFit.cover,
                                      placeholder:
                                          AssetImage('images/loader.gif'),
                                    ),
                                  ));
                            });
                      }
                    },
                  ),
                )),
            Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Center(child: Text('Click on any poster to know more!')))
          ],
        ));
  }
}
