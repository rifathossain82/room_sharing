import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:room_sharing/constraints/strings.dart';
import 'package:room_sharing/services/post.dart';

import '../widgets/navigationDrawer/navigationDrawer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  static const String routeName = '/Home';
  CollectionReference post =
  FirebaseFirestore.instance.collection('post');

  List<Post> post_list=[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(app_name),
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Image.asset(
              'assets/images/main.png',
              height: 30,
              width: 30,
            ),
          )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.only(left: 16,right: 16,top: 8,bottom: 16),
            child: TextField(
              decoration: InputDecoration(
                  hintText: 'Uttara, Dhaka',
                  prefixIcon: Icon(Icons.search),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.white, width: 0)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.white, width: 0))),
            ),
          ),
        ),
      ),
      body: StreamBuilder(
          stream: post.orderBy('date').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
                itemBuilder: (context,index){
                var data=snapshot.data!.docs![index];
                post_list.add(Post(data['date'], data['time'], data['title'], data['description'], data['location'], data['price'], data['food'], data['food_price'], data['img1'], data['img2'], data['img3'], data['img4'], data['img5']));
                 return buildPost(post_list[index], context);
                }
            );
          }),
      drawer: NavigationDrawer(),
    );
  }

  Widget buildPost(Post post, BuildContext context){
    final size=MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(post.img1,width: size.width,height: size.height*0.3,fit: BoxFit.cover,),
              Text(post.title),
              RichText(text: TextSpan(
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(text: 'Per Day: '),
                  TextSpan(text: post.price),
                  TextSpan(text: ' Tk'),
                ]
              )),
              Text(post.location),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(onPressed: (){},child: Text('CALL'),),
                  RaisedButton(onPressed: (){},child: Text('EMAIL'),),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }



}
