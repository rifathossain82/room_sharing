import 'package:flutter/material.dart';

import '../widgets/navigationDrawer/navigationDrawer.dart';

class MyPostsScreen extends StatelessWidget {
  const MyPostsScreen({Key? key}) : super(key: key);

  static const String routeName='/MyPost';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact'),
      ),
      body: Center(
        child: Text('This is Contact Page'),
      ),
      drawer:NavigationDrawer(),
    );
  }
}
