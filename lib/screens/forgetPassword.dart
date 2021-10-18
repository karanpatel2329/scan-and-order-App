import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scan_and_order/constant.dart';
import 'package:scan_and_order/screens/loginScreen.dart';
import 'package:scan_and_order/screens/signupScreen.dart';
import 'package:scan_and_order/tab.dart';
import 'package:scan_and_order/widget/button.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
class ForgetPasswordScreen extends StatefulWidget {

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  bool isChecked=false;
  String email="";
  String password="";

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
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(55.0),topRight:  Radius.circular(55.0)),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Forget Password", style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),),
                        ),
                        TextFormField(
                          onChanged: (newValue){
                            setState(() {
                              email=newValue;
                            });
                          },
                          decoration: const InputDecoration(
                              hintText: 'Enter Your Email Id',
                              labelText: 'Email Id',
                              focusedBorder:  UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              labelStyle: TextStyle(
                                color:Colors.black,
                                fontWeight: FontWeight.bold,
                              )
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),

                        SizedBox(
                          height:10,
                        ),
                        Buttons(text: "Forget Password",onPress: ()async{
                           int res=await _forgetPassword(context);
                           if(res==0){
                             var snackBar = SnackBar(content: Text("If You have Already Register Then Password Reset Link is Sent To "+email));
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                           }
                        }
                        ),
                        SizedBox(
                          height:10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Go Back To"),
                            TextButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));}, child: Text("Login Screen", style:TextStyle(color: Colors.redAccent))),

                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height*0.13,
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
  Future<int> _forgetPassword(context) async {
    try {
      _auth.sendPasswordResetEmail(email: email).onError((error, stackTrace) => print("error"));
    } catch (e) {
      print("HeRE ERROR");
      print(e);

     }
     return 0;
  }

}
