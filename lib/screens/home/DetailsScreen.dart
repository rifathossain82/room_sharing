import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:room_sharing/model/post.dart';
import 'package:room_sharing/services/showMessage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../constraints/colors.dart';
import '../../services/call_email.dart';
import '../../widgets/appbar.dart';

class DetailsScreen extends StatefulWidget {
  Post post;
  DetailsScreen({Key? key,required this.post}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

var activeIndex=0;
CarouselController controller=CarouselController();
TextEditingController commentController=TextEditingController();  //to control comment edit text

List<String> images=[];
var authorName='';
var authorImg='';

//user who use this app now
late SharedPreferences sharedPreferences;
String userEmail = '';
String userName = '';
var userImage='';

//for post comments
CollectionReference comments =
FirebaseFirestore.instance.collection('comments');

class _DetailsScreenState extends State<DetailsScreen> {

  @override
  void initState() {
    super.initState();
    getEmail();
  }

  void getEmail() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userEmail = sharedPreferences.getString('email')!;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    findAuthor();
    findUser();
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Sharing'),
        elevation: 0,
        flexibleSpace: MyAppBar(),
      ),
      body: ListView(
        children: [
          SizedBox(height: 8,),
          postImage_carousel(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.post.title,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),),
                Text(widget.post.des,style: TextStyle(fontSize: 14),),
                SizedBox(height: 40,),
                RichText(text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(text: 'Price: '),
                      TextSpan(text: widget.post.price,style: TextStyle(fontWeight: FontWeight.w700)),
                      TextSpan(text: ' Tk'),
                      TextSpan(text: '   (per day)',style: TextStyle(fontSize: 10)),
                    ]
                )),
                SizedBox(height: 8,),
                Row(
                  children: [
                    Text('Food: '),
                    Text(widget.post.food_status,style: TextStyle(fontWeight: FontWeight.w700),),
                  ],
                ),
                SizedBox(height: 3,),
                widget.post.food_status.contains('Yes')?
                RichText(text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(text: 'Food Price: '),
                      TextSpan(text: widget.post.food_price ,style: TextStyle(fontWeight: FontWeight.w700)),
                      TextSpan(text: ' Tk'),
                      TextSpan(text: '   (per day)',style: TextStyle(fontSize: 10)),
                    ]
                ))
                    :
                Center(),

                SizedBox(height: 40,),
                Text('Location',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700),),
                Divider(),
                Text(widget.post.location,style: TextStyle(fontSize: 14),),

                SizedBox(height: 40,),
                Text('Author',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700),),
                Divider(),
                Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(authorImg),
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                          )
                      ),
                    ),
                    SizedBox(width: 16,),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(authorName,style: TextStyle(fontSize: 14,),),
                          Text(widget.post.time,style: TextStyle(fontSize: 12),),
                          Text(widget.post.date,style: TextStyle(fontSize: 12),),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: (){
                        createCall(widget.post.email);
                      },
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  color2,
                                  color1
                                ]
                            ),
                            borderRadius: BorderRadius.circular(4)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.phone,color: Colors.white,),
                              SizedBox(width: 5,),
                              Text('CALL',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500),),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16,),
                    InkWell(
                      onTap: (){
                        createEmail(widget.post.email);
                      },
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  color1,
                                  color2
                                ]
                            ),
                            borderRadius: BorderRadius.circular(4)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.email,color: Colors.white,),
                              SizedBox(width: 5,),
                              Text('EMAIL',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40,),

                Text('Comments',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700),),
                Divider(),

                //add a comment section
                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(userImage),
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                          )
                      ),
                    ),
                    SizedBox(width: 16,),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: commentController,
                            decoration: InputDecoration(
                              hintText: 'Add a comment',
                            ),
                          ),
                          commentController.text.isNotEmpty?
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: (){
                                    setState(() {
                                      commentController.clear();
                                    });
                                  },
                                  child: Text('CANCEL')
                              ),
                              TextButton(
                                  onPressed: (){
                                    setState(() {
                                      createComment();
                                      commentController.clear();
                                    });
                                  },
                                  child: Text('COMMENT')
                              ),
                            ],
                          )
                              :
                          Center(),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
              ],
            ),
          ),

          //show all comments
          SizedBox(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: showComments()
          ),
        ],
      ),
    );
  }

  Widget postImage_carousel(){
    images=[];
    if(widget.post.img1.isNotEmpty){
      images.add(widget.post.img1);
    }
    if(widget.post.img2.isNotEmpty){
      images.add(widget.post.img2);
    }
    if(widget.post.img3.isNotEmpty){
      images.add(widget.post.img3);
    }
    if(widget.post.img4.isNotEmpty){
      images.add(widget.post.img4);
    }
    if(widget.post.img5.isNotEmpty){
      images.add(widget.post.img5);
    }
    //print(images.length);
    return Center(
      child: Column(
        children: [
          CarouselSlider.builder(
              carouselController: controller,
              itemCount: images.length,
              itemBuilder: (context,index,realIndex){
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                      //borderRadius: BorderRadius.circular(8),
                      color: Colors.grey,
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(images[index]),
                        fit: BoxFit.cover,
                      )

                  ),
                );
              },
              options: CarouselOptions(
                  initialPage: 0,
                  height:  MediaQuery.of(context).size.height/3,
                  autoPlay: true,   //set autoplay
                  autoPlayAnimationDuration: Duration(seconds: 2), //duration for autoplay animation
                  autoPlayInterval: Duration(seconds: 3),   //set duration for auto play
                  viewportFraction: 1,       //to see only one photo
                  enlargeCenterPage: true,        //it's show center image bigger than others
                  enlargeStrategy: CenterPageEnlargeStrategy.height,    //
                  //pageSnapping: false,          //by this we can scroll every pixel
                  //enableInfiniteScroll: false, //by this you can not scroll in at last and fist item
                  onPageChanged: (index,reason){
                    setState(() {
                      activeIndex=index;
                    });
                  }
              )
          ),
          SizedBox(height: 20,),
          AnimatedSmoothIndicator(
            activeIndex: activeIndex,
            count: images.length,
            axisDirection: Axis.horizontal,
            onDotClicked: (index){
              controller.animateToPage(index);
            },
            effect:  ExpandingDotsEffect(
                spacing:  8.0,
                radius:  4.0,
                dotWidth:  16.0,
                dotHeight:  8.0,
                paintStyle:  PaintingStyle.fill,
                strokeWidth:  1.5,
                dotColor:  Colors.grey,
                activeDotColor:  Colors.deepOrange

            ),
          ),
        ],
      ),
    );
  }

  void findAuthor(){
    FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: widget.post.email)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      var f_name=querySnapshot.docs[0]['firstName'];
      var l_name=querySnapshot.docs[0]['lastName'];
      authorImg=querySnapshot.docs[0]['profilePic'];
       setState(() {
         authorName=f_name+" "+l_name;
       });
    });
  }

  void findUser(){
    FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: userEmail)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      var f_name=querySnapshot.docs[0]['firstName'];
      var l_name=querySnapshot.docs[0]['lastName'];
      userImage=querySnapshot.docs[0]['profilePic'];
      setState(() {
        userName=f_name+" "+l_name;
      });
    });
  }

  void createComment(){
    comments.add({
      'postid': widget.post.id,
      'image': userImage,
      'name': userName,
      'comment': commentController.text,
    }).then((value){
      showMessage('Comment submit Successfully.');
    })
        .onError((error, stackTrace){
      showMessage('Comment submit Failed.');
    });
  }

  Widget showComments(){
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('comments')
            .where('postid', isEqualTo: widget.post.id)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(!snapshot.hasData) {
                return Center(child: Text('No Comments Yet!', style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w400),),);
              }
              else{
                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot data) {
                    return ListTile(
                      leading: CircleAvatar(backgroundImage: CachedNetworkImageProvider(data['image'])),
                      title: Text(data['name']),
                      subtitle: Text(data['comment']),
                    );
                  }).toList(),
                );
              }
        });
  }

}
