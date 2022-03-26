import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

Widget socialMediaIcon(String url, IconData icon, BuildContext context) {
  final size=MediaQuery.of(context).size;
  return InkWell(
      onTap: () {
        _launchURL(url);
      },
      borderRadius: BorderRadius.circular(100),
      child: Container(
        height: 35,
        width: 35,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FaIcon(icon,size: 16,),
        ),
      ));
}

void _launchURL(String url) async {
  if (!await launch(
    url,
    forceSafariVC: true,
    forceWebView: true,
    enableJavaScript: true,
  )) {
    throw 'Could not launch $url';
  }
}
