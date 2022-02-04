import 'package:flutter/material.dart';
import 'package:room_sharing/screens/registerScreen.dart';

import '../widgets/background.dart';

class LoginScreen extends StatelessWidget {

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "LOGIN",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2661FA),
                      fontSize: 36
                  ),
                  textAlign: TextAlign.left,
                ),
              ),

              SizedBox(height: size.height * 0.03),

              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}').hasMatch(
                            value!)) {
                      return 'Enter Correct Email Address!';
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
                      suffixIcon: Icon(Icons.email_outlined)
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.02),

              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty || !RegExp('').hasMatch(value!)) {
                      return 'Password required!';
                    }
                    else {
                      return null;
                    }
                  },
                  controller: passController,
                  maxLines: 1,
                  obscureText: true,
                  obscuringCharacter: '*',
                  decoration: InputDecoration(
                      labelText: "Password",
                      suffixIcon: IconButton(
                          onPressed: () {}, icon: Icon(Icons.visibility_off))
                  ),
                ),
              ),

              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Text(
                  "Forgot your password?",
                  style: TextStyle(
                      fontSize: 12,
                      color: Color(0XFF2661FA)
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.05),

              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: RaisedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      //Navigator.of(context).pop();
                      emailController.clear();
                      passController.clear();
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0)),
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    width: size.width * 0.5,
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(80.0),
                        gradient: new LinearGradient(
                            colors: [
                              Color.fromARGB(255, 255, 136, 34),
                              Color.fromARGB(255, 255, 177, 41)
                            ]
                        )
                    ),
                    padding: const EdgeInsets.all(0),
                    child: Text(
                      "LOGIN",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: GestureDetector(
                  onTap: () => {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()))
                },
                  child: Text(
                    "Don't Have an Account? Sign up",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2661FA)
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}