import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

void createCall(String email){
  FirebaseFirestore.instance
      .collection('user')
      .where('email', isEqualTo: email)
      .get()
      .then((QuerySnapshot querySnapshot) async {
    var number=querySnapshot.docs[0]['phone'];
    var url='tel: 0${number}';

    if(await canLaunch(url)){
      await launch(url);
    }
  });
}

void createEmail(String email){
  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: email,
    query: encodeQueryParameters(<String, String>{
      'Enter You subject': 'Example Subject & Symbols are allowed!'
    }),
  );

  launch(emailLaunchUri.toString());
}