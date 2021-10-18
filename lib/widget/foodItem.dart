import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scan_and_order/Data/firestore.dart';
import 'package:scan_and_order/Model/cart.dart';
import 'package:scan_and_order/Model/item.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';

class FoodItem extends StatefulWidget {
  FoodItem({required this.name, required this.price, required this.id,required this.quantity, required this.image,required this.docId});
  final String name;
  final double price;
  final String image;
  int quantity;
  final int id;
  final String docId;
  @override
  _FoodItemState createState() => _FoodItemState();
}

class _FoodItemState extends State<FoodItem> {
  var value;
  late SharedPreferences prefs;

  @override
  void initState() {
    print("Her");
   getQuantity();
    // TODO: implement initState
    super.initState();
  }
  void getQuantity(){
    // final cart = Provider.of<Cart>(context);
    // bool isFound=false;
    // for(var i in cart.items){
    //   if(i.itemName==widget.name){
    //     isFound=true;
    //    setState(() {
    //      widget.quantity=i.itemQuantity;
    //    });
    //   }
    // }
    // if(isFound==false){
    //   widget.quantity=0;
    // }
  }


  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        height: MediaQuery.of(context).size.height * 0.15,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            color: Constant.colorLight,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.crop_square_sharp,
                  color: Colors.green,
                  size: 30,
                ),
                Icon(Icons.circle, color: Colors.green, size: 10),
              ],
            ),
            SizedBox(
              width: 5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Text("\$" + widget.price.toString()),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.025,
                ),
                widget.quantity == 0
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.quantity = widget.quantity + 1;
                            if(widget.quantity>=1){
                              cart.add(Item(itemId: widget.id,itemName: widget.name,itemPrice: widget.price,itemQuantity: widget.quantity));
                            }

                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          padding:
                              EdgeInsets.symmetric(vertical: 9, horizontal: 18),
                          child: Text("Add"),
                        ),
                      )
                    : Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (widget.quantity > 1) {
                                    print("Here >1");
                                    widget.quantity = widget.quantity - 1;

                                    cart.add(Item(itemId: widget.id,itemName: widget.name,itemPrice: widget.price,itemQuantity: widget.quantity));
                                    //clear(widget.id);
                                  }else{
                                    if(widget.quantity==1){
                                      widget.quantity=0;
                                      print("Here==1");

                                      cart.remove(Item(itemId: widget.id,itemName: widget.name,itemPrice: widget.price,itemQuantity: widget.quantity));
                                    }
                                  }
                                  print("Outside");

                                });
                              },
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.white,
                                child: Text(
                                  "-",
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.black),
                                ),
                              ),
                            ),
                            Text(
                              widget.quantity.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  widget.quantity = widget.quantity + 1;
                                  if(widget.quantity>=1){
                                    cart.add(Item(itemId: widget.id,itemName: widget.name,itemPrice: widget.price,itemQuantity: widget.quantity));
                                  }

                                });
                              },
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.white,
                                child: Text(
                                  "+",
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.black),
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
                width: MediaQuery.of(context).size.width * 0.15,
              ),
            ),
            GestureDetector(
              onTap: () {
                print(FirebaseAuth.instance.currentUser);
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width * 0.25,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    image: DecorationImage(
                      image: NetworkImage(widget.image),
                      //image: AssetImage("assets/cheese-pizza.jpg"),
                        fit: BoxFit.fill)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
