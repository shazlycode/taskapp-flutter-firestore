import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseconnection/login.dart';
import 'package:firebaseconnection/posts.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class dashbord extends StatefulWidget {
  //DocumentSnapshot item = snapshot.data.documents[i];
  DocumentSnapshot item;
  String itemid;
  dashbord(this.item);
  @override
  _dashbordState createState() => _dashbordState(item);
}

class _dashbordState extends State<dashbord> {
  DocumentSnapshot item;
  String itemid;
  _dashbordState(this.item);

  final _keyForm = GlobalKey<FormState>();
  TextEditingController _title = TextEditingController();
  TextEditingController _body = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _title.text = item.data['title'];
    _body.text = item.data['body'];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Dashbord"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return loginscreen();
                  }));
                })
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 30),
                Form(
                  key: _keyForm,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _title,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: "Enter the title"),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        maxLines: 10,
                        controller: _body,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: "Enter the title"),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                              color: Colors.amberAccent,
                              onPressed: () async {
                                var currentUser =
                                    await FirebaseAuth.instance.currentUser();
                                if (item.documentID == null) {
                                  await Firestore.instance
                                      .collection("posts")
                                      .document()
                                      .setData({
                                    "title": _title.text,
                                    "body": _body.text,
                                  });
                                } else {
                                  await Firestore.instance
                                      .collection("posts")
                                      .document(item.documentID)
                                      .updateData({
                                    "title": _title.text,
                                    "body": _body.text
                                  });
                                }

                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Posts();
                                }));
                              },
                              child: Text("Save"),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
