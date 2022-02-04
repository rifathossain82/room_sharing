import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:room_sharing/screens/HomeScreen.dart';

import '../services/firebaseApi.dart';
import '../widgets/background.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  int currentStep = 0;
  bool isCompleted = false;



  File? _image;
  File? _image2;

  Future cameraImage()async{
    try{
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if(image==null) return;

      //final imageTemporary=File(image.path);  //to set image temporary
      final imagePermanent=await saveImagePermanently(image.path);   //to set image permanent in local storage
      setState(() {
        this._image=imagePermanent;
      });
    }
    on PlatformException catch(e){
      print('Faild to pick image: $e');
    }
  }

  Future galleryImage()async{
    try{
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image==null) return;

      //final imageTemporary=File(image.path);   //to set image temporary
      final imagePermanent=await saveImagePermanently(image.path);   //to set image permanent in local storage
      setState(() {
        this._image=imagePermanent;
        final path=image.path;
        file1=File(path!);
      });
    }
    on PlatformException catch(e){
      print('Faild to pick image: $e');
    }
  }

  Future galleryImage2()async{
    try{
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image==null) return;

      //final imageTemporary=File(image.path);   //to set image temporary
      final imagePermanent=await saveImagePermanently(image.path);   //to set image permanent in local storage
      setState(() {
        this._image2=imagePermanent;
        final path=image.path;
        file2=File(path!);
      });
    }
    on PlatformException catch(e){
      print('Faild to pick image: $e');
    }
  }


  Future<File> saveImagePermanently(String imagePath)async{
    final directory=await getApplicationDocumentsDirectory();
    final name=basename(imagePath);
    final image=File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }


  //for firebase firestore
  CollectionReference user =
  FirebaseFirestore.instance.collection('user');
  UploadTask? task;
  UploadTask? task2;
  File? file1;
  File? file2;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
        child: Theme(
                data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(primary: Colors.orange)),
                child: Stepper(
                  //type: StepperType.horizontal,
                  steps: getSteps(context),
                  currentStep: currentStep,
                  onStepContinue: () {
                    final isLastStep = currentStep == getSteps(context).length - 1;

                    if (isLastStep) {
                      setState(() {
                        isCompleted = true;
                      });
                      addUser(context);     //to add user in firebase firestore
                    }
                    else {
                      setState(() {
                        currentStep += 1;
                      });
                    }
                  },
                  onStepCancel: () {
                    currentStep == 0
                        ? null
                        : setState(() {
                            currentStep -= 1;
                          });
                  },

                  controlsBuilder: (context, controlDetails) {
                    final isLastStep = currentStep == getSteps(context).length - 1;
                    return Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          if (currentStep != 0)
                            Expanded(
                              child: TextButton(
                                onPressed: controlDetails.onStepCancel,
                                child: Container(
                                    alignment: Alignment.center,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.0),
                                        gradient: const LinearGradient(colors: [
                                          Color.fromARGB(255, 255, 136, 34),
                                          Color.fromARGB(255, 255, 177, 41)
                                        ])),
                                    padding: const EdgeInsets.all(0),
                                    child: const Text(
                                      'Back',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                                    )),
                              ),
                            ),
                          SizedBox(width: 8,),
                          Expanded(
                            child: TextButton(
                              onPressed: controlDetails.onStepContinue,
                              child: Container(
                                  alignment: Alignment.center,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      gradient: const LinearGradient(colors: [
                                        Color.fromARGB(255, 255, 136, 34),
                                        Color.fromARGB(255, 255, 177, 41)
                                      ])),
                                  padding: const EdgeInsets.all(0),
                                  child: Text(
                                    isLastStep ? 'Continue' : 'Next',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  // onStepTapped: (step)=> setState(() {
                  //   currentStep=step;
                  // }),
                ),
              ),
      ),
    );
  }

  void addUser(BuildContext context)async{
    try{
      final fileName1=basename(file1!.path);
      final fileName2=basename(file2!.path);
      final destination='files/${emailController.text}/$fileName1';
      final destination2='files/${emailController.text}/$fileName2';
      task=FirebaseApi.uploadTask(destination, _image!);
      task2=FirebaseApi.uploadTask(destination2, _image2!);
      setState(() {

      });

      if(task==null){
        return;
      }
      else if(task2==null){

      }
      else{
        final snapshot=await task!.whenComplete((){
          setState(() {

          });
        });
        final snapshot2=await task2!.whenComplete((){
          setState(() {

          });
        });
        final urlNid1=await snapshot.ref.getDownloadURL();
        final urlNid2=await snapshot2.ref.getDownloadURL();
        user.add({
          'firstName': firstNameController.text,
          'lastName': lastNameController.text,
          'phone': phoneController.text,
          'email': emailController.text,
          'address': addressController.text,
          'nid1': urlNid1,
          'nid2': urlNid2,
          'password': passController.text,
        });

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
      }
    }
    catch(e){
      print('Error');
    }
  }


  Widget buildUploadStatus(UploadTask task){
    return StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder:(context,snapshot){
          final snap=snapshot.data;
          final progress=snap!.bytesTransferred/snap.totalBytes;
          final percentage=(progress*100).toStringAsFixed(2);

          return Text('$percentage %',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),);
        }
    );
  }

  List<Step> getSteps(BuildContext context) => [
        Step(
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 0,
            title: Text('Account'),
            content: accountContent()),
        Step(
            state: currentStep > 1 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 1,
            title: Text('Contact'),
            content: contactContent()),
        Step(
            state: currentStep > 2 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 2,
            title: Text('Nid'),
            content: nidContent(context)),
        Step(
            isActive: currentStep >= 3,
            title: Text('Password'),
            content: passwordContent()),
      ];

  Widget accountContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          child: TextField(
            controller: firstNameController,
            maxLines: 1,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              labelText: "First Name",
            ),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Container(
          alignment: Alignment.center,
          child: TextField(
            controller: lastNameController,
            maxLines: 1,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              labelText: "Last Name",
            ),
          ),
        ),
      ],
    );
  }

  Widget contactContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          child: TextField(
            controller: phoneController,
            maxLines: 1,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: "Phone Number",
            ),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Container(
          alignment: Alignment.center,
          child: TextField(
            controller: emailController,
            maxLines: 1,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: "Email Address",
            ),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Container(
          alignment: Alignment.center,
          child: TextField(
            controller: addressController,
            maxLines: 1,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Address",
            ),
          ),
        ),
      ],
    );
  }

  Widget nidContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: (){
            galleryImage();
          },
          child: Container(
            height: 80,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange,width: 1)
            ),
            alignment: Alignment.center,
            child: Center(
              child: _image==null?Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Choose your 1st part of Nid.',style: TextStyle(color: Colors.grey,)),
                Icon(Icons.add_photo_alternate_outlined,color: Colors.grey,)
              ],
            ):Container(
                  height: 80,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(_image!)),)
                    )
                  )
              )
            ),
        SizedBox(
          height: 16,
        ),
        InkWell(
          onTap: (){
            galleryImage2();
          },
          child: Container(
            height: 80,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange,width: 1)
            ),
            alignment: Alignment.center,
            child:  Center(
                child: _image2==null?Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Choose your 2nd part of Nid.',style: TextStyle(color: Colors.grey,)),
                    Icon(Icons.add_photo_alternate_outlined,color: Colors.grey,)
                  ],
                ):Container(
                    height: 80,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(_image2!)),)
                )
            )
          ),
        ),
      ],
    );
  }

  Widget passwordContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          child: TextField(
            controller: passController,
            maxLines: 1,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Password",
                suffixIcon: IconButton(onPressed: (){},icon: Icon(Icons.visibility_off),)
            ),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Container(
          alignment: Alignment.center,
          child: TextField(
            controller: confirmPassController,
            maxLines: 1,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Confirm Password",
              suffixIcon: IconButton(onPressed: (){},icon: Icon(Icons.visibility_off),)
            ),
          ),
        ),
      ],
    );
  }
}
