import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/appbar.dart';

class EditNameScreen extends StatefulWidget {
  String fName;
  String lName;
  var id;
  EditNameScreen({Key? key,required this.fName,required this.lName,required this.id}) : super(key: key);

  @override
  _EditNameScreenState createState() => _EditNameScreenState();
}

class _EditNameScreenState extends State<EditNameScreen> {

  TextEditingController firstNameController=TextEditingController();
  TextEditingController lastNameController=TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Name'),
        flexibleSpace: MyAppBar(),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: (){
                if(firstNameController.text.isEmpty && lastNameController.text.isEmpty){

                }
                else if(firstNameController.text.isNotEmpty && lastNameController.text.isNotEmpty){
                  widget.id.reference.update(
                      {
                        'firstName': firstNameController.text.toString().trim(),
                        'lastName': lastNameController.text.toString().trim(),
                      }).whenComplete((){
                    // print('update');
                  });
                }
                else if(firstNameController.text.isNotEmpty){
                  widget.id.reference.update(
                      {
                        'firstName': firstNameController.text.toString().trim(),
                      }).whenComplete((){
                   // print('update');
                  });
                }
                else if(lastNameController.text.isNotEmpty){
                  widget.id.reference.update(
                      {
                        'lastName': lastNameController.text.toString().trim(),
                      }).whenComplete((){
                    //print('update');
                  });
                }
                Navigator.pop(context);
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
                  controller: firstNameController,
                  maxLines: 1,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: widget.fName
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                child: TextFormField(
                  controller: lastNameController,
                  maxLines: 1,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: widget.lName,
                  ),
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
