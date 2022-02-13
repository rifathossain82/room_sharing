import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:room_sharing/constraints/strings.dart';
import 'package:room_sharing/screens/home/HomeScreen.dart';
import 'package:room_sharing/screens/myPost/MyPostsScreen.dart';
import 'package:room_sharing/screens/createPostScreen.dart';
import 'package:room_sharing/screens/splashScreen.dart';
import 'package:room_sharing/screens/users/usersScreen.dart';
import 'package:room_sharing/services/pageRoute.dart';

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

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        title: app_name,
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        theme: ThemeData(primarySwatch: Colors.purple,primaryColor: Colors.purple),
        routes: {
          PageRoutes.home:(context)=> HomeScreen(),
          PageRoutes.createPost:(context)=> CreatePostScreen(),
          PageRoutes.myPost:(context)=> MyPostsScreen(),
          PageRoutes.users:(context)=> UsersScreen(),
        },
      ),
    );

  }
}

//room sharing app start from this main.dart page
//overlaySupport.global use to show message when I sent email
//pageRoutes for navigation drawer items, when I click any item of navigation drawer then I call the item page
