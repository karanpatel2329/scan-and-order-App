import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scan_and_order/Data/firestore.dart';
import 'package:scan_and_order/screens/loginScreen.dart';
import 'package:scan_and_order/widget/button.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isEdit = false;

class MyProfile extends StatefulWidget {
  String name,phone,email,docId;
  MyProfile({required this.name, required this.phone, required this.email,required this.docId});
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  int num = 0;
  bool isEdit = false;
  String name="";
  String phone="";
  String email="";
  void edit() {
    setState(() {
      isEdit = !isEdit;
    });
  }
  @override
  void dispose() {
    myName.dispose();
    myPhone.dispose();
    myEmail.dispose();
    super.dispose();
  }
  @override
  void initState() {
    name=widget.name;
    email=widget.email;
    phone=widget.phone;
    myName = TextEditingController()..text = name;
    myPhone = TextEditingController()..text = phone;
    myEmail = TextEditingController()..text = email;
    // TODO: implement initState
    super.initState();
  }


  TextEditingController myName = TextEditingController();
  TextEditingController myEmail = TextEditingController();
  TextEditingController myPhone = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
        elevation: 0,
        title: Center(child: Text("User Profile")),
        backgroundColor: Colors.red,
        actions: [
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: isEdit
                  ? GestureDetector(
                      onTap: () {
                        edit();
                        print(widget.docId + " " + name);
                        Database.updateUser(
                            name: name,
                            email: email,
                            phone: phone,
                            docId: widget.docId);
                      },
                      child: Text("Save"))
                  : GestureDetector(
                      onTap: () {
                        edit();
                      },
                      child: Text("Edit")),
            ),
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Column(
                children: [
                  TextField(
                    onChanged: (newValue) {
                      name = newValue;
                    },
                    enabled: isEdit,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                    ),
                    controller: myName,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    onChanged: (newValue) {
                      email = newValue;
                    },
                    enabled: isEdit,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email Id',
                    ),
                    controller: myEmail,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    onChanged: (newValue) {
                      phone = newValue;
                    },
                    enabled: isEdit,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Phone No.',
                    ),
                    controller: myPhone,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Buttons(
              text: 'LogOut',
              onPress: () async{
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool("isLogin", false);
                FirebaseAuth.instance.signOut();
                print(FirebaseAuth.instance.currentUser);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            )
          ],
        ),
      ),
    );
  }
}
