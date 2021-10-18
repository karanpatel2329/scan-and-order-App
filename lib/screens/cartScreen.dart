import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scan_and_order/Data/firestore.dart';
import 'package:scan_and_order/Model/cart.dart';
import 'package:scan_and_order/Model/item.dart';
import 'package:scan_and_order/constant.dart';
import 'package:scan_and_order/screens/statusScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'myAccount.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with AutomaticKeepAliveClientMixin<CartScreen> {
  late SharedPreferences prefs;
  late final List<Cart> carts;
  double total = 0;
  String order="";
  String note="";
  double bill=0.0;
  String name = "";
  String email = "";
  String phone = "";
  String docId = "";

  @override
  bool get wantKeepAlive => false;

  @override
  void initState() {
    getUser();
    super.initState();

    print('initState CartScreen');
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
  String getOrder(){
    bill=Provider.of<Cart>(context, listen: false).getTotal();
    List<Item> cart = Provider.of<Cart>(context,listen: false).getList();
    order="";
    for( var i in cart){
      order+= i.itemName+"-"+i.itemQuantity.toString()+",";
//      print(i.itemName+"-"+i.itemQuantity.toString()+",");
    }
    print(order);
    return order;
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    super.build(context);
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
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "Your Cart",
                      style:
                          TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Provider.of<Cart>(context, listen: false).items.length != 0
                      ? Center(
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.height*0.5,

                              child: Consumer<Cart>(
                                  builder: (BuildContext context, carts, child) {
                                return ListView.builder(
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Constant.colorLight,
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(10.0))),
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                            padding: EdgeInsets.all(20),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Icon(
                                              Icons.crop_square_sharp,
                                              color: Colors.green,
                                              size: 30,
                                            ),
                                            Icon(Icons.circle,
                                                color: Colors.green, size: 10),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              carts.items[index].itemName,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 10),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      int quantity = carts
                                                          .items[index]
                                                          .itemQuantity;
                                                      setState(() {
                                                        if (quantity > 1) {
                                                          print("Here >1");
                                                          quantity = quantity - 1;
                                                          cart.add(Item(
                                                              itemId: carts
                                                                  .items[index]
                                                                  .itemId,
                                                              itemName: carts
                                                                  .items[index]
                                                                  .itemName,
                                                              itemPrice: carts
                                                                  .items[index]
                                                                  .itemPrice,
                                                              itemQuantity:
                                                                  quantity));
                                                          //clear(widget.id);
                                                        } else {
                                                          if (quantity == 1) {
                                                            quantity = 0;
                                                            print("Here==1");
                                                            cart.remove(Item(
                                                                itemId: carts
                                                                    .items[index]
                                                                    .itemId,
                                                                itemName: carts
                                                                    .items[index]
                                                                    .itemName,
                                                                itemPrice: carts
                                                                    .items[index]
                                                                    .itemPrice,
                                                                itemQuantity: carts
                                                                    .items[index]
                                                                    .itemQuantity));
                                                          }
                                                        }
                                                        print("Outside");
                                                      });
                                                    },
                                                    child: CircleAvatar(
                                                      radius: 15,
                                                      backgroundColor:
                                                          Colors.white,
                                                      child: Text(
                                                        "-",
                                                        style: TextStyle(
                                                            fontSize: 25,
                                                            color: Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    carts
                                                        .items[index].itemQuantity
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      int quantity = carts
                                                          .items[index]
                                                          .itemQuantity;
                                                      setState(() {
                                                        quantity = quantity + 1;
                                                        if (quantity >= 1) {
                                                          cart.add(Item(
                                                              itemId: carts
                                                                  .items[index]
                                                                  .itemId,
                                                              itemName: carts
                                                                  .items[index]
                                                                  .itemName,
                                                              itemPrice: carts
                                                                  .items[index]
                                                                  .itemPrice,
                                                              itemQuantity:
                                                                  quantity));
                                                        }
                                                        print(quantity);
                                                      });
                                                    },
                                                    child: CircleAvatar(
                                                      radius: 15,
                                                      backgroundColor:
                                                          Colors.white,
                                                      child: Text(
                                                        "+",
                                                        style: TextStyle(
                                                            fontSize: 25,
                                                            color: Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            width: 10,
                                          ),
                                        ),
                                        Text("\$ " +
                                            carts.items[index].itemPrice
                                                .toString())
                                      ],
                                    ),
                                  ),
                                  itemCount: carts.items.length,
                                );
                              })),
                        )
                      :  Container(),
                  Provider.of<Cart>(context, listen: false).items.length != 0?Container(
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Any Note",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        ),),
                        TextFormField(
                          onChanged: (value){
                            setState(() {
                              note=value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: "Enter Your Note Here",
                          ),
                        ),
                      ],
                    ) ,
                  ):Container(),
                  Provider.of<Cart>(context, listen: false).items.length != 0?
                  Center(
                    child: Text(
                      "Your Total Bill :- " +
                          Provider.of<Cart>(context, listen: false)
                              .getTotal()
                              .toStringAsFixed(2)
                              .toString(),
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ):Container(),
                  Provider.of<Cart>(context, listen: false).items.length == 0?
                      Center(
                        child: Text("Your Cart is Empty"),
                      ):Container()
                ],
              ),

              Provider.of<Cart>(context, listen: false).items.length != 0?
              Center(
                  child: FlatButton(
                minWidth: MediaQuery.of(context).size.width * 0.8,
                onPressed: () async{
                 String order= getOrder();
                 await Database.addItem(bill: bill, order: order, orderNo: 10,date: Timestamp.now(),email: FirebaseAuth.instance.currentUser!.email!,note:note);
                 Provider.of<Cart>(context, listen: false).removeAll();
                 var snackBar = SnackBar(
                     content: Text(
                         "Your Order Placed Successfully."));
                 ScaffoldMessenger.of(context)
                     .showSnackBar(snackBar);
                },
                child: Text(
                  "Order Now",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.green,
              )):Container(),
            ],
          ),
        ));
  }
}
