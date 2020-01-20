import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

class Members extends StatefulWidget {
  String name;

  Members(var name) {
    this.name = name;
  }

  createState() => _MembersState();
}

class _MembersState extends State<Members> {
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue,
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 15, left: 10),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    color: Colors.white,
                    onPressed: () => {Navigator.of(context).pop(true)},
                  )
                ],
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            Padding(
              padding: EdgeInsets.only(left: 40.0),
              child: Text(
                widget.name,
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
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
              child: ListPage(widget.name),
            )
          ],
        ));
  }
}

class ListPage extends StatefulWidget {
  String name;

  ListPage(var name) {
    this.name = name;
  }

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  Future _data;

  Future getPosts() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection(widget.name).getDocuments();
    return qn.documents;
  }

  navigateToDetail(DocumentSnapshot post) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailPage(
                  post: post,
                )));
  }

  @override
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
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundImage:
                          NetworkImage(snapshot.data[index].data['img url']),
                    ),
                    title: Text(snapshot.data[index].data['name']),
                    subtitle: Text(snapshot.data[index].data['designation']),
                    onTap: () => navigateToDetail(snapshot.data[index]),
                  );
                });
          }
        },
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  final DocumentSnapshot post;

  DetailPage({this.post});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
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
      backgroundColor: Colors.blue,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Profile',
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
                  backgroundImage: NetworkImage(widget.post.data['img url']),
                  radius: 100,
                ),
              ),
              Positioned(
                  top: 250,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text(widget.post.data['name'],
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
                      child: Text(widget.post.data['designation'],
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
                            ),
                          ),
                          Text(
                            widget.post.data['hometown'],
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
                                onPressed: () => _openUrl('tel:' +
                                    widget.post.data['phno'].toString()),
                              ),
                            ),
                            Expanded(
                              child: MaterialButton(
                                  child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 40,
                                      child: Image.asset('images/fb1.png')),
                                  onPressed: () => _openUrl(
                                      'https://www.fb.com/' +
                                          widget.post.data['fblink']
                                              .toString())),
                            ),
                            Expanded(
                              child: MaterialButton(
                                  child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 40,
                                      child: Image.asset('images/insta.png')),
                                  onPressed: () => _openUrl(
                                      'https://www.instagram.com/' +
                                          widget.post.data['instalink']
                                              .toString())),
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
                                  onPressed: () => _openUrl(
                                      'https://wa.me/+91' +
                                          widget.post.data['wplink']
                                              .toString())),
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
