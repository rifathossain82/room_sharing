import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/appbar.dart';

class EditAddressScreen extends StatefulWidget {
  String address;
  var id;
  EditAddressScreen({Key? key,required this.address,required this.id}) : super(key: key);

  @override
  _EditAddressScreenState createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {

  TextEditingController addressController=TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Address'),
        flexibleSpace: MyAppBar(),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: (){
                if(addressController.text.isEmpty){
                  Navigator.pop(context);
                }
                else{
                  widget.id.reference.update(
                      {
                        'address': addressController.text.toString().trim(),
                      }).whenComplete((){
                    Navigator.pop(context);
                  });
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
                  controller: addressController,
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: widget.address
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
