import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scan_and_order/Data/firestore.dart';
import 'package:scan_and_order/constant.dart';
import 'package:scan_and_order/screens/statusScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'myAccount.dart';

class OrderScreens extends StatefulWidget {
  @override
  _OrderScreensState createState() => _OrderScreensState();
}

class _OrderScreensState extends State<OrderScreens>
    with AutomaticKeepAliveClientMixin<OrderScreens> {
  String email = "";
  String name = "";
  String phone = "";
  String docId = "";

  @override
  void initState() {
    super.initState();
    getUser();
    _initializeFirebase();
    print('initState OrderScreens');
  }
  Future<User?> getUser() async {
    User? user =await FirebaseAuth.instance.currentUser;

    print(user);
    if (user != null) {
      var a = await Database.getUserInfo(user.uid);
      await a.forEach((element) {
        element.docs.forEach((element) {
          setState(() {
            docId = element.id;
            name = element.get("name");
            email = element.get("email");
            phone = element.get("mobile");
          });
        });
      });
    } else {
      setState(() {
        name = "";
        email = "";
        phone = "";
        docId = "";
      });
    }
    print(email);
//    print();
    return user;
  }
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    print(firebaseApp);
    print(FirebaseAuth.instance.currentUser!.email);
    setState(() {
      email = FirebaseAuth.instance.currentUser!.email!;
    });
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Fast Food'),
          backgroundColor: Colors.red,
          actions: [
            GestureDetector(
              onTap: (){
                print("Here");

                Navigator.push(context, MaterialPageRoute(builder: (context)=>MyProfile(docId: docId,name: name,phone: phone,email: email,)));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.account_circle,size: 30,),
              ),
            )
          ],
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.825,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('orderRecieved')
                      .where("email", isEqualTo: email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot doc = snapshot.data!.docs[index];
                            Timestamp date = doc['date'];
                            DateTime d = date.toDate();
                            bool accept = doc['accept'];
                            bool reject = doc['reject'];
                            bool pending = accept == false && reject == false;
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StatusScreen(
                                          docId: doc.id,
                                              order: doc['order'],
                                              orderNo: doc['orderNo'],
                                              note: doc['note'],
                                              timestamp: doc['date'],
                                              accept: doc['accept'],
                                              reject: doc['reject'],
                                            )));
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                decoration: BoxDecoration(
                                  color: accept
                                      ? Colors.green
                                      : reject
                                          ? Colors.red
                                          : pending
                                              ? Colors.orangeAccent
                                              : Constant.colorLight,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Column(
                                  children: [
                                    Column(
                                      children: [
                                        pending
                                            ? Text(
                                                "Your Order is Pending",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black),
                                              )
                                            : Container(),
                                        accept
                                            ? Text(
                                                "Your Order is Accepted",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black),
                                              )
                                            : Container(),
                                        reject
                                            ? Text(
                                                "Your Order is Rejected",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          "Order No:- " +
                                              doc['orderNo'].toString(),
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          "Date:- " +
                                              d.day.toString() +
                                              "/" +
                                              d.month.toString() +
                                              "/" +
                                              d.year.toString(),
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "Total Bill Amount:- " +
                                          doc['bill'].toString(),
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            );
                            //return  FoodItem(id: index,name: doc['itemName'],price: doc['itemPrice'],quantity: doc['itemQuantity'],image: doc['itemImage'],docId:doc.id);
                          });
                    } else {
                      return Text("No data");
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
