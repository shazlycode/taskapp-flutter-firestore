import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseconnection/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class registerscreen extends StatefulWidget {
  @override
  _registerscreenState createState() => _registerscreenState();
}

class _registerscreenState extends State<registerscreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _paswordController = TextEditingController();

  @override
  void dispose() {
    _paswordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Register"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return ("Ente valid email");
                          }
                        },
                        decoration: InputDecoration(
                          labelText: "Eter Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _paswordController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return ("Ente valid email: ");
                          }
                        },
                        decoration: InputDecoration(
                          labelText: "Enter Password: ",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      RaisedButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            var result = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: _emailController.text,
                                    password: _paswordController.text);
                            var userInfo = await Firestore.instance
                                .collection("users")
                                .document(result.user.uid)
                                .setData({
                              "email": result.user.email,
                              "name": result.user.uid
                            });
                            if (result != null) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return loginscreen();
                              }));
                            }
                          }
                        },
                        child: Text(
                          "Register",
                          style: TextStyle(color: Colors.blue),
                        ),
                        color: Colors.amber,
                      )
                    ],
                  ))),
        ),
      ),
    );
  }
}
