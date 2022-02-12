import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/appbar.dart';

class EditPassworScreen extends StatefulWidget {
  String password;
  var id;
  EditPassworScreen({Key? key,required this.password,required this.id}) : super(key: key);

  @override
  _EditPassworScreenState createState() => _EditPassworScreenState();
}

class _EditPassworScreenState extends State<EditPassworScreen> {

  TextEditingController passController=TextEditingController();
  TextEditingController confirmPassController=TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool obscureValue=true;
  bool obscureValue2=true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password'),
        flexibleSpace: MyAppBar(),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: (){
                if(passController.text.isEmpty && confirmPassController.text.isEmpty){
                  Navigator.pop(context);
                }
                else if(passController.text.isNotEmpty && confirmPassController.text.isNotEmpty){
                  if(formKey.currentState!.validate()){
                    widget.id.reference.update(
                        {
                          'password': passController.text.toString().trim(),
                        }).whenComplete((){
                      Navigator.pop(context);
                    });
                  }
                  else{

                  }
                }
              },
              icon: Icon(Icons.check))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 16,
              ),
              Container(
                alignment: Alignment.center,
                child: TextFormField(
                  validator: (value){
                    if (value!.length<6) {
                      return 'Password must be 6 character!';
                    }
                    else {
                      return null;
                    }
                  },
                  controller: passController,
                  maxLines: 1,
                  obscureText: obscureValue,
                  decoration: InputDecoration(
                      hintText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscureValue=!obscureValue;
                          });
                        },
                        icon: obscureValue?Icon(Icons.visibility_off):Icon(Icons.visibility),
                      )),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                alignment: Alignment.center,
                child: TextFormField(
                  validator: (value){
                    if (value!.length<6) {
                      return 'Confirm Password must be 6 character!';
                    }
                    else if (!value.contains(passController.text)) {
                      return 'Passwords do not match!!';
                    }
                    else {
                      return null;
                    }
                  },
                  controller: confirmPassController,
                  maxLines: 1,
                  obscureText: obscureValue2,
                  decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscureValue2=!obscureValue2;
                          });
                        },
                        icon: obscureValue2?Icon(Icons.visibility_off):Icon(Icons.visibility),
                      )),
                ),
              ),

              SizedBox(
                height: 50,
              ),
              Text('You can use a-z, 0-9 and underscores.',style: TextStyle(fontSize: 15,color: Colors.grey),)
            ],
          ),
        ),
      ),
    );
  }
}
