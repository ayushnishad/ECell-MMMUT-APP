import 'package:ecell/FullscreenImage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'FullscreenImage.dart';

class EcellGallery extends StatefulWidget {
  @override
  _EcellGalleryState createState() => _EcellGalleryState();
}

class _EcellGalleryState extends State<EcellGallery> {
  StreamSubscription<QuerySnapshot> subscription;
  List<DocumentSnapshot> galleryList;
  final CollectionReference collectionReference =
      Firestore.instance.collection("Gallery");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscription = collectionReference
        .orderBy('tag', descending: true)
        .snapshots()
        .listen((datasnapshot) {
      setState(() {
        galleryList = datasnapshot.documents;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Ecell Gallery"),
        ),
        body: galleryList != null
            ? new StaggeredGridView.countBuilder(
                padding: const EdgeInsets.all(8.0),
                crossAxisCount: 4,
                itemCount: galleryList.length,
                itemBuilder: (context, i) {
                  String imgPath = galleryList[i].data['img url'];
                  return new Material(
                    elevation: 8.0,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    child: InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FullscreenImage(imgPath))),
                      child: Hero(
                          tag: imgPath,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: FadeInImage(
                              image: NetworkImage(imgPath),
                              fit: BoxFit.cover,
                              placeholder: AssetImage('images/loader.gif'),
                            ),
                          )),
                    ),
                  );
                },
                staggeredTileBuilder: (i) =>
                    StaggeredTile.count(2, i.isEven ? 2 : 3),
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
