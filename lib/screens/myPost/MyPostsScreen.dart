import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:room_sharing/screens/myPost/MyPostDetailsScreen.dart';
import 'package:room_sharing/widgets/appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constraints/colors.dart';
import '../../services/call_email.dart';
import '../../model/post.dart';
import '../../widgets/navigationDrawer/navigationDrawer.dart';
import '../home/DetailsScreen.dart';

class MyPostsScreen extends StatefulWidget {
  const MyPostsScreen({Key? key}) : super(key: key);

  static const String routeName='/MyPost';

  @override
  State<MyPostsScreen> createState() => _MyPostsScreenState();
}

class _MyPostsScreenState extends State<MyPostsScreen> {

  CollectionReference post = FirebaseFirestore.instance.collection('post');
  TextEditingController searchController = TextEditingController();
  late SharedPreferences sharedPreferences;
  String email = '';
  List<Post> post_list = [];
  var post_id;

  @override
  void initState() {
    super.initState();
    getEmail();
  }

  void getEmail() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      email = sharedPreferences.getString('email')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Posts'),
        elevation: 0,
        flexibleSpace: MyAppBar(),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('post').where('email',isEqualTo: email).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                post_list = [];
                return snapshot.data!.docs.isEmpty?
                Center(child: Text('No Posts Yet!',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400),),)
                    :
                ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot data) {
                    post_id=data;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildPost(
                          Post(
                              data.id,
                              data['email'],
                              data['date'],
                              data['time'],
                              data['title'],
                              data['description'],
                              data['location'],
                              data['price'],
                              data['food'],
                              data['food_price'],
                              data['img1'],
                              data['img2'],
                              data['img3'],
                              data['img4'],
                              data['img5']),
                          context),
                    );
                  }).toList(),
                );
            }
          }),
      drawer: NavigationDrawer(),
    );
  }

  Widget buildPost(Post post, BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Card(
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyPostDetailsScreen(post: post,id: post_id,)));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: post.img1,
                width: size.width,
                height: size.height * 0.3,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.title,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    RichText(
                        text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(text: 'Per Day: '),
                              TextSpan(text: post.price),
                              TextSpan(text: ' Tk'),
                            ])),
                    SizedBox(
                      height: 3,
                    ),
                    Text(post.location),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
