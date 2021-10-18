import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scan_and_order/Data/firestore.dart';
import 'package:scan_and_order/screens/loginScreen.dart';

import 'package:scan_and_order/widget/button.dart';

import '../constant.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late String username, phone, password, email;
  bool _success = false;
  String _userEmail = '';
  @override
  void initState() {
    Firebase.initializeApp();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.red,
        height: MediaQuery.of(context).size.height * 1,
        child: Stack(
          children: [
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                decoration: BoxDecoration(
                  color: Constant.colorLight,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Wrap(
                      children: [
                        TextFormField(
                          onChanged: (newValue) {
                            setState(() {
                              username = newValue;
                            });
                          },
                          decoration: const InputDecoration(
                              hintText: 'Enter Your Name',
                              labelText: 'Name',
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        TextFormField(
                          onChanged: (newValue) {
                            setState(() {
                              email = newValue;
                            });
                          },
                          decoration: const InputDecoration(
                              hintText: 'Enter Your Email Id',
                              labelText: 'Email Id',
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        TextFormField(
                          onChanged: (newValue) {
                            setState(() {
                              phone = newValue.toString();
                            });
                          },
                          decoration: const InputDecoration(
                              hintText: 'Enter Your Phone No.',
                              labelText: 'Phone No.',
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        TextFormField(
                          obscureText: true,
                          onChanged: (newValue) {
                            setState(() {
                              password = newValue.toString();
                            });
                          },
                          decoration: const InputDecoration(
                              hintText: 'Enter Your Password',
                              labelText: 'Password',
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Buttons(
                        text: "Submit",
                        onPress: () async {
                          await _register();
                          if (_success == true) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          } else {
                            var snackBar = SnackBar(
                                content: Text(
                                    "Please Try Again. Something Went Wrong."));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                          print(_success);
                          print("d");
                        }),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("If You Have Already Account."),
                        TextButton(
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                            },
                            child: Text("Login",
                                style: TextStyle(color: Colors.red))),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _register() async {
    print("ka");
    try {
      final User? user = (await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;
      if (user != null) {
        Database.addUser(
            name: username, email: email, mobile: phone, userId: user.uid);
        setState(() {
          _success = true;
          _userEmail = user.email!;
        });
      } else {
        _success = false;
      }
    } catch (e) {
      _success = false;
      print(e);
    }
  }
}
