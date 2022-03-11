import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:room_sharing/screens/myPost/EditMyPost.dart';
import 'package:room_sharing/model/post.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constraints/colors.dart';
import '../../services/call_email.dart';
import '../../widgets/appbar.dart';

class MyPostDetailsScreen extends StatefulWidget {
  Post post;
  var id;
  MyPostDetailsScreen({Key? key,required this.post,required this.id}) : super(key: key);

  @override
  _MyPostDetailsScreenState createState() => _MyPostDetailsScreenState();
}

var activeIndex=0;
CarouselController controller=CarouselController();

List<String> images=[];
var authorName='';
var authorImg='';

class _MyPostDetailsScreenState extends State<MyPostDetailsScreen> {

  @override
  Widget build(BuildContext context) {
    findAuthor();
    return Scaffold(
      appBar: AppBar(
        title: Text('My Post'),
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

                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: (){
                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>EditMyPost(post: widget.post, id: widget.id)));
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
                              Icon(Icons.edit,color: Colors.white,),
                              SizedBox(width: 5,),
                              Text('EDIT',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500),),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16,),
                    InkWell(
                      onTap: (){
                        widget.id.reference.delete();
                        Navigator.pop(context);
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
                              Icon(Icons.delete,color: Colors.white,),
                              SizedBox(width: 5,),
                              Text('DELETE',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8,),
              ],
            ),
          )
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
}
