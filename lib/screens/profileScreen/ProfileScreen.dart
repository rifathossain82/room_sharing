import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:room_sharing/screens/profileScreen/editLocationScreen.dart';
import 'package:room_sharing/screens/profileScreen/editNameScreen.dart';
import 'package:room_sharing/screens/profileScreen/editPasswordScreen.dart';
import 'package:room_sharing/screens/profileScreen/editPhoneScreen.dart';
import 'package:room_sharing/services/showMessage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/firebaseApi.dart';
import '../../widgets/appbar.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late SharedPreferences sharedPreferences;
  String email = '';
  String profilePicUrl = '';
  String fname = '';
  String lname = '';
  String phone = '';
  String location = '';
  String password = '';
  var data_id;

  final loginFormKey = GlobalKey<FormState>();
  TextEditingController loginEmailController=TextEditingController();
  TextEditingController loginPassController=TextEditingController();
  bool loginObscureValue=true;

  File? _profileImg;
  UploadTask? profileTask;
  File? profileFile;

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
        fname=querySnapshot.docs[0]['firstName'];
        lname=querySnapshot.docs[0]['lastName'];
        phone=querySnapshot.docs[0]['phone'];
        location=querySnapshot.docs[0]['address'];
        password=querySnapshot.docs[0]['password'];
        data_id=querySnapshot.docs[0];
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
      appBar: AppBar(
        title: Text('Profile Page'),
        flexibleSpace: MyAppBar(),
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: size.height*0.08,),
          Stack(
          alignment: Alignment.bottomRight,
          children: [
            Stack(
                children:[
                  Container(
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
                  child: IconButton(
                    icon: Icon(Icons.camera_alt,color: Colors.white,),
                    onPressed: (){
                      pickProfileImage();
                    },
                  )),
            )
          ],
        ),
          SizedBox(height: size.height*0.06,),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                children: [
                  //name section
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>EditNameScreen(fName: fname,lName: lname,id: data_id,)));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(fname+" "+lname,style: TextStyle(fontSize: 18,color: Colors.white),),
                        SizedBox(height: size.height*0.01,),
                        Text('Tap to change name',style: TextStyle(fontSize: 14,color: Colors.white.withOpacity(0.6)),),
                        SizedBox(height: size.height*0.02,),
                      ],
                    ),
                  ),

                  Divider(color: Colors.white.withOpacity(0.5)),

                  //phone number section
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>EditPhoneScreen(number: phone,id: data_id,)));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: size.height*0.02,),
                        Text('0${phone}',style: TextStyle(fontSize: 18,color: Colors.white),),
                        SizedBox(height: size.height*0.01,),
                        Text('Tap to change phone number',style: TextStyle(fontSize: 14,color: Colors.white.withOpacity(0.6)),),
                        SizedBox(height: size.height*0.02,),
                      ],
                    ),
                  ),

                  Divider(color: Colors.white.withOpacity(0.5)),

                  //address section
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>EditAddressScreen(address: location,id: data_id,)));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: size.height*0.02,),
                        Text(location,style: TextStyle(fontSize: 18,color: Colors.white),),
                        SizedBox(height: size.height*0.01,),
                        Text('Tap to change your address',style: TextStyle(fontSize: 14,color: Colors.white.withOpacity(0.6)),),
                        SizedBox(height: size.height*0.02,),
                      ],
                    ),
                  ),

                  Divider(color: Colors.white.withOpacity(0.5)),

                  //password section
                  InkWell(
                    onTap: (){
                      Alert(
                          context: context,
                          title: "LOGIN",
                          content: Form(
                            key: loginFormKey,
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  validator: (value){
                                    if (value!.isEmpty) {
                                      return 'Email address required!';
                                    }
                                    else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}').hasMatch(value)) {
                                      return 'Incorrect Email Address!';
                                    }
                                    else {
                                      return null;
                                    }
                                  },
                                  controller: loginEmailController,
                                  maxLines: 1,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.email_outlined),
                                    labelText: 'Email Address',
                                  ),
                                ),
                                TextFormField(
                                  validator: (value){
                                    if (value!.isEmpty) {
                                      return 'Password required!';
                                    }
                                    else if (value.length<6) {
                                      return 'Password must be 6 character!';
                                    }
                                    else {
                                      return null;
                                    }
                                  },
                                  controller: loginPassController,
                                  maxLines: 1,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.lock),
                                    labelText: 'Password',
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          loginObscureValue=!loginObscureValue;
                                        });
                                      },
                                      icon: loginObscureValue?Icon(Icons.visibility_off):Icon(Icons.visibility),
                                  ),
                                ),
                                ),
                              ],
                            ),
                          ),
                          buttons: [
                            DialogButton(
                              onPressed: (){
                                if(loginFormKey.currentState!.validate()){
                                  if(loginEmailController.text==email && loginPassController.text==password){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>EditPassworScreen(password: password,id: data_id,)));
                                    Navigator.pop(context);
                                    loginEmailController.clear();
                                    loginPassController.clear();
                                  }
                                  else{
                                    showMessage('Login Failed!!');
                                    Navigator.pop(context);
                                    loginEmailController.clear();
                                    loginPassController.clear();
                                  }
                                }
                              },
                              child: Text(
                                "LOGIN",
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                            )
                          ]).show();
                     //
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: size.height*0.02,),
                        Text('******',style: TextStyle(fontSize: 18,color: Colors.white),),
                        SizedBox(height: size.height*0.01,),
                        Text('Tap to change password',style: TextStyle(fontSize: 14,color: Colors.white.withOpacity(0.6)),),
                        SizedBox(height: size.height*0.02,),
                      ],
                    ),
                  ),
                  //Divider(color: Colors.white.withOpacity(0.5)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /*
  Stack(
            alignment: Alignment.center,
            overflow: Overflow.visible,
            clipBehavior: Clip.none,
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
                          children:[
                            Container(
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
                            child: IconButton(
                              icon: Icon(Icons.camera_alt),
                              onPressed: (){
                                print('hi');
                              },
                            )),
                      )
                    ],
                  ))
            ],
          ),
   */

  void uploadImage()async {
    final fileName0 = basename(profileFile!.path);
    final profiledestination = 'files/${email}/$fileName0';
    profileTask = FirebaseApi.uploadTask(profiledestination, _profileImg!);
    setState(() {});

    if (profileTask == null) {
      return;
    }
    else{
      final profileSnapshot = await profileTask!.whenComplete(() {
        setState(() {});
      });

      final profilePic = await profileSnapshot.ref.getDownloadURL();
      data_id.reference.update(
          {
            'profilePic': profilePic,
          }).whenComplete((){
         print('update profile image');
         setState(() {});
      });
    }
  }

  Future pickProfileImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      //final imageTemporary=File(image.path);   //to set image temporary
      final imagePermanent = await saveImagePermanently(
          image.path); //to set image permanent in local storage
      setState(() {
        this._profileImg = imagePermanent;
        final path = image.path;
        profileFile = File(path);

        //to upload image
        uploadImage();
      });
    } on PlatformException catch (e) {
      print('Faild to pick image: $e');
    }
  }
  Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }
}
