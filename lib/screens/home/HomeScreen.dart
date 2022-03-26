import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:room_sharing/constraints/colors.dart';
import 'package:room_sharing/constraints/strings.dart';
import 'package:room_sharing/screens/home/DetailsScreen.dart';
import 'package:room_sharing/model/post.dart';
import 'package:room_sharing/widgets/appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/call_email.dart';
import '../../widgets/myDropDown.dart';
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


  var selectedDivision=divisionList[0];
  var selectedDistrict;
  var selectedUpazila;

  List<String> districtList=dhakaDistrictList;
  List<String> upazilaList=BargunaUpazilaList;

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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      appBar: AppBar(
        title: Text(app_name),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: MyAppBar(),
        actions: [
          IconButton(
              onPressed: (){
                setState(() {
                  selectedDivision=divisionList[0];
                  changeDistrictList();
                });
              },
              icon: Icon(Icons.refresh)
          )
        ],
      ),
      body: Column(
        children: [
          buildSearchSection(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: (selectedDivision.toString().contains('Select Division'))?
                  FirebaseFirestore.instance.collection('post').snapshots()
                      :
                (selectedDistrict=='') || (selectedDistrict==null) || (selectedDistrict.toString().contains('Select District'))?
                  FirebaseFirestore.instance
                          .collection('post')
                          .where('division', isEqualTo: selectedDivision)
                          .snapshots()
                      :
                (selectedUpazila=='') || (selectedDistrict==null) || (selectedUpazila.toString().contains('Select Upazila'))?
                FirebaseFirestore.instance
                    .collection('post')
                    .where('division', isEqualTo: selectedDivision)
                    .where('district', isEqualTo: selectedDistrict)
                    .snapshots()
                      :
                FirebaseFirestore.instance
                    .collection('post')
                    .where('division', isEqualTo: selectedDivision)
                    .where('district', isEqualTo: selectedDistrict)
                    .where('upazila', isEqualTo: selectedUpazila)
                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    default:
                      post_list = [];
                      return snapshot.data!.docs.isEmpty?
                      Center(child: Text('No Posts Yet!',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400, color: Colors.black54),),)
                          :
                      ListView(
                        children: snapshot.data!.docs.map((DocumentSnapshot data) {
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
                                    data['division'],
                                    data['district'],
                                    data['upazila'],
                                    data['location'],
                                    data['price'],
                                    data['food'],
                                    data['food_price'],
                                    data['img1'],
                                    data['img2'],
                                    data['img3'],
                                    data['img4'],
                                    data['img5']),
                                context
                            ),
                          );
                        }).toList(),
                      );
                  }
                }),
          ),
        ],
      ),
      drawer: NavigationDrawer(),
    );
  }

  Widget buildSearchSection(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 2,
        //shadowColor: Colors.deepPurple,
        borderOnForeground: true,
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              ///division dropdown here
              Row(
                children: [
                  Text('Division', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                  Spacer(),
                  divisionDropDown(),
                ],
              ),

              ///district dropdown here
              selectedDivision==divisionList[0]?
              Center()
                  :
              Row(
                children: [
                  Text('District', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                  Spacer(),
                  districtDropDown(),
                ],
              ),

              ///upazila dropdown here
              selectedDistrict==null || selectedDistrict==districtList[0]?
              Center()
                  :
              Row(
                children: [
                  Text('Upazila', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                  Spacer(),
                  upazilaDropDown(),
                ],
              ),

              // TextField(
              //   controller: searchController,
              //   //onSubmitted: searchLocation,
              //   onChanged: (value) {
              //     setState(() {
              //       searchString = value.toLowerCase().trim();
              //     });
              //   },
              //   decoration: InputDecoration(
              //       hintText: 'Uttara, Dhaka',
              //       prefixIcon: Icon(Icons.search),
              //       fillColor: Colors.white,
              //       filled: true,
              //       border: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(5),
              //           borderSide:
              //               BorderSide(color: Colors.transparent, width: 0)
              //       ),
              //       enabledBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(5),
              //           borderSide:
              //               BorderSide(color: Colors.transparent, width: 0)
              //       ),
              //       focusedBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(5),
              //           borderSide:
              //               BorderSide(color: Colors.transparent, width: 0)
              //       )
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget divisionDropDown(){
    return myDropDown(divisionList, selectedDivision, 'Select Division', (val){
      districtList.clear();
      setState(() {
        selectedDivision=val;
      });
      changeDistrictList();

    });
  }

  Widget districtDropDown(){
    return myDropDown(districtList, selectedDistrict, 'Select District', (val){
      upazilaList.clear();
      setState(() {
        selectedDistrict=val;
      });
      changeUpazilaList();
    });
  }

  Widget upazilaDropDown(){
    return myDropDown(upazilaList, selectedUpazila, 'Select Upazila', (val){
      setState(() {
        selectedUpazila=val;
      });
    });
  }

  void changeDistrictList(){
    if(selectedDivision==divisionList[1]){
      districtList.add('Select District');
      districtList.add('Dhaka');
      districtList.add('Faridpur');
      districtList.add('Gazipur');
      districtList.add('Gopalganj');
      districtList.add('Kishoreganj');
      districtList.add('Madaripur');
      districtList.add('Manikganj');
      districtList.add('Munshiganj');
      districtList.add('Narayanganj');
      districtList.add('Narshingdi');
      districtList.add('Rajbari');
      districtList.add('Shariatpur');
      districtList.add('Tangail');
    }
    else if(selectedDivision==divisionList[2]){
      districtList.addAll(chittagongDistrictList);
    }
    else if(selectedDivision==divisionList[3]){
      districtList.addAll(khulnaDistrictList);
    }
    else if(selectedDivision==divisionList[4]){
      districtList.addAll(barishalDistrictList);
    }
    else if(selectedDivision==divisionList[5]){
      districtList.addAll(mymensinghDistrictList);
    }
    else if(selectedDivision==divisionList[6]){
      districtList.addAll(rajshahiDistrictList);
    }
    else if(selectedDivision==divisionList[7]){
      districtList.addAll(rangpurDistrictList);
    }
    else if(selectedDivision==divisionList[8]){
      districtList.addAll(sylhetDistrictList);
    }
    else{
      districtList.addAll(sylhetDistrictList);
    }
    setState(() {
      selectedDistrict=districtList[0];
    });
    print(districtList);
  }

  void changeUpazilaList(){
    switch(selectedDistrict){
      case 'Barguna':
        upazilaList.addAll(BargunaUpazilaList);
        break;
      case 'Barishal':
        upazilaList.addAll(BarisalUpazilaList);
        break;
      case 'Bhola':
        upazilaList.addAll(BholaUpazilaList);
        break;
      case 'Jhalokathi':
        upazilaList.addAll(JhalokathiUpazilaList);
        break;
      case 'Patuakhali':
        upazilaList.addAll(PatuakhaliUpazilaList);
        break;
      case 'Pirojpur':
        upazilaList.addAll(PirojpurUpazilaList);
        break;
      case 'B.baria':
        upazilaList.addAll(B_bariaUpazilaList);
        break;
      case 'Bandarban':
        upazilaList.addAll(BandarbanUpazilaList);
        break;
      case 'Chandpur':
        upazilaList.addAll(ChandpurUpazilaList);
        break;
      case 'Chattogram':
        upazilaList.addAll(ChattogramUpazilaList);
        break;
      case 'Cox\'s bazar':
        upazilaList.addAll(Cox_bazarUpazilaList);
        break;
      case 'Cumilla':
        upazilaList.addAll(CumillaUpazilaList);
        break;
      case 'Feni':
        upazilaList.addAll(FeniUpazilaList);
        break;
      case 'Khagrachari':
        upazilaList.addAll(KhagrachariUpazilaList);
        break;
      case 'Laxmipur':
        upazilaList.addAll(LaxmipurUpazilaList);
        break;
      case 'Noakhali':
        upazilaList.addAll(NoakhaliUpazilaList);
        break;
      case 'Rangamati':
        upazilaList.addAll(RangamatiUpazilaList);
        break;
      case 'Dhaka':
        upazilaList.addAll(DhakaUpazilaList);
        break;
      case 'Faridpur':
        upazilaList.addAll(FaridpurUpazilaList);
        break;
      case 'Gazipur':
        upazilaList.addAll(GazipurUpazilaList);
        break;
      case 'Gopalganj':
        upazilaList.addAll(GopalganjUpazilaList);
        break;
      case 'Kishoreganj':
        upazilaList.addAll(KishoreganjUpazilaList);
        break;
      case 'Madaripur':
        upazilaList.addAll(MadaripurUpazilaList);
        break;
      case 'Manikganj':
        upazilaList.addAll(ManikganjUpazilaList);
        break;
      case 'Munshiganj':
        upazilaList.addAll(MunshiganjUpazilaList);
        break;
      case 'Narayanganj':
        upazilaList.addAll(NarayanganjUpazilaList);
        break;
      case 'Narshingdi':
        upazilaList.addAll(NarshingdiUpazilaList);
        break;
      case 'Rajbari':
        upazilaList.addAll(RajbariUpazilaList);
        break;
      case 'Shariatpur':
        upazilaList.addAll(ShariatpurUpazilaList);
        break;
      case 'Tangail':
        upazilaList.addAll(TangailUpazilaList);
        break;
      case 'Bagerhat':
        upazilaList.addAll(BagerhatUpazilaList);
        break;
      case 'Chuadanga':
        upazilaList.addAll(ChuadangaUpazilaList);
        break;
      case 'Jashore':
        upazilaList.addAll(JashoreUpazilaList);
        break;
      case 'Jhenaidah':
        upazilaList.addAll(JhenaidahUpazilaList);
        break;
      case 'Khulna':
        upazilaList.addAll(KhulnaUpazilaList);
        break;
      case 'Kushtia':
        upazilaList.addAll(KushtiaUpazilaList);
        break;
      case 'Magura':
        upazilaList.addAll(MaguraUpazilaList);
        break;
      case 'Meherpur':
        upazilaList.addAll(MeherpurUpazilaList);
        break;
      case 'Narail':
        upazilaList.addAll(NarailUpazilaList);
        break;
      case 'Satkhira':
        upazilaList.addAll(SatkhiraUpazilaList);
        break;
      case 'Jamalpur':
        upazilaList.addAll(JamalpurUpazilaList);
        break;
      case 'Mymensingh':
        upazilaList.addAll(MymensinghUpazilaList);
        break;
      case 'Netrokona':
        upazilaList.addAll(NetrokonaUpazilaList);
        break;
      case 'Sherpur':
        upazilaList.addAll(SherpurUpazilaList);
        break;
      case 'Bogura':
        upazilaList.addAll(BoguraUpazilaList);
        break;
      case 'C. nawabganj':
        upazilaList.addAll(CapainawabganjUpazilaList);
        break;
      case 'Joypurhat':
        upazilaList.addAll(JoypurhatUpazilaList);
        break;
      case 'Naogaon':
        upazilaList.addAll(NaogaonUpazilaList);
        break;
      case 'Natore':
        upazilaList.addAll(NatoreUpazilaList);
        break;
      case 'Pabna':
        upazilaList.addAll(PabnaUpazilaList);
        break;
      case 'Rajshahi':
        upazilaList.addAll(RajshahiUpazilaList);
        break;
      case 'Sirajganj':
        upazilaList.addAll(SirajganjUpazilaList);
        break;
      case 'Dinajpur':
        upazilaList.addAll(DinajpurUpazilaList);
        break;
      case 'Gaibandha':
        upazilaList.addAll(GaibandhaUpazilaList);
        break;
      case 'Kurigram':
        upazilaList.addAll(KurigramUpazilaList);
        break;
      case 'Lalmonirhat':
        upazilaList.addAll(LalmonirhatUpazilaList);
        break;
      case 'Nilphamari':
        upazilaList.addAll(NilphamariUpazilaList);
        break;
      case 'Panchagarh':
        upazilaList.addAll(PanchagarhUpazilaList);
        break;
      case 'Rangpur':
        upazilaList.addAll(RangpurUpazilaList);
        break;
      case 'Thakurgaon':
        upazilaList.addAll(ThakurgaonUpazilaList);
        break;
      case 'Habiganj':
        upazilaList.addAll(HabiganjUpazilaList);
        break;
      case 'Moulvibazar':
        upazilaList.addAll(MoulvibazarUpazilaList);
        break;
      case 'Sunamganj':
        upazilaList.addAll(SunamganjUpazilaList);
        break;
      case 'Sylhet':
        upazilaList.addAll(SylhetUpazilaList);
        break;
      default:
        break;
    }
    setState(() {
      selectedUpazila=upazilaList[0];
    });
    print(upazilaList);
  }

  Widget buildPost(Post post, BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Card(
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailsScreen(post: post)
              )
          );
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
                              Icons.email,
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
                height: 16,
              ),

            ],
          ),
        ),
      ),
    );
  }
}
