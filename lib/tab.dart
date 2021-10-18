import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scan_and_order/screens/cartScreen.dart';
import 'package:scan_and_order/screens/orderScreen.dart';
import 'screens/menuScreen.dart';

class TabContainerDefault extends StatefulWidget {

  @override
  _TabContainerDefaultState createState() => _TabContainerDefaultState();
}

class _TabContainerDefaultState extends State<TabContainerDefault> {
  late List<Widget> listScreens;
  @override
  void initState() {
    Firebase.initializeApp();
    super.initState();
    listScreens = [
      MenuScreen(),
      CartScreen(),
      OrderScreens(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    const color = const Color(0xffedfdfb);
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          body: TabBarView(
              physics: NeverScrollableScrollPhysics(), children: listScreens),
          bottomNavigationBar: Container(
            height: MediaQuery.of(context).size.height*0.068,
            color: color,
            child: TabBar(

              indicatorColor: Colors.red,
              labelColor: Colors.red,
              unselectedLabelColor: Colors.black,
              tabs: [
                Tab(
                  text: 'Menu',
                  icon: Icon(Icons.home),
                ),
                Tab(
                  text: 'Your Cart',
                  icon: Icon(Icons.report_problem),
                ),
                Tab(
                  text: 'Your Order',
                  icon: Icon(Icons.settings),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}