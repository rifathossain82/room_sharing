import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget NavigationDrawerHeader(){
  return DrawerHeader(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/main.png'),
          )
      ),
      child: Stack(
        children: [
          Positioned(
              bottom: 12,
              left: 16,
              child: Text('Welcome to Flutter',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white),))
        ],
      )
  );
}