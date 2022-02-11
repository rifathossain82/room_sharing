import 'package:flutter/material.dart';

Widget MyAppBar(){
  return Container(
    decoration: BoxDecoration(
      // ignore: prefer_const_constructors
      gradient: LinearGradient(
          colors: [
            Colors.purple,
            Colors.red
          ],
        begin: Alignment.bottomRight,
        end: Alignment.topLeft
      )
    ),
  );
}