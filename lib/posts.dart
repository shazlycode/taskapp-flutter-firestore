import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseconnection/dashbord.dart';
import 'package:firebaseconnection/test.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class Posts extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _title = TextEditingController();
  TextEditingController _body = TextEditingController();
  var currentUser = FirebaseAuth.instance.currentUser();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Posts"),
          actions: <Widget>[
            RaisedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Test();
                }));
              },
              child: Text("test"),
            ),
            RaisedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          title: Text("Add Post"),
                          content: Column(
                            children: <Widget>[
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[
                                    TextFormField(
                                      controller: _title,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return ("Enter Title");
                                        }
                                      },
                                    ),
                                    TextFormField(
                                      maxLines: 10,
                                      controller: _body,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return ("Enter Body");
                                        }
                                      },
                                    ),
                                    RaisedButton(
                                        onPressed: () async {
                                          if (_formKey.currentState
                                              .validate()) {
                                            // var currentUser = await FirebaseAuth
                                            //     .instance
                                            //     .currentUser();

                                            await Firestore.instance
                                                .collection("posts")
                                                // .document(currentUser.uid)
                                                .add({
                                              "title": _title.text,
                                              "body": _body.text
                                            });

                                            Navigator.pushReplacement(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return Posts();
                                            }));
                                          }
                                        },
                                        child: Text("Save"))
                                  ],
                                ),
                              ),
                            ],
                          ));
                    });
              },
              child: Text("Add Post"),
            )
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection("posts").snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return new Text("Error ${snapshot.error}");
              }

              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: Text("Loading...."));
                default:
                  return ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (BuildContext context, i) {
                        return Card(
                          elevation: 10,
                          child: ListTile(
                            title:
                                Text(snapshot.data.documents[i].data['title']),
                            subtitle:
                                Text(snapshot.data.documents[i].data['body']),
                            onTap: () {
                              DocumentSnapshot item =
                                  snapshot.data.documents[i];
                              String itemid =
                                  snapshot.data.documents[i].documentID;
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return dashbord(item);
                              }));
                            },
                            trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  Firestore.instance
                                      .collection("posts")
                                      .document(
                                          snapshot.data.documents[i].documentID)
                                      .delete();
                                }),
                          ),
                        );
                      });
              }
            }),
      ),
    );
  }
}

// ListView(
//                     children: snapshot.data.documents
//                         .map((DocumentSnapshot document) {
//                       return ListTile(
//                         title: Text(document['title']),
//                         subtitle: Text(document["body"]),
//                         onTap: () {},
//                         trailing: IconButton(
//                             icon: Icon(Icons.delete),
//                             onPressed: () {
//                               Firestore.instance
//                                   .collection("posts")
//                                   .document()
//                                   .delete()
//                                   .then((value) => Navigator.push(context,
//                                           MaterialPageRoute(builder: (context) {
//                                         return Posts();
//                                       })));
//                             }),
//                       );
//                     }).toList(),
//                   );
