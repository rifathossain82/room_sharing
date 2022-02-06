import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:room_sharing/services/firebaseApi.dart';
import '../widgets/navigationDrawer/navigationDrawer.dart';

class CreatePostScreen extends StatefulWidget {
  CreatePostScreen({Key? key}) : super(key: key);

  static const String routeName = '/CreatePost';

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController desController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController foodPriceController = TextEditingController();

  int currentStep = 0;     //for stepper step
  bool isCompleted = false;     //to check stepper step is completed or none
  int selectedRadio = 0;      //for food status

  final ImagePicker picker = ImagePicker();
  List<XFile> imageFileList = [];                //we need maximum 5 photo

  //for firebase firestore
  CollectionReference post =
  FirebaseFirestore.instance.collection('post');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a new post'),
        elevation: 0,
      ),
      body: Theme(
        data: Theme.of(context)
            .copyWith(colorScheme: ColorScheme.light(primary: Colors.orange)),
        child: Stepper(
          elevation: 0,
          type: StepperType.horizontal,
          steps: getSteps(context),
          currentStep: currentStep,
          onStepContinue: () {
            final isLastStep = currentStep == getSteps(context).length - 1;
            if (isLastStep) {
              setState(() {
                isCompleted = true;
              });
              addUser(context);     //to add user in firebase firestore
            } else {
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
                              gradient: const LinearGradient(colors: [
                                Color.fromARGB(255, 255, 136, 34),
                                Color.fromARGB(255, 255, 177, 41)
                              ])),
                          padding: const EdgeInsets.all(0),
                          child: Text(
                            isLastStep ? 'Post' : 'Next',
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
      drawer: NavigationDrawer(),
    );
  }

  List<Step> getSteps(BuildContext context) => [
        Step(
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 0,
            title: Text(''),
            content: content1()),
        Step(
            state: currentStep > 1 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 1,
            title: Text(''),
            content: content2()),
        Step(
            isActive: currentStep >= 2,
            title: Text(''),
            content: content3(context)),
      ];

  Widget content1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          child: TextField(
            controller: titleController,
            maxLines: 1,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Title",
            ),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Container(
          alignment: Alignment.center,
          child: TextField(
            controller: desController,
            maxLines: 5,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Description",
            ),
          ),
        ),
      ],
    );
  }

  Widget content2() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          child: TextField(
            controller: locationController,
            maxLines: 1,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                labelText: "Location",
                hintText: 'Block C, Basundhara R-A, Dhaka'),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Container(
          alignment: Alignment.center,
          child: TextField(
            controller: priceController,
            maxLines: 1,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: "Price (Per Day)", prefix: Text('TK: ')),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Text('Food: '),
            Expanded(
              child: RadioListTile<int>(
                  value: 1,
                  groupValue: selectedRadio,
                  title: Text('Yes'),
                  onChanged: (value) {
                    setState(() {
                      selectedRadio = value!;
                    });
                  }),
            ),
            Expanded(
              child: RadioListTile<int>(
                  value: 2,
                  groupValue: selectedRadio,
                  title: Text('No'),
                  onChanged: (value) {
                    setState(() {
                      selectedRadio = value!;
                    });
                  }),
            ),
          ],
        ),
        SizedBox(
          height: 16,
        ),
        selectedRadio == 1
            ? Container(
                alignment: Alignment.center,
                child: TextField(
                  controller: foodPriceController,
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Food Price (Per Day)", prefix: Text('TK: ')),
                ),
              )
            : Center(),
      ],
    );
  }

  Widget content3(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextButton(
                onPressed: (){
                  selectImage();
                },
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
                      imageFileList.length>=5?'Change Image':'Upload Image',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    )),
              ),
            ),
            SizedBox(width: 8,),
            Text('( Maximum 5 )'),
          ],
        ),
        SizedBox(
          height: 16,
        ),
        SizedBox(
          height: 200,
          child: GridView.builder(
            itemCount: imageFileList.length<=5?imageFileList.length:5,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10
              ),
              itemBuilder: (context,index){
                return Image.file(File(imageFileList[index].path),height: 100,fit: BoxFit.cover,);
              }),
        )

      ],
    );
  }

  void selectImage() async {
    setState(() {
      imageFileList=[];
    });
    final List<XFile>? selectedImage = await picker.pickMultiImage();
    if (selectedImage!.isNotEmpty) {
      imageFileList.addAll(selectedImage);
    }

    print(imageFileList.length);
    setState(() {});
  }

  Future<File> saveImagePermanently(String imagePath)async{
    final directory=await getApplicationDocumentsDirectory();
    final name=basename(imagePath);
    final image=File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

  void addUser(BuildContext context)async{
    try{
      String food_status;
      if(selectedRadio==1){
        food_status="Yes";
      }
      else{
        food_status="No";
      }
      DateTime dateTime=DateTime.now();
      String date='${dateTime.day}-${dateTime.month}-${dateTime.year}';

      TimeOfDay timeOfDay=TimeOfDay.now();
      String time='${timeOfDay.hour}:${timeOfDay.minute} ${timeOfDay.period.name}';

      print(date);
      print(time);

      File? file;
      UploadTask? task0;
      UploadTask? task1;
      UploadTask? task2;
      UploadTask? task3;
      UploadTask? task4;

      String img0='';
      String img1='';
      String img2='';
      String img3='';
      String img4='';

      for(int i=0;i<imageFileList.length;i++){
        final filename=basename(File(imageFileList[i].path).path);
        final destination="files/post/${titleController.text}/$filename";
        file=await saveImagePermanently(imageFileList[i].path);

        //to upload image in firebase firestore
        if(i==0){
          task0=FirebaseApi.uploadTask(destination, file!)!;
        }
        if(i==1){
          task1=FirebaseApi.uploadTask(destination, file!)!;
        }
        if(i==2){
          task2=FirebaseApi.uploadTask(destination, file!)!;
        }
        if(i==3){
          task3=FirebaseApi.uploadTask(destination, file!)!;
        }
        if(i==4){
          task4=FirebaseApi.uploadTask(destination, file!)!;
        }


      }

      for(int i=0;  i<imageFileList.length;i++){
        if(i==0){
          final snapshot=await task0!.whenComplete((){
            setState(() {});
          });
          img0=await snapshot.ref.getDownloadURL();
        }
        if(i==1){
          final snapshot=await task1!.whenComplete((){
            setState(() {});
          });
          img1=await snapshot.ref.getDownloadURL();
        }
        if(i==2){
          final snapshot=await task2!.whenComplete((){
            setState(() {});
          });
          img2=await snapshot.ref.getDownloadURL();
        }
        if(i==3){
          final snapshot=await task3!.whenComplete((){
            setState(() {});
          });
          img3=await snapshot.ref.getDownloadURL();
        }
        if(i==4){
          final snapshot=await task4!.whenComplete((){
            setState(() {});
          });
          img4=await snapshot.ref.getDownloadURL();
        }
      }


      post.add({
        'date': date,
        'time': time,
        'title': titleController.text,
        'description': desController.text,
        'location': locationController.text,
        'price': priceController.text,
        'food': food_status,
        'food_price': foodPriceController.text,
        'img1': img0,
        'img2': img1,
        'img3': img2,
        'img4': img3,
        'img5': img4,
      }).then((value){
        print('Success');
      })
      .onError((error, stackTrace){
        print(error);
      });

    }
    catch(e){
      print('Error');
    }
  }
}
