import 'package:flutter/material.dart';
import 'package:room_sharing/constraints/strings.dart';

import '../widgets/navigationDrawer/navigationDrawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String routeName = '/Home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(app_name),
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Image.asset(
              'assets/images/main.png',
              height: 30,
              width: 30,
            ),
          )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.only(left: 16,right: 16,top: 8,bottom: 16),
            child: TextField(
              decoration: InputDecoration(
                  hintText: 'Uttara, Dhaka',
                  prefixIcon: Icon(Icons.search),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.white, width: 0)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.white, width: 0))),
            ),
          ),
        ),
      ),
      body: Center(
        child: Text('This is Home Page'),
      ),
      drawer: NavigationDrawer(),
    );
  }
}
