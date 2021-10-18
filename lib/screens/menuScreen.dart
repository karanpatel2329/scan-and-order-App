import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:scan_and_order/Data/firestore.dart';
import 'package:scan_and_order/constant.dart';
import 'package:scan_and_order/screens/myAccount.dart';
import 'package:scan_and_order/widget/foodItem.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with AutomaticKeepAliveClientMixin<MenuScreen> {
 String _chosenValue="All";

  String name = "";
 String email = "";
 String phone = "";
  String docId = "";

  @override
  void initState() {
   init();
   getUser();
    super.initState();
  }
  void init() async{
   await Firebase.initializeApp();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Fast Food'),
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.08,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 130,
                  decoration: BoxDecoration(color: Constant.colorLight,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.sort),
                  Container(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        iconSize: 0.0,
                        value: _chosenValue,
                        //elevation: 5,
                        style: TextStyle(color: Colors.black),

                        items: <String>[
                          'All',
                          'Pizza',
                          'Burger',
                          'Shake',
                          'South Indian',
                          'North Indian',
                          'Chinese',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value){
                          setState(() {
                            _chosenValue=value!;
                          });
                        },
                      ),
                    ),
                  ),

                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Any Query?\n',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Click Here,',
                          recognizer: TapGestureRecognizer()..onTap=(){
                            print("HELLO Waiter");
                          },
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                      TextSpan(
                          text: ' To Call Waiter.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height*0.75,
            child:StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('menuItem').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        print(index);
                        DocumentSnapshot doc = snapshot.data!.docs[index];
                        return  FoodItem(id: index,name: doc['itemName'],price: doc['itemPrice'],quantity: doc['itemQuantity'],image: doc['itemImage'],docId:doc.id);
                      });
                } else {
                  return Text("No data");
                }
              },
            )
            // ListView(
            //   children: [
            //     FoodItem(id: 1,name: "Cheese Pizza",price: 5.3,),
            //     FoodItem(id: 2,name: "Tomato Pizza",price: 9.4,),
            //     FoodItem(id: 3,name: "Onion Pizza",price: 5.4,),
            //     FoodItem(id: 4,name: "Veg Pizza",price: 3.3,),
            //     FoodItem(id: 5,name: "Non Pizza",price: 5.4,),
            //     FoodItem(id: 6,name: "Pineapple Pizza",price: 10.3,),
            //     FoodItem(id: 7,name: "Combo Pizza",price: 15.32,),
            //     FoodItem(id: 8,name: "SeaFood Pizza",price: 15.36,),
            //     FoodItem(id: 9,name: "KFC Pizza",price: 10.8,),
            //   ],
            // ),
          )
        ],
      )
    );
  }

  @override
  bool get wantKeepAlive => true;
}

