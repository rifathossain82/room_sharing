import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:room_sharing/constraints/colors.dart';
import 'package:room_sharing/screens/profileScreen/ProfileScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NavigationDrawerHeader extends StatefulWidget {
  const NavigationDrawerHeader({Key? key}) : super(key: key);

  @override
  _NavigationDrawerHeaderState createState() => _NavigationDrawerHeaderState();
}

class _NavigationDrawerHeaderState extends State<NavigationDrawerHeader> {

  late SharedPreferences sharedPreferences;
  String email = '';
  String profilePicUrl = '';
  String name = '';
  String phone = '';

  void getEmail() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      email = sharedPreferences.getString('email')!;
    });
  }
  void getUserData() async {
    FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: email)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        //is empty
      } else {
        profilePicUrl=querySnapshot.docs[0]['profilePic'];
        name=querySnapshot.docs[0]['firstName']+" "+querySnapshot.docs[0]['lastName'];
        phone=querySnapshot.docs[0]['phone'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    getEmail();
    getUserData();
    final size=MediaQuery.of(context).size;
    return DrawerHeader(
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  color2,
                  color1
                ]
            ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            profilePicUrl.isEmpty?
                Center(child: Icon(Icons.account_circle,color: Colors.white,size: size.width/4,)):
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
              },
              child: Container(
                height: size.width/4,
                width: size.width/4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(profilePicUrl,),
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  )
                ),
              ),
            ),
            SizedBox(height: size.width*0.01,),
            Text(name,style: TextStyle(fontSize: 20,color: Colors.white),),
            SizedBox(height: size.width*0.03,),
          ],
        )
    );
  }
}
