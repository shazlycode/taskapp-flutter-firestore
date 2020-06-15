import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  TextEditingController _title = TextEditingController();
  TextEditingController _body = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Test get data"),
        ),
        body: Container(),
        // StreamBuilder(stream: Firestore.instance
        //         .collection("posts")
        //         .document(currentUser().uid)
        //         .snapshots() ,builder: null),
      ),
    );
  }

  void currentUser() async {
    await FirebaseAuth.instance.currentUser();
  }
}

// for(v in value){print(v.data["title"]);}

//                         //  Column(
//                         //       children: <Widget>[
//                         //         Text(value.data["title"]),
//                         //         Text(value.data["body"]),
//                         //       ],
//                         //     ),
