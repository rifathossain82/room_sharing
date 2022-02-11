import 'package:flutter/material.dart';
import 'package:room_sharing/constraints/colors.dart';

Widget NavigationDrawerItem(IconData icon,String text,GestureTapCallback onTap){
  return ListTile(
    title: Row(
      children: [
        Icon(icon,color: color1,),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(text,style: TextStyle(color: color1),),
        ),
      ],
    ),
    onTap: onTap,
  );
}