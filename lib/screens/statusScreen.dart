import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:scan_and_order/widget/orderDetails.dart';
class StatusScreen extends StatefulWidget {
  bool accept;
  bool reject;
  StatusScreen({required this.accept,required this.reject,required this.docId,
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
  _StatusScreenState createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
bool pending=false;
  @override
  void initState() {
    if(widget.accept==false && widget.reject==false){
      pending=true;
    }
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Fast Food'),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(

                  child:Column(
                    children: [
                      pending?Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Lottie.asset('assets/pending.json'),
                          Center(child: Text("Your Order is Pending. Please Wait for Sometime.",style: TextStyle(fontSize: 15),))
                        ],
                      ):Container(),
                      widget.accept?Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Lottie.asset('assets/accept.json'),
                          Center(child: Text("Your Order is Accepted. You Will Receive in Some Time",style: TextStyle(fontSize: 15),))
                        ],
                      ):Container(),
                      widget.reject?Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Lottie.asset('assets/reject.json'),
                          Center(child: Text("Your Order is Rejected. Please Try Talk With Someone.",style: TextStyle(fontSize: 15),))
                        ],
                      ):Container(),
                      orderDetails(docId: widget.docId, orderNo: widget.orderNo, order: widget.order, note: widget.note, timestamp: widget.timestamp)
                    ],
                  ),
                ),

              ],
            ),
          ),
        ));
  }
}
