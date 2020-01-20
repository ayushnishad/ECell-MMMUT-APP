import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';

class FirestoreSlideshow extends StatefulWidget {
  @override
  createState() => FirestoreSlideshowState();
}

class FirestoreSlideshowState extends State<FirestoreSlideshow> {
  final PageController ctrl = PageController(viewportFraction: 0.8);

  final Firestore db = Firestore.instance;
  Stream slides;
  int currentPage = 0;
  String activeTag = 'banner';

  @override
  void initState() {
    _queryDb();
    ctrl.addListener(() {
      int next = ctrl.page.round();
      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
    // TODO: implement initState
    //super.initState();
  }

  Stream _queryDb({String tag = 'banner'}) {
    Query query;
    if (tag == 'banner') {
      query = db.collection('banner_img').orderBy('order',
          descending: true);
    } else {
      query = db.collection('event_img').orderBy('order',
          descending: true);
    }
    slides =
        query.snapshots().map((list) => list.documents.map((doc) => doc.data));
    setState(() {
      activeTag = tag;
    });
  }

  _buildstoryPage(Map data, bool active) {
    final double blur = active ? 30 : 0;
    final double offset = active ? 20 : 0;
    return AnimatedContainer(
      alignment: Alignment.center,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOutQuint,
      margin: EdgeInsets.only(top: 7, bottom: 60, right: 20, left: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
              alignment: Alignment.center,
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(data['img url'])),
          boxShadow: [
            BoxShadow(
                color: Colors.black87,
                blurRadius: blur,
                offset: Offset(offset, offset))
          ]),
    );
  }

  _buildTagPage() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Filter',
            style: TextStyle(
                color: Colors.black45,
                fontWeight: FontWeight.bold,
                fontSize: 30),
          ),
          _buildButton('banner'),
          _buildButton('event')
        ],
      ),
    );
  }

  _buildButton(tag) {
    Color color = tag == activeTag ? Colors.blueAccent : Colors.white24;
    Color colorText = tag == activeTag ? Colors.white : Colors.black;
    return FlatButton(
      color: color,
      child: Text(
        '$tag',
        style: TextStyle(
            color: colorText,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500),
      ),
      onPressed: () => _queryDb(tag: tag),
      shape: StadiumBorder(),
      splashColor: Colors.blueAccent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return
        MaterialApp(
      home: Scaffold(
        body: StreamBuilder(
          stream: slides,
          initialData: [],
          builder: (context, AsyncSnapshot snap) {
            List slideList = snap.data.toList();
            return PageView.builder(
                controller: ctrl,
                itemCount: slideList.length + 1,
                itemBuilder: (context, int currentIdx) {
                  if (currentIdx == 0) {
                    return _buildTagPage();
                  } else if (slideList.length >= currentIdx) {
                    bool active = currentIdx == currentPage;
                    return _buildstoryPage(slideList[currentIdx - 1], active);
                  }
                });
          },
        ),
      ),
    );
  }
}
