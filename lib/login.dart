import 'package:firebaseconnection/posts.dart';
import 'package:firebaseconnection/register.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseconnection/dashbord.dart';

class loginscreen extends StatefulWidget {
  @override
  _loginscreenState createState() => _loginscreenState();
}

class _loginscreenState extends State<loginscreen> {
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailcontroler = TextEditingController();
  TextEditingController _passwordcontroler = TextEditingController();
  @override
  void dispose() {
    _emailcontroler.dispose();
    _passwordcontroler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _emailcontroler,
                      validator: (value) {
                        if (value.isEmpty) {
                          return ("Please fill email input");
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "Enter Email",
                        labelStyle: TextStyle(fontSize: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      controller: _passwordcontroler,
                      validator: (value) {
                        if (value.isEmpty) {
                          return ("Enter valid password");
                        }
                      },
                      decoration: InputDecoration(
                        labelStyle: TextStyle(fontSize: 20),
                        labelText: "Enter password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                var result = await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                        email: _emailcontroler.text,
                                        password: _passwordcontroler.text);
                                if (result != null) {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) {
                                    return Posts();
                                  }));
                                  _emailcontroler.text = "";
                                  _passwordcontroler.text = "";
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Text("User not found"),
                                        );
                                      });
                                }
                              }
                            },
                            child: Text("LogIn"),
                            textColor: Theme.of(context).accentColor,
                            color: Colors.amber,
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                            child: RaisedButton(
                                textColor: Theme.of(context).accentColor,
                                color: Colors.amber,
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return registerscreen();
                                  }));
                                },
                                child: Text("Register")))
                      ],
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
