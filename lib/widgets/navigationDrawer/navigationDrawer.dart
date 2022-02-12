import 'package:flutter/material.dart';

import '../../services/pageRoute.dart';
import 'navigationDrawerIte,.dart';
import 'navigationHeader.dart';


class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

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
          NavigationDrawerItem(Icons.share, 'Share', (){}),
          NavigationDrawerItem(Icons.feedback, 'Complain', () {}),
          NavigationDrawerItem(Icons.info, 'About', () {}),
          Divider(),
          NavigationDrawerItem(Icons.logout, 'Logout', () {}),
        ],
      ),
    );
  }
}
