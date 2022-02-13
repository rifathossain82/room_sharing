import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:room_sharing/services/sendEmail.dart';
import 'package:room_sharing/widgets/appbar.dart';

import '../constraints/colors.dart';
import '../services/showMessage.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {

  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  int clickTime=0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forget Password'),
        elevation: 0,
        flexibleSpace: MyAppBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              Container(
                alignment: Alignment.center,
                child: TextFormField(
                  validator: (value){
                    if (value!.isEmpty) {
                      return 'Last Name required!';
                    }
                    else {
                      return null;
                    }
                  },
                  controller: lastNameController,
                  maxLines: 1,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      labelText: "Last Name",
                      border: OutlineInputBorder()
                  ),
                ),
              ),
              SizedBox(height: 16,),
              Container(
                alignment: Alignment.center,
                child: TextFormField(
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
                  controller: emailController,
                  maxLines: 1,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email Address",
                    border: OutlineInputBorder()
                  ),
                ),
              ),
              SizedBox(height: 16,),
              Container(
                alignment: Alignment.center,
                child: TextFormField(
                  validator: (value){
                    if (value!.isEmpty) {
                      return 'Phone Number required!';
                    }
                    else if (value.length<10) {
                      return 'Incorrect Phone Number!';
                    }
                    else {
                      return null;
                    }
                  },
                  controller: phoneController,
                  maxLines: 1,
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    prefixText: "+880 ",
                    border: OutlineInputBorder()
                  ),
                ),
              ),
              SizedBox(height: 30,),
              TextButton(
                onPressed: (){
                  if(formKey.currentState!.validate()){
                    checkRegistration(context);
                    setState(() {
                      clickTime++;
                    });
                  }

                },
                child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        gradient: LinearGradient(colors: [
                          color2,
                          color1
                        ])),
                    child: Text(
                      clickTime==0?'Send email':'Resend email',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void checkRegistration(BuildContext context) async {
    FirebaseFirestore.instance
        .collection('user')
        .where('lastName', isEqualTo: lastNameController.text.trim())
        .where('email', isEqualTo: emailController.text.trim())
        .where('phone', isEqualTo: phoneController.text.trim())
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        showMessage('No User Found!');
      } else {
        sendEmail(name: '', email: emailController.text.trim(), subject: 'Room Sharing account password', message: querySnapshot.docs[0]['password']);
      }
    });
  }

}
