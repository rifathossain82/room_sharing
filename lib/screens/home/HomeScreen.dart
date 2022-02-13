import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:room_sharing/constraints/colors.dart';
import 'package:room_sharing/constraints/strings.dart';
import 'package:room_sharing/screens/home/DetailsScreen.dart';
import 'package:room_sharing/services/post.dart';
import 'package:room_sharing/widgets/appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/call_email.dart';
import '../../widgets/navigationDrawer/navigationDrawer.dart';

class HomeScreen extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  HomeScreen({Key? key}) : super(key: key);

  static const String routeName = '/Home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CollectionReference post = FirebaseFirestore.instance.collection('post');
  TextEditingController searchController = TextEditingController();
  late SharedPreferences sharedPreferences;
  String email = '';
  List<Post> post_list = [];
  String searchString = '';

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
        title: Text(app_name),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: MyAppBar(),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
            child: TextField(
              controller: searchController,
              //onSubmitted: searchLocation,
              onChanged: (value) {
                setState(() {
                  searchString = value.toLowerCase().trim();
                });
              },
              decoration: InputDecoration(
                  hintText: 'Uttara, Dhaka',
                  prefixIcon: Icon(Icons.search),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0))),
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: (searchString == null || searchString.trim() == "")
              ? FirebaseFirestore.instance.collection('post').snapshots()
              : FirebaseFirestore.instance
                  .collection('post')
                  .where('searchIndex', arrayContains: searchString)
                  .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text('Loading...');
              default:
                post_list = [];
                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot data) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildPost(
                          Post(
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
                  builder: (context) => DetailsScreen(post: post)));
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
                width: size.width,
                height: size.height * 0.3,
                fit: BoxFit.cover,
                imageUrl: post.img1,
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
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      createCall(post.email);
                    },
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [color2, color1]),
                          borderRadius: BorderRadius.circular(4)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.phone,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'CALL',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  InkWell(
                    onTap: () {
                      createEmail(post.email);
                    },
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [color1, color2]),
                          borderRadius: BorderRadius.circular(4)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.phone,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'EMAIL',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
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
