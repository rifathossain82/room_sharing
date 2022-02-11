import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:room_sharing/constraints/strings.dart';
import 'package:room_sharing/screens/HomeScreen.dart';
import 'package:room_sharing/screens/MyPostsScreen.dart';
import 'package:room_sharing/screens/createPostScreen.dart';
import 'package:room_sharing/screens/login.dart';
import 'package:room_sharing/services/pageRoute.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: app_name,
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      theme: ThemeData(primarySwatch: Colors.purple,primaryColor: Colors.purple),
      routes: {
        PageRoutes.home:(context)=> HomeScreen(),
        PageRoutes.createPost:(context)=> CreatePostScreen(),
        PageRoutes.myPost:(context)=> MyPostsScreen(),
      },
    );
  }
}
