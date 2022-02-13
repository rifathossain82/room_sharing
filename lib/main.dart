import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:room_sharing/constraints/strings.dart';
import 'package:room_sharing/screens/home/HomeScreen.dart';
import 'package:room_sharing/screens/myPost/MyPostsScreen.dart';
import 'package:room_sharing/screens/createPostScreen.dart';
import 'package:room_sharing/screens/login.dart';
import 'package:room_sharing/services/pageRoute.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late SharedPreferences sharedPreferences;
  String email = '';
  String password = '';

  @override
  void initState() {
    super.initState();
    getEmail();
  }

  void getEmail() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      email = sharedPreferences.getString('email')!;
      password = sharedPreferences.getString('pass')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        title: app_name,
        debugShowCheckedModeBanner: false,
        home: email.isEmpty?LoginScreen():HomeScreen(),
        theme: ThemeData(primarySwatch: Colors.purple,primaryColor: Colors.purple),
        routes: {
          PageRoutes.home:(context)=> HomeScreen(),
          PageRoutes.createPost:(context)=> CreatePostScreen(),
          PageRoutes.myPost:(context)=> MyPostsScreen(),
        },
      ),
    );

  }
}
