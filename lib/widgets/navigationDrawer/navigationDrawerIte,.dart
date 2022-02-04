import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget NavigationDrawerItem(IconData icon,String text,GestureTapCallback onTap){
  return ListTile(
    title: Row(
      children: [
        Icon(icon),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(text),
        ),
      ],
    ),
    onTap: onTap,
  );
}