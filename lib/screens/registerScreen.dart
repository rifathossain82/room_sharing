import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:room_sharing/constraints/colors.dart';
import 'package:room_sharing/screens/home/HomeScreen.dart';
import 'package:room_sharing/services/showMessage.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  TextEditingController nidNumberController = TextEditingController();

  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();
  final formKeyNid = GlobalKey<FormState>();

  int currentStep = 0;
  bool isCompleted = false;
  bool obscureValue1=true;
  bool obscureValue2=true;

  File? _profileImg;
  File? _image;
  File? _image2;

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
      });
    } on PlatformException catch (e) {
      print('Faild to pick image: $e');
    }
  }

  Future cameraImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;

      //final imageTemporary=File(image.path);   //to set image temporary
      final imagePermanent = await saveImagePermanently(
          image.path); //to set image permanent in local storage
      setState(() {
        this._image = imagePermanent;
        final path = image.path;
        file1 = File(path);
      });
    } on PlatformException catch (e) {
      print('Faild to pick image: $e');
    }
  }

  Future cameraImage2() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;

      //final imageTemporary=File(image.path);   //to set image temporary
      final imagePermanent = await saveImagePermanently(
          image.path); //to set image permanent in local storage
      setState(() {
        this._image2 = imagePermanent;
        final path = image.path;
        file2 = File(path);
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

  //for firebase firestore
  CollectionReference user = FirebaseFirestore.instance.collection('user');
  UploadTask? profileTask;
  UploadTask? task;
  UploadTask? task2;
  File? profileFile;
  File? file1;
  File? file2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
        child: Theme(
          data: Theme.of(context)
              .copyWith(colorScheme: ColorScheme.light(primary: color1)),
          child: Stepper(
            //type: StepperType.horizontal,
            steps: getSteps(context),
            currentStep: currentStep,
            onStepContinue: () {
              final isLastStep = currentStep == getSteps(context).length - 1;

              if (isLastStep) {
                if(formKey3.currentState!.validate()){
                  setState(() {
                    isCompleted = true;
                  });
                  checkPhone(context); //to add unique user in firebase fireStore
                }
              } else {
                if(currentStep==0){
                  if(_profileImg==null){
                    showMessage('Select Your Profile Picture.');
                  }
                  else{
                    if(formKey.currentState!.validate()){
                      setState(() {
                        currentStep += 1;
                      });
                    }
                  }
                }
                else if(currentStep==1){
                  if(formKey2.currentState!.validate()){
                    setState(() {
                      currentStep += 1;
                    });
                  }
                }
                else if(currentStep==2){
                  if(formKeyNid.currentState!.validate()){
                    if(_image==null){
                      showMessage('1st part of Nid is Empty!!');
                    }
                    else if(_image2==null){
                      showMessage('2nd part of Nid is Empty!!');
                    }
                    else{
                      setState(() {
                        currentStep += 1;
                      });
                    }
                  }
                }
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
                                  gradient: LinearGradient(colors: [
                                    color2,
                                    color1
                                  ])),
                              padding: const EdgeInsets.all(0),
                              child: const Text(
                                'Back',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )),
                        ),
                      ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: controlDetails.onStepContinue,
                        child: Container(
                            alignment: Alignment.center,
                            height: 50.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                gradient: LinearGradient(colors: [
                                  color2,
                                  color1
                                ])),
                            padding: const EdgeInsets.all(0),
                            child: Text(
                              isLastStep ? 'Continue' : 'Next',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
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

  //at first check phone, email and nid is it unique or not. if unique then add user in firebase fireStore
  void checkPhone(BuildContext context) async {
    FirebaseFirestore.instance
        .collection('user')
        .where('phone', isEqualTo: phoneController.text)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        checkEmail(context);
      } else {
        showMessage('Phone Number already exists!');
      }
    });
  }

  void checkEmail(BuildContext context) async {
    FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: emailController.text)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        checkNid(context);
      } else {
        showMessage('Email already exists!');
      }
    });
  }

  void checkNid(BuildContext context) async {
    FirebaseFirestore.instance
        .collection('user')
        .where('nidNumber', isEqualTo: nidNumberController.text)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        addUser(context);
      } else {
        showMessage('Nid Number already exists!');
      }
    });
  }

  void addUser(BuildContext context) async {
    try {
      saveEmail(emailController.text);
      final fileName0 = basename(profileFile!.path);
      final fileName1 = basename(file1!.path);
      final fileName2 = basename(file2!.path);
      final profiledestination = 'files/${emailController.text}/$fileName0';
      final destination = 'files/${emailController.text}/$fileName1';
      final destination2 = 'files/${emailController.text}/$fileName2';
      profileTask = FirebaseApi.uploadTask(profiledestination, _profileImg!);
      task = FirebaseApi.uploadTask(destination, _image!);
      task2 = FirebaseApi.uploadTask(destination2, _image2!);
      setState(() {});

      if (profileTask == null) {
        return;
      }
      else if (task == null) {
        return;
      }
      else if (task2 == null) {
      }
      else {
        final profileSnapshot = await profileTask!.whenComplete(() {
          setState(() {});
        });
        final snapshot = await task!.whenComplete(() {
          setState(() {});
        });
        final snapshot2 = await task2!.whenComplete(() {
          setState(() {});
        });
        final profilePic = await profileSnapshot.ref.getDownloadURL();
        final urlNid1 = await snapshot.ref.getDownloadURL();
        final urlNid2 = await snapshot2.ref.getDownloadURL();
        user.add({
          'profilePic': profilePic,
          'firstName': firstNameController.text,
          'lastName': lastNameController.text,
          'phone': phoneController.text,
          'email': emailController.text,
          'address': addressController.text,
          'nidNumber': nidNumberController.text,
          'nid1': urlNid1,
          'nid2': urlNid2,
          'password': passController.text,
        }).then((value){
          showMessage('Register Success!');
        }).onError((error, stackTrace){
          showMessage('Register Failed!');
        });

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    } catch (e) {
      showMessage('Failed!!');
    }
  }

  saveEmail(String email) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('email', email);
  }

  Widget buildUploadStatus(UploadTask task) {
    return StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          final snap = snapshot.data;
          final progress = snap!.bytesTransferred / snap.totalBytes;
          final percentage = (progress * 100).toStringAsFixed(2);

          return Text(
            '$percentage %',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          );
        });
  }

  List<Step> getSteps(BuildContext context) => [
        Step(
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 0,
            title: Text('Account'),
            content: accountContent(context)),
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

  Widget accountContent(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: (){
              pickProfileImage();
            },
            child: _profileImg==null?
            Container(
              height: MediaQuery.of(context).size.width/2,
              width: MediaQuery.of(context).size.width/2,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_rounded,size: 40,),
                  SizedBox(height: 8,),
                  Text('Add a profile photo')
                ],
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(width: 1,color: color1)
              ),
            ):
            Container(
              height: MediaQuery.of(context).size.width/2,
              width: MediaQuery.of(context).size.width/2,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(width: 1,color: color1),
                image: DecorationImage(
                    fit: BoxFit.cover, image: FileImage(_profileImg!),
                )
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            alignment: Alignment.center,
            child: TextFormField(
              validator: (value){
                if (value!.isEmpty) {
                  return 'First Name required!';
                }
                else {
                  return null;
                }
              },
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget contactContent() {
    return Form(
      key: formKey2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
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
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            alignment: Alignment.center,
            child: TextFormField(
              validator: (value){
                if (value!.isEmpty) {
                  return 'Address required!';
                }
                else {
                  return null;
                }
              },
              controller: addressController,
              maxLines: 1,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Address",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget nidContent(BuildContext context) {
    return Form(
      key: formKeyNid,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            child: TextFormField(
              validator: (value){
                if (value!.isEmpty) {
                  return 'Nid Number required!';
                }
                else if (!(value.length==13) && !(value.length==17)) {
                  return 'Incorrect Nid Number!';
                }
                else {
                  return null;
                }
              },
              controller: nidNumberController,
              maxLines: 1,
              maxLength: 17,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Nid Number",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 16,),
          InkWell(
              onTap: () {
                cameraImage();
              },
              child: Container(
                  height: 80,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: color1, width: 1)),
                  alignment: Alignment.center,
                  child: Center(
                      child: _image == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Choose your 1st part of Nid.',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    )),
                                Icon(
                                  Icons.add_photo_alternate_outlined,
                                  color: Colors.grey,
                                )
                              ],
                            )
                          : Container(
                              height: 80,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                    fit: BoxFit.cover, image: FileImage(_image!)),
                              ))))),
          SizedBox(
            height: 16,
          ),
          InkWell(
            onTap: () {
              cameraImage2();
            },
            child: Container(
                height: 80,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color1, width: 1)),
                alignment: Alignment.center,
                child: Center(
                    child: _image2 == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Choose your 2nd part of Nid.',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  )),
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                color: Colors.grey,
                              )
                            ],
                          )
                        : Container(
                            height: 80,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                  fit: BoxFit.cover, image: FileImage(_image2!)),
                            )))),
          ),
        ],
      ),
    );
  }

  Widget passwordContent() {
    return Form(
      key: formKey3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            child: TextFormField(
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
              controller: passController,
              maxLines: 1,
              obscureText: obscureValue1,
              decoration: InputDecoration(
                  labelText: "Password",
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscureValue1=!obscureValue1;
                      });
                    },
                      icon: Icon(obscureValue1?Icons.visibility_off:Icons.visibility),
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
                if (value!.isEmpty) {
                  return 'Confirm Password required!';
                }
                else if (value.length<6) {
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
                  labelText: "Confirm Password",
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscureValue2=!obscureValue2;
                      });
                    },
                      icon: Icon(obscureValue2?Icons.visibility_off:Icons.visibility),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
