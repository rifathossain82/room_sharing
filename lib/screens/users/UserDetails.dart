import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:room_sharing/services/showMessage.dart';
import '../../widgets/appbar.dart';


class UserDetails extends StatefulWidget {
  var id;
  UserDetails({Key? key,required this.id}) : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: Text('User Details'),
        flexibleSpace: MyAppBar(),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: (){
                widget.id.reference.delete();
                showMessage('Successfully Deleted User!');
                Navigator.pop(context);
              },
              icon: Icon(Icons.delete))
        ],
      ),
      body: ListView(
        children: [
          Container(
              height: size.height/3,
              width: size.width,
              child: CachedNetworkImage(
                imageUrl: widget.id['profilePic'],
                fit: BoxFit.cover,
              )
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex:1, child: Text('Name',style: TextStyle(fontSize: 14,color: Colors.white.withOpacity(0.6)),)),
                SizedBox(width: 16,),
                Expanded(flex:3, child: Text(widget.id['firstName']+" "+widget.id['lastName'],style: TextStyle(fontSize: 18,color: Colors.white),)),
              ],
            ),
          ),
          Divider(color: Colors.white.withOpacity(0.5)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex:1, child: Text('Address',style: TextStyle(fontSize: 14,color: Colors.white.withOpacity(0.6)),)),
                SizedBox(width: 16,),
                Expanded(flex:3, child: Text(widget.id['address'],style: TextStyle(fontSize: 18,color: Colors.white),)),
              ],
            ),
          ),
          Divider(color: Colors.white.withOpacity(0.5)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex:1, child: Text('Email Address',style: TextStyle(fontSize: 14,color: Colors.white.withOpacity(0.6)),)),
                SizedBox(width: 16,),
                Expanded(flex:3, child: Text(widget.id['email'],style: TextStyle(fontSize: 18,color: Colors.white),)),
              ],
            ),
          ),
          Divider(color: Colors.white.withOpacity(0.5)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex:1, child: Text('Phone Number',style: TextStyle(fontSize: 14,color: Colors.white.withOpacity(0.6)),)),
                SizedBox(width: 16,),
                Expanded(flex:3, child: Text(widget.id['phone'],style: TextStyle(fontSize: 18,color: Colors.white),)),
              ],
            ),
          ),
          Divider(color: Colors.white.withOpacity(0.5)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex:1, child: Text('Nid Number',style: TextStyle(fontSize: 14,color: Colors.white.withOpacity(0.6)),)),
                SizedBox(width: 16,),
                Expanded(flex:3, child: Text(widget.id['nidNumber'],style: TextStyle(fontSize: 18,color: Colors.white),)),
              ],
            ),
          ),
          Divider(color: Colors.white.withOpacity(0.5)),

          SizedBox(height: 30,),
          Center(child: Text('National ID',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 20,color: Colors.white),)),
          SizedBox(height: 16,),
          Container(
              height: 180,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                    fit: BoxFit.cover, image: CachedNetworkImageProvider(widget.id['nid1'])),
              )
          ),
          SizedBox(height: 30,),
          Container(
              height: 180,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                    fit: BoxFit.cover, image: CachedNetworkImageProvider(widget.id['nid2'])),
              )
          ),
          SizedBox(height: 30,),
        ],
      ),
    );
  }

}
