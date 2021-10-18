import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scan_and_order/constant.dart';

class orderDetails extends StatefulWidget {
  orderDetails(
      {required this.docId,
        required this.orderNo,
        required this.order,
        required this.note,
        required this.timestamp});

  final int orderNo;
  final String order;
  String note = '';
  final Timestamp timestamp;
  final String docId;
  @override
  _orderDetailsState createState() => _orderDetailsState();
}

class _orderDetailsState extends State<orderDetails> {
  var value;

  @override
  void initState() {
    //storage();
    // TODO: implement initState
    super.initState();
  }

  String dateFormat(hour, min) {
    if (hour == 0) {
      return ("12:" + min.toString() + " AM");
    } else {
      if (hour <= 12) {
        return (hour.toString() + ":" + min.toString() + " AM");
      } else {
        return ((hour - 12).toString() + ":" + min.toString() + " PM");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            color: Constant.colorLight,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Order No:- " + widget.orderNo.toString(),
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.timestamp.toDate().day.toString() +
                            "/" +
                            widget.timestamp.toDate().month.toString() +
                            "/" +
                            widget.timestamp.toDate().year.toString() +
                            " - " +
                            dateFormat(widget.timestamp.toDate().hour,
                                widget.timestamp.toDate().minute),
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(widget.order.replaceAll(",", "\n")),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Note:-",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(widget.note)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
