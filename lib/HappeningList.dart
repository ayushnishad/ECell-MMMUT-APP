import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HappeningList extends StatefulWidget {
  @override
  _HappeningListState createState() => _HappeningListState();
}

class _HappeningListState extends State<HappeningList> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 150,
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('Happenings')
              .orderBy('tag', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return new Text('Loading...');
            return new ListView(
              children: snapshot.data.documents.map((document) {
                return new ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white24,
                    radius: 25,
                    backgroundImage: AssetImage('images/ecell_logo.png'),
                  ),
                  title: new Text(document['title']),
                  subtitle: new Text(document['body']),
                );
              }).toList(),
            );
          },
        ));
  }
}
