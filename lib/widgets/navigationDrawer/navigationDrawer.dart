import 'package:flutter/material.dart';
import 'package:room_sharing/screens/aboutScreen.dart';
import 'package:room_sharing/screens/login.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/pageRoute.dart';
import 'navigationDrawerIte,.dart';
import 'navigationHeader.dart';


class NavigationDrawer extends StatefulWidget {
  NavigationDrawer({Key? key}) : super(key: key);

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {

  late SharedPreferences sharedPreferences;
  String email = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  void getUserData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      email = sharedPreferences.getString('email')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          NavigationDrawerHeader(),
          // ignore: prefer_const_constructors
          SizedBox(height: 15,),
          NavigationDrawerItem(Icons.home, 'Home', ()=>Navigator.pushReplacementNamed(context, PageRoutes.home)),
          NavigationDrawerItem(Icons.post_add, 'Create a Post', ()=>Navigator.pushReplacementNamed(context, PageRoutes.createPost)),
          NavigationDrawerItem(Icons.featured_play_list, 'My Post', ()=>Navigator.pushReplacementNamed(context, PageRoutes.myPost)),
          Divider(),
          email=='rh@gmail.com'?Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text('Admin Panel',style: TextStyle(fontSize: 16,color: Colors.black54),),
              ),
              NavigationDrawerItem(Icons.supervised_user_circle_rounded, 'Users', ()=>Navigator.pushReplacementNamed(context, PageRoutes.users)),
              Divider(),
            ],
          ):Center(),
          NavigationDrawerItem(Icons.share, 'Share', (){
            Share.share('https://play.google.com/store/apps/details?id=com.example.room_sharing',subject: 'Share this app with your friends.');
          }),
          NavigationDrawerItem(Icons.report_problem_rounded, 'Report issues', () {  launch(emailLaunchUri.toString());}),
          NavigationDrawerItem(Icons.info, 'About Room Sharing', () =>Navigator.push(context, MaterialPageRoute(builder: (context)=>AboutScreen()))),
          Divider(),
          NavigationDrawerItem(Icons.logout, 'Logout', () {
            resetEmail();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
          }),
        ],
      ),
    );
  }

  resetEmail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('email', '');
    sharedPreferences.setString('pass', '');
  }

  //to send gmail
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'officialrifat82@gmail.com',
    query: encodeQueryParameters(<String, String>{
      'subject': 'Face a issue in Room Sharing'
    }),
  );
}


//to encode email subjects and body
String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}
