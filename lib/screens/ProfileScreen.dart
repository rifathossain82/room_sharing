import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/appbar.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late SharedPreferences sharedPreferences;
  String email = '';
  String profilePicUrl = '';
  String name = '';
  String phone = '';
  String location = '';
  String password = '';

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
        location=querySnapshot.docs[0]['address'];
        password=querySnapshot.docs[0]['password'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    getEmail();
    getUserData();
    final size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            overflow: Overflow.visible,
            children: [
              Container(
                height: size.height/3,
                width: size.width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.purple,
                            Colors.red
                          ],
                          begin: Alignment.bottomRight,
                          end: Alignment.topLeft
                      )
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height/15,horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                            onTap: (){
                            Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back,color: Colors.white,)
                        ),
                        SizedBox(width: 16,),
                        Text('Profile Page',style: TextStyle(color: Colors.white,fontSize: 18),)
                      ],
                    ),
                  )
              ),
              Positioned(
                  bottom: -size.height/8,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Stack(
                          children:[ Container(
                              height: size.height/4,
                              width: size.height/4,
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(100),
                                  border: Border.all(
                                      width: 5, color: Colors.white)),
                              child: ClipOval(
                                child: ShaderMask(
                                  shaderCallback: (bounds) =>
                                      LinearGradient(
                                          colors: [
                                            Colors.black38.withOpacity(0.2),
                                            Colors.black87.withOpacity(0.8)
                                          ],
                                          begin: Alignment.center,
                                          end: Alignment.bottomCenter)
                                          .createShader(bounds),
                                  blendMode: BlendMode.darken,
                                  child: CircleAvatar(
                                    radius: 100,
                                    backgroundColor: Colors.white,
                                    backgroundImage: NetworkImage(
                                      profilePicUrl,
                                    ),
                                  ),
                                ),
                              )),
                            Positioned(
                              left: 78,
                              bottom: 20,
                              child: Icon(
                                Icons.security_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ]),
                      Positioned(
                        child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color:
                                Colors.white70.withOpacity(0.5),
                                borderRadius:
                                BorderRadius.circular(100)),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white70,
                            )),
                      )
                    ],
                  ))
            ],
          ),
          SizedBox(height: size.height*0.15,),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                children: [
                  //Text('Account',style: TextStyle(fontSize: 20,color: Colors.white),),
                  //SizedBox(height: size.height*0.04,),
                  Text(name,style: TextStyle(fontSize: 18,color: Colors.white),),
                  SizedBox(height: size.height*0.01,),
                  Text('Tap to change name',style: TextStyle(fontSize: 14,color: Colors.white.withOpacity(0.6)),),
                  SizedBox(height: size.height*0.02,),
                  Divider(color: Colors.white.withOpacity(0.5)),

                  SizedBox(height: size.height*0.02,),
                  Text(phone,style: TextStyle(fontSize: 18,color: Colors.white),),
                  SizedBox(height: size.height*0.01,),
                  Text('Tap to change phone number',style: TextStyle(fontSize: 14,color: Colors.white.withOpacity(0.6)),),
                  SizedBox(height: size.height*0.02,),
                  Divider(color: Colors.white.withOpacity(0.5)),

                  SizedBox(height: size.height*0.02,),
                  Text(email,style: TextStyle(fontSize: 18,color: Colors.white),),
                  SizedBox(height: size.height*0.01,),
                  Text('Tap to change email address',style: TextStyle(fontSize: 14,color: Colors.white.withOpacity(0.6)),),
                  SizedBox(height: size.height*0.02,),
                  Divider(color: Colors.white.withOpacity(0.5)),

                  SizedBox(height: size.height*0.02,),
                  Text(location,style: TextStyle(fontSize: 18,color: Colors.white),),
                  SizedBox(height: size.height*0.01,),
                  Text('Tap to change location',style: TextStyle(fontSize: 14,color: Colors.white.withOpacity(0.6)),),
                  SizedBox(height: size.height*0.02,),
                  Divider(color: Colors.white.withOpacity(0.5)),

                  SizedBox(height: size.height*0.02,),
                  Text('******',style: TextStyle(fontSize: 18,color: Colors.white),),
                  SizedBox(height: size.height*0.01,),
                  Text('Tap to change password',style: TextStyle(fontSize: 14,color: Colors.white.withOpacity(0.6)),),
                  SizedBox(height: size.height*0.02,),
                  //Divider(color: Colors.white.withOpacity(0.5)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
