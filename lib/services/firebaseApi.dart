import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseApi{

  //to upload file
  static UploadTask? uploadTask(String destination, File file){
    try{
      final ref=FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    }
    catch(e){
      return null;
    }
  }


  //to upload bytes data
  //just ignore this
  static UploadTask? uploadBytes(String destination, Uint8List data){
    try{
      final ref=FirebaseStorage.instance.ref(destination);
      return ref.putData(data);
    }
    catch(e){
      return null;
    }
  }
}