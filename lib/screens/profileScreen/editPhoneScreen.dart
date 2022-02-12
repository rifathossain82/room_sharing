import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/appbar.dart';

class EditPhoneScreen extends StatefulWidget {
  String number;
  var id;
  EditPhoneScreen({Key? key,required this.number,required this.id}) : super(key: key);

  @override
  _EditPhoneScreenState createState() => _EditPhoneScreenState();
}

class _EditPhoneScreenState extends State<EditPhoneScreen> {

  TextEditingController numberController=TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Number'),
        flexibleSpace: MyAppBar(),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: (){
                if(numberController.text.isEmpty){
                  Navigator.pop(context);
                }
                else{
                  if(formKey.currentState!.validate()){
                    widget.id.reference.update(
                        {
                          'phone': numberController.text.toString().trim(),
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
                    if (value!.length<10) {
                      return 'Incorrect Phone Number!';
                    }
                    else {
                      return null;
                    }
                  },
                  controller: numberController,
                  maxLines: 1,
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: widget.number,
                    prefixText: "+880 ",
                  ),
                ),
              ),

              SizedBox(
                height: 50,
              ),
              Text('You can use only 0-9 number',style: TextStyle(fontSize: 15,color: Colors.grey),)
            ],
          ),
        ),
      ),
    );
  }
}
