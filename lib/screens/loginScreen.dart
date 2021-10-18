import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scan_and_order/constant.dart';
import 'package:scan_and_order/screens/forgetPassword.dart';
import 'package:scan_and_order/screens/signupScreen.dart';
import 'package:scan_and_order/tab.dart';
import 'package:scan_and_order/widget/button.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isChecked = false;
  String email = "";
  String password = "";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.red,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: IntrinsicHeight(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15.0),
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    decoration: BoxDecoration(
                      color: Constant.colorLight,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(55.0),
                          topRight: Radius.circular(55.0)),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                                fontSize: 25.0, fontWeight: FontWeight.bold),
                          ),
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
                        SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          obscureText: true,
                          onChanged: (newValue) {
                            setState(() {
                              password = newValue;
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
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isChecked = value!;
                                    });
                                  },
                                ),
                                Text(
                                  "Remember Me",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ForgetPasswordScreen()));
                                },
                                child: Text("Forget Password",
                                    style: TextStyle(color: Colors.redAccent))),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Buttons(
                            text: "Login",
                            onPress: () async {
                              User? user =
                                  await _signInWithEmailAndPassword(context);
                              if (user != null) {
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setBool("isLogin", true);
                                //Navigator.of(context).pop();
                                Route route = MaterialPageRoute(builder: (context) => TabContainerDefault());
                                Navigator.pushReplacement(context, route);
                                // Navigator
                                //     .of(context)
                                //     .pushReplacement(
                                //     MaterialPageRoute(
                                //         builder: (context)=>TabContainerDefault()
                                //     )
                                // );
                              } else {
                                var snackBar = SnackBar(
                                    content: Text(
                                        "Please Try Again. Something Went Wrong."));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            }),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("If You Don't Have An Account"),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SignupScreen()));
                                },
                                child: Text("Sign Up",
                                    style: TextStyle(color: Colors.redAccent))),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.13,
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<User?> _signInWithEmailAndPassword(context) async {
    try {
      final User? user = (await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;
      return user;
    } catch (e) {
      print(e);
      // Scaffold.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('Failed to sign in with Email & Password'),
      //   ),
      // );
      return null;
    }
  }
}
