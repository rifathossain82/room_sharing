import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:room_sharing/model/post.dart';
import '../../constraints/colors.dart';
import '../../services/firebaseApi.dart';
import '../../widgets/appbar.dart';

class EditMyPost extends StatefulWidget {
  Post post;
  var id;

  EditMyPost({Key? key, required this.post, required this.id})
      : super(key: key);

  @override
  _EditMyPostState createState() => _EditMyPostState();
}

var activeIndex = 0;
CarouselController controller = CarouselController();

var authorName = '';
var authorImg = '';

class _EditMyPostState extends State<EditMyPost> {
  TextEditingController titleController = TextEditingController();
  TextEditingController desController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController foodPriceController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  int selectedRadio = 0;

  final ImagePicker picker = ImagePicker();
  List<String> imageFileList = [];
  List<XFile> local_imageFileList = [];

  String img0='';
  String img1='';
  String img2='';
  String img3='';
  String img4='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findAuthor();
    loadSomeData();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Post'),
        elevation: 0,
        flexibleSpace: MyAppBar(),
        actions: [
          IconButton(onPressed: () {
            updatePost(context);
            Navigator.pop(context);
          },
              icon: Icon(Icons.check),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              //section title and des
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 1, child: Text('Title: ')),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: titleController,
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: widget.post.title,
                            border: OutlineInputBorder()),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 1, child: Text('Description: ')),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: desController,
                        maxLines: 5,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: widget.post.des,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 30,
              ),

              //section location, price and food
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 1, child: Text('Location: ')),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: locationController,
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: widget.post.location,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 1, child: Text('Price: ')),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      alignment: Alignment.center,
                      child: TextFormField(
                        validator: (value) {
                          if (int.parse(value!) < 0) {
                            return 'Price can not be negative!!';
                          } else {
                            return null;
                          }
                        },
                        controller: priceController,
                        maxLines: 1,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: widget.post.price,
                          prefix: Text('TK: '),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(flex: 1, child: Text('Food: ')),
                  Expanded(
                    flex: 2,
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
                    flex: 2,
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
                  ?
              Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(flex: 1, child: Text('Food Price: ')),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            alignment: Alignment.center,
                            child: TextFormField(
                              validator: (value) {
                                if (int.parse(value!) < 0) {
                                  return 'Food Price can not be negative!!';
                                } else {
                                  return null;
                                }
                              },
                              controller: foodPriceController,
                              maxLines: 1,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: widget.post.food_price,
                                prefixText: 'TK: ',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  :
              Center(),


              SizedBox(height: 30,),

              //image section
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        selectImage();
                      },
                      child: Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              gradient:
                                  LinearGradient(colors: [color2, color1])),
                          padding: const EdgeInsets.all(0),
                          child: Text(
                            'Change Image',
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
                  Text('( Maximum 5 )'),
                ],
              ),
              SizedBox(height: 16,),
              SizedBox(
                height: 220,
                child: GridView.builder(
                    itemCount:
                        imageFileList.length <= 5 ? imageFileList.length : 5,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10),
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        imageUrl: imageFileList[index],
                        height: 100,
                        fit: BoxFit.cover,
                      );
                    }),
              ),

              SizedBox(height: 30,),
            ],
          ),
        ),
      ),
    );
  }

  void updatePost(BuildContext context)async{
    if(titleController.text.isNotEmpty){
      widget.id.reference.update(
          {
            'title': titleController.text.toString().trim(),
          }).whenComplete((){
        // print('update');
      });
    }
    if(desController.text.isNotEmpty){
      widget.id.reference.update(
          {
            'description': desController.text.toString().trim(),
          }).whenComplete((){
        // print('update');
      });
    }
    if(locationController.text.isNotEmpty){
      widget.id.reference.update(
          {
            'location': locationController.text.toString().trim(),
          }).whenComplete((){
        // print('update');
      });
    }
    if(priceController.text.isNotEmpty){
      widget.id.reference.update(
          {
            'price': priceController.text.toString().trim(),
          }).whenComplete((){
        // print('update');
      });
    }
    widget.id.reference.update(
        {
          'food': selectedRadio==1?"Yes":"No",
        }).whenComplete((){
      // print('update');
    });

    if(foodPriceController.text.isNotEmpty){
      widget.id.reference.update(
          {
            'food_price': foodPriceController.text.toString().trim(),
          }).whenComplete((){
        // print('update');
      });
    }

    if(img0.isNotEmpty){
      widget.id.reference.update(
          {
            'img1': img0,
            'img2': img1,
            'img3': img2,
            'img4': img3,
            'img5': img4,
          }).whenComplete((){
        // print('update');
      });
    }
  }

  void selectImage() async {
    setState(() {
      local_imageFileList=[];
    });
    final List<XFile>? selectedImage = await picker.pickMultiImage();
    if (selectedImage!.isNotEmpty) {
      local_imageFileList.addAll(selectedImage);
    }

    print(local_imageFileList.length);
    setState(() {});
    uploadImages();
  }

  void uploadImages()async{
    imageFileList=[];

    File? file;
    UploadTask? task0;
    UploadTask? task1;
    UploadTask? task2;
    UploadTask? task3;
    UploadTask? task4;

    for(int i=0;i<local_imageFileList.length;i++){
      final filename=basename(File(local_imageFileList[i].path).path);
      final destination="files/post/${widget.post.title}/$filename";
      file=await saveImagePermanently(local_imageFileList[i].path);

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

    for(int i=0;  i<local_imageFileList.length;i++){
      if(i==0){
        final snapshot=await task0!.whenComplete((){
          setState(() {});
        });
        img0=await snapshot.ref.getDownloadURL();
        imageFileList.add(img0);
      }
      if(i==1){
        final snapshot=await task1!.whenComplete((){
          setState(() {});
        });
        img1=await snapshot.ref.getDownloadURL();
        imageFileList.add(img1);
      }
      if(i==2){
        final snapshot=await task2!.whenComplete((){
          setState(() {});
        });
        img2=await snapshot.ref.getDownloadURL();
        imageFileList.add(img2);
      }
      if(i==3){
        final snapshot=await task3!.whenComplete((){
          setState(() {});
        });
        img3=await snapshot.ref.getDownloadURL();
        imageFileList.add(img3);
      }
      if(i==4){
        final snapshot=await task4!.whenComplete((){
          setState(() {});
        });
        img4=await snapshot.ref.getDownloadURL();
        imageFileList.add(img4);
      }
    }
    setState(() {

    });
  }

  Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }


  void loadSomeData(){
    if (widget.post.food_status.contains('Yes')) {
      setState(() {
        selectedRadio = 1;
      });
    } else {
      setState(() {
        selectedRadio = 2;
      });
    }
    if (widget.post.img1.isNotEmpty) {
      imageFileList.add(widget.post.img1);
    }
    if (widget.post.img2.isNotEmpty) {
      imageFileList.add(widget.post.img2);
    }
    if (widget.post.img3.isNotEmpty) {
      imageFileList.add(widget.post.img3);
    }
    if (widget.post.img4.isNotEmpty) {
      imageFileList.add(widget.post.img4);
    }
    if (widget.post.img5.isNotEmpty) {
      imageFileList.add(widget.post.img5);
    }
  }
  void findAuthor() {
    FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: widget.post.email)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      var f_name = querySnapshot.docs[0]['firstName'];
      var l_name = querySnapshot.docs[0]['lastName'];
      authorImg = querySnapshot.docs[0]['profilePic'];
      setState(() {
        authorName = f_name + " " + l_name;
      });
    });
  }
}
