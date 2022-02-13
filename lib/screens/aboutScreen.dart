import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:room_sharing/widgets/socialMediaIcon.dart';

import '../constraints/strings.dart';
import '../widgets/appbar.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('About Room Sharing'),
        elevation: 0,
        flexibleSpace: MyAppBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo_.png',height: 70,width: 70,fit: BoxFit.fitWidth,),
                  SizedBox(height: 8,),
                  Text('Room Sharing',style: TextStyle(fontSize: 22,fontWeight: FontWeight.w700),),
                  Text('Version 1.1.0',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),),
                ],
              ),
            ),

            Expanded(
                flex: 2,
                child: RichText(
                  textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'We started with two mission:\n',style: TextStyle(color: Colors.black,fontSize: 16),
                  children:[
                    TextSpan(text: '1. Share rooms, earn money.\n',style: TextStyle(color: Colors.black.withOpacity(0.8),fontSize: 13)),
                    TextSpan(text: '2. Find rooms, safe zones',style: TextStyle(color: Colors.black.withOpacity(0.8),fontSize: 13)),
                  ]
                )),
            ),

            Expanded(
              flex: 5,
              child: Column(
                children: [
                  Text('There are many who move from one city to another for temporary work. And they have to stay in hotels with high prices and many times good hotels do not match. Our small effort to overcome their difficulties. One can get a house at a low price, the other can also make some income by sharing their unused room.',style: TextStyle(fontSize: 14),),
                  SizedBox(height: 8,),
                  Text('Finally, we will give you the opportunity to benefit financially.'),
                ],
              ),
            ),


            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Contact Us',style: TextStyle(fontSize: 22,fontWeight: FontWeight.w700),),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        socialMediaIcon(fb_url, FontAwesomeIcons.facebookF,context),
                        SizedBox(width: 8,),
                        socialMediaIcon(twitter_url, FontAwesomeIcons.twitter,context),
                        SizedBox(width: 8,),
                        socialMediaIcon(instagram_url, FontAwesomeIcons.instagram,context),
                        SizedBox(width: 8,),
                        socialMediaIcon(linkedin_url, FontAwesomeIcons.linkedinIn,context),
                        SizedBox(width: 8,),
                        socialMediaIcon(github_url, FontAwesomeIcons.github,context),
                        SizedBox(width: 8,),
                        socialMediaIcon(youTube_url, FontAwesomeIcons.youtube,context)
                      ],
                    ),
                  ),
                ],
              ),
            ),


            // //footer
            // Expanded(
            //   child: Column(
            //     children: [
            //       Divider(),
            //       SizedBox(
            //         height: size.height*0.1,
            //         child: Center(
            //           child: RichText(
            //             textAlign: TextAlign.center,
            //             text: TextSpan(
            //                 text: 'All Rights Reserved By ',
            //                 style: TextStyle(color: Colors.grey),
            //                 children: [
            //                   TextSpan(
            //                       text: 'officaialrifat82@gmail.com',
            //                       style: TextStyle(
            //                           color: Colors.red, fontStyle: FontStyle.italic))
            //                 ]),
            //           ),
            //         ),
            //       )
            //     ],
            //   ),
            // )



          ],
        ),
      ),
    );
  }
}
