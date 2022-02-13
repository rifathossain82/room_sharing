import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:room_sharing/screens/users/UserDetails.dart';
import 'package:room_sharing/screens/users/userPosts.dart';

import '../../constraints/colors.dart';
import '../../widgets/appbar.dart';
import '../../widgets/navigationDrawer/navigationDrawer.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  static const String routeName = '/users';

  @override
  _UsersScreenState createState() => _UsersScreenState();
}



class _UsersScreenState extends State<UsersScreen> {

  TextEditingController searchController = TextEditingController();
  String searchString = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Users'),
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
                  searchString = value.trim();
                });
              },
              maxLines: 1,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: '188*****71',
                  prefixIcon: Icon(Icons.search),
                  prefixText: '+880 ',
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
              ? FirebaseFirestore.instance.collection('user').snapshots()
              : FirebaseFirestore.instance
              .collection('user')
              .where('phone', isEqualTo: searchString)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                //post_list = [];
                return snapshot.data!.docs.isEmpty?
                Center(child: Text('No Users Yet!',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400),),)
                    :
                ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot data) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Card(
                        child: ExpansionTile(
                          iconColor: Colors.white,
                          collapsedIconColor: Colors.white,
                          childrenPadding: EdgeInsets.all( 16),
                          expandedAlignment: Alignment.centerLeft,
                          title: Text(data['firstName']+" "+data['lastName']),
                          subtitle: Text("0"+data['phone']),
                          leading: CircleAvatar(backgroundImage: CachedNetworkImageProvider(data['profilePic'])),
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>UserDetails(id: data)));
                                    },
                                    child: Container(
                                        alignment: Alignment.center,
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8.0),
                                            gradient: LinearGradient(colors: [
                                              color2,
                                              color1
                                            ])),
                                        padding: const EdgeInsets.all(0),
                                        child: const Text(
                                          'Details User',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: TextButton(
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>UserPosts(id: data)));
                                    },
                                    child: Container(
                                        alignment: Alignment.center,
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8.0),
                                            gradient: LinearGradient(colors: [
                                              color2,
                                              color1
                                            ])),
                                        padding: const EdgeInsets.all(0),
                                        child: Text(
                                          'See Posts',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ],

                        ),
                      ),
                    );
                  }).toList(),
                );
            }
          }),
      drawer: NavigationDrawer(),
    );
  }

}
