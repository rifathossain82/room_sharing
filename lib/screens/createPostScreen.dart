import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:room_sharing/constraints/colors.dart';
import 'package:room_sharing/constraints/strings.dart';
import 'package:room_sharing/services/firebaseApi.dart';
import 'package:room_sharing/services/showMessage.dart';
import 'package:room_sharing/widgets/appbar.dart';
import 'package:room_sharing/widgets/myDropDown.dart';
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

  var selectedDivision=divisionList[0];
  var selectedDistrict;
  var selectedUpazila;

  List<String> districtList=dhakaDistrictList;
  List<String> upazilaList=BargunaUpazilaList;

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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
    desController.dispose();
    locationController.dispose();
    priceController.dispose();
    foodPriceController.dispose();
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
            }
            else {
              if(currentStep==0){
                if(formKey1.currentState!.validate()){
                  setState(() {
                    currentStep += 1;
                  });
                }
              }
              else if(currentStep==1){
                if(selectedDivision.toString().contains('Select Division')){
                  showMessage('Please Select Division');
                }
                else if(selectedDistrict.toString().contains('Select District')){
                  showMessage('Please Select District');
                }
                else if(selectedUpazila.toString().contains('Select Upazila')){
                  showMessage('Please Select Upazila');
                }
                else{
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

          ///division dropdown here
          Row(
            children: [
              Text('Division', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
              Spacer(),
              divisionDropDown(),
            ],
          ),

          ///district dropdown here
          selectedDistrict=='' || selectedDistrict==null || selectedDivision==divisionList[0]?
          Center()
          :
          Row(
            children: [
              Text('District', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
              Spacer(),
              districtDropDown(),
            ],
          ),

          ///upazila dropdown here
          selectedDistrict=='' || selectedDistrict==null || selectedDistrict==districtList[0]?
          Center()
              :
          Row(
            children: [
              Text('Upazila', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
              Spacer(),
              upazilaDropDown(),
            ],
          ),

          SizedBox(
            height: 8,
          ),
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
                  labelText: "Home Address",
                  hintText: 'House No. 53, Road No. 5, Uttara'),
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
          selectedRadio == 1?
          Container(
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
              :
          Center(),
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

  Widget divisionDropDown(){
    return myDropDown(divisionList, selectedDivision, 'Select Division', (val){
      districtList.clear();
      setState(() {
        selectedDivision=val;
      });
      changeDistrictList();

    });
  }

  Widget districtDropDown(){
    return myDropDown(districtList, selectedDistrict, 'Select District', (val){
      upazilaList.clear();
      setState(() {
        selectedDistrict=val;
      });
      changeUpazilaList();
    });
  }

  Widget upazilaDropDown(){
    return myDropDown(upazilaList, selectedUpazila, 'Select Upazila', (val){
      setState(() {
        selectedUpazila=val;
      });
    });
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
          'division': selectedDivision,
          'district': selectedDistrict,
          'upazila': selectedUpazila,
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


  void changeDistrictList(){
    if(selectedDivision==divisionList[1]){
      districtList.add('Select District');
      districtList.add('Dhaka');
      districtList.add('Faridpur');
      districtList.add('Gazipur');
      districtList.add('Gopalganj');
      districtList.add('Kishoreganj');
      districtList.add('Madaripur');
      districtList.add('Manikganj');
      districtList.add('Munshiganj');
      districtList.add('Narayanganj');
      districtList.add('Narshingdi');
      districtList.add('Rajbari');
      districtList.add('Shariatpur');
      districtList.add('Tangail');
    }
    else if(selectedDivision==divisionList[2]){
      districtList.addAll(chittagongDistrictList);
    }
    else if(selectedDivision==divisionList[3]){
      districtList.addAll(khulnaDistrictList);
    }
    else if(selectedDivision==divisionList[4]){
      districtList.addAll(barishalDistrictList);
    }
    else if(selectedDivision==divisionList[5]){
      districtList.addAll(mymensinghDistrictList);
    }
    else if(selectedDivision==divisionList[6]){
      districtList.addAll(rajshahiDistrictList);
    }
    else if(selectedDivision==divisionList[7]){
      districtList.addAll(rangpurDistrictList);
    }
    else if(selectedDivision==divisionList[8]){
      districtList.addAll(sylhetDistrictList);
    }
    else{
      districtList.addAll(sylhetDistrictList);
    }
    setState(() {
      selectedDistrict=districtList[0];
    });
    print(districtList);
  }

  void changeUpazilaList(){
    switch(selectedDistrict){
      case 'Barguna':
        upazilaList.addAll(BargunaUpazilaList);
        break;
      case 'Barishal':
        upazilaList.addAll(BarisalUpazilaList);
        break;
      case 'Bhola':
        upazilaList.addAll(BholaUpazilaList);
        break;
      case 'Jhalokathi':
        upazilaList.addAll(JhalokathiUpazilaList);
        break;
      case 'Patuakhali':
        upazilaList.addAll(PatuakhaliUpazilaList);
        break;
      case 'Pirojpur':
        upazilaList.addAll(PirojpurUpazilaList);
        break;
      case 'B.baria':
        upazilaList.addAll(B_bariaUpazilaList);
        break;
      case 'Bandarban':
        upazilaList.addAll(BandarbanUpazilaList);
        break;
      case 'Chandpur':
        upazilaList.addAll(ChandpurUpazilaList);
        break;
      case 'Chattogram':
        upazilaList.addAll(ChattogramUpazilaList);
        break;
      case 'Cox\'s bazar':
        upazilaList.addAll(Cox_bazarUpazilaList);
        break;
      case 'Cumilla':
        upazilaList.addAll(CumillaUpazilaList);
        break;
      case 'Feni':
        upazilaList.addAll(FeniUpazilaList);
        break;
      case 'Khagrachari':
        upazilaList.addAll(KhagrachariUpazilaList);
        break;
      case 'Laxmipur':
        upazilaList.addAll(LaxmipurUpazilaList);
        break;
      case 'Noakhali':
        upazilaList.addAll(NoakhaliUpazilaList);
        break;
      case 'Rangamati':
        upazilaList.addAll(RangamatiUpazilaList);
        break;
      case 'Dhaka':
        upazilaList.addAll(DhakaUpazilaList);
        break;
      case 'Faridpur':
        upazilaList.addAll(FaridpurUpazilaList);
        break;
      case 'Gazipur':
        upazilaList.addAll(GazipurUpazilaList);
        break;
      case 'Gopalganj':
        upazilaList.addAll(GopalganjUpazilaList);
        break;
      case 'Kishoreganj':
        upazilaList.addAll(KishoreganjUpazilaList);
        break;
      case 'Madaripur':
        upazilaList.addAll(MadaripurUpazilaList);
        break;
      case 'Manikganj':
        upazilaList.addAll(ManikganjUpazilaList);
        break;
      case 'Munshiganj':
        upazilaList.addAll(MunshiganjUpazilaList);
        break;
      case 'Narayanganj':
        upazilaList.addAll(NarayanganjUpazilaList);
        break;
      case 'Narshingdi':
        upazilaList.addAll(NarshingdiUpazilaList);
        break;
      case 'Rajbari':
        upazilaList.addAll(RajbariUpazilaList);
        break;
      case 'Shariatpur':
        upazilaList.addAll(ShariatpurUpazilaList);
        break;
      case 'Tangail':
        upazilaList.addAll(TangailUpazilaList);
        break;
      case 'Bagerhat':
        upazilaList.addAll(BagerhatUpazilaList);
        break;
      case 'Chuadanga':
        upazilaList.addAll(ChuadangaUpazilaList);
        break;
      case 'Jashore':
        upazilaList.addAll(JashoreUpazilaList);
        break;
      case 'Jhenaidah':
        upazilaList.addAll(JhenaidahUpazilaList);
        break;
      case 'Khulna':
        upazilaList.addAll(KhulnaUpazilaList);
        break;
      case 'Kushtia':
        upazilaList.addAll(KushtiaUpazilaList);
        break;
      case 'Magura':
        upazilaList.addAll(MaguraUpazilaList);
        break;
      case 'Meherpur':
        upazilaList.addAll(MeherpurUpazilaList);
        break;
      case 'Narail':
        upazilaList.addAll(NarailUpazilaList);
        break;
      case 'Satkhira':
        upazilaList.addAll(SatkhiraUpazilaList);
        break;
      case 'Jamalpur':
        upazilaList.addAll(JamalpurUpazilaList);
        break;
      case 'Mymensingh':
        upazilaList.addAll(MymensinghUpazilaList);
        break;
      case 'Netrokona':
        upazilaList.addAll(NetrokonaUpazilaList);
        break;
      case 'Sherpur':
        upazilaList.addAll(SherpurUpazilaList);
        break;
      case 'Bogura':
        upazilaList.addAll(BoguraUpazilaList);
        break;
      case 'C. nawabganj':
        upazilaList.addAll(CapainawabganjUpazilaList);
        break;
      case 'Joypurhat':
        upazilaList.addAll(JoypurhatUpazilaList);
        break;
      case 'Naogaon':
        upazilaList.addAll(NaogaonUpazilaList);
        break;
      case 'Natore':
        upazilaList.addAll(NatoreUpazilaList);
        break;
      case 'Pabna':
        upazilaList.addAll(PabnaUpazilaList);
        break;
      case 'Rajshahi':
        upazilaList.addAll(RajshahiUpazilaList);
        break;
      case 'Sirajganj':
        upazilaList.addAll(SirajganjUpazilaList);
        break;
      case 'Dinajpur':
        upazilaList.addAll(DinajpurUpazilaList);
        break;
      case 'Gaibandha':
        upazilaList.addAll(GaibandhaUpazilaList);
        break;
      case 'Kurigram':
        upazilaList.addAll(KurigramUpazilaList);
        break;
      case 'Lalmonirhat':
        upazilaList.addAll(LalmonirhatUpazilaList);
        break;
      case 'Nilphamari':
        upazilaList.addAll(NilphamariUpazilaList);
        break;
      case 'Panchagarh':
        upazilaList.addAll(PanchagarhUpazilaList);
        break;
      case 'Rangpur':
        upazilaList.addAll(RangpurUpazilaList);
        break;
      case 'Thakurgaon':
        upazilaList.addAll(ThakurgaonUpazilaList);
        break;
      case 'Habiganj':
        upazilaList.addAll(HabiganjUpazilaList);
        break;
      case 'Moulvibazar':
        upazilaList.addAll(MoulvibazarUpazilaList);
        break;
      case 'Sunamganj':
        upazilaList.addAll(SunamganjUpazilaList);
        break;
      case 'Sylhet':
        upazilaList.addAll(SylhetUpazilaList);
        break;
      default:
        break;
    }
    setState(() {
      selectedUpazila=upazilaList[0];
    });
    print(upazilaList);
  }
}
