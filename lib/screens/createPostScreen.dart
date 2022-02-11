import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:room_sharing/constraints/colors.dart';
import 'package:room_sharing/services/firebaseApi.dart';
import 'package:room_sharing/services/showMessage.dart';
import 'package:room_sharing/widgets/appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/navigationDrawer/navigationDrawer.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

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

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();

  int currentStep = 0;     //for stepper step
  bool isCompleted = false;     //to check stepper step is completed or none
  int selectedRadio = 0;      //for food status

  final ImagePicker picker = ImagePicker();
  List<XFile> imageFileList = [];                //we need maximum 5 photo

  //for firebase firestore
  CollectionReference post =
  FirebaseFirestore.instance.collection('post');

  late SharedPreferences sharedPreferences;
  String email='';

  @override
  void initState(){
    super.initState();
    getEmail();
  }

  void getEmail()async{
    sharedPreferences=await SharedPreferences.getInstance();
    setState(() {
      email=sharedPreferences.getString('email')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a new post'),
        elevation: 0,
        flexibleSpace: MyAppBar(),
      ),
      body: Theme(
        data: Theme.of(context)
            .copyWith(colorScheme: ColorScheme.light(primary: color1)),
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
              addPost(context);     //to add user in firebase firestore
            } else {
              if(currentStep==0){
                if(formKey1.currentState!.validate()){
                  setState(() {
                    currentStep += 1;
                  });
                }
              }
              else if(currentStep==1){
                if(formKey2.currentState!.validate()){
                  if(selectedRadio==0){
                    showMessage('Select any food option.');
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
    return Form(
      key: formKey1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            child: TextFormField(
              validator: (value){
                if (value!.isEmpty) {
                  return 'Title is Empty!';
                }
                else {
                  return null;
                }
              },
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
            child: TextFormField(
              validator: (value){
                if (value!.isEmpty) {
                  return 'Description is Empty!';
                }
                else {
                  return null;
                }
              },
              controller: desController,
              maxLines: 5,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Description",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget content2() {
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
                  return 'Location required!';
                }
                else {
                  return null;
                }
              },
              controller: locationController,
              maxLines: 1,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  labelText: "Location",
                  hintText: 'Uttara, Dhaka'),
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
                  return 'Price is Empty!';
                }
                else if (int.parse(value)<0) {
                  return 'Price can not be negative!!';
                }
                else {
                  return null;
                }
              },
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
                  child: TextFormField(
                    validator: (value){
                      if (value!.isEmpty) {
                        return 'Food Price is Empty!';
                      }
                      else if (int.parse(value)<0) {
                        return 'Food Price can not be negative!!';
                      }
                      else {
                        return null;
                      }
                    },
                    controller: foodPriceController,
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "Food Price (Per Day)", prefix: Text('TK: ')),
                  ),
                )
              : Center(),
        ],
      ),
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
                        gradient: LinearGradient(colors: [
                          color2,
                          color1
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

  void addPost(BuildContext context)async{
    try{
      if(imageFileList.isEmpty){
        showMessage('Select minimum 1 photo!!');
      }
      else{
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
            task0=FirebaseApi.uploadTask(destination, file)!;
          }
          if(i==1){
            task1=FirebaseApi.uploadTask(destination, file)!;
          }
          if(i==2){
            task2=FirebaseApi.uploadTask(destination, file)!;
          }
          if(i==3){
            task3=FirebaseApi.uploadTask(destination, file)!;
          }
          if(i==4){
            task4=FirebaseApi.uploadTask(destination, file)!;
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

        //to store array list of location
        List<String> splitList=locationController.text.split(' ');
        List<String> indexList=[];

        for(int i=0;i<splitList.length;i++){
          for(int y=1;y<=splitList[i].length;y++){
            indexList.add(splitList[i].substring(0,y).toLowerCase());
          }
        }

        print(indexList);


        post.add({
          'email': email,
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
          'searchIndex':indexList
        }).then((value){
          showMessage('Post Uploaded Successfully.');

          setState(() {
            titleController.clear();
            desController.clear();
            locationController.clear();
            priceController.clear();
            foodPriceController.clear();
            selectedRadio=0;
            img0='';
            img1='';
            img2='';
            img3='';
            img4='';
            currentStep=0;
            imageFileList=[];
          });
        })
            .onError((error, stackTrace){
          showMessage('Post Uploaded Failed.');
        });

      }
    }
    catch(e){
      showMessage('Failed!!');
    }
  }
}
