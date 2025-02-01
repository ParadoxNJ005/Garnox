import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../components/Custom_navDrawer.dart';
import '../components/custom_helpr.dart';
import '../database/Apis.dart';
import '../models/SpecificSubjectModel.dart';
import '../utils/contstants.dart';
import 'NotificationPage.dart';
import 'SearchPage.dart';
import 'Subject_detail.dart';

class SemViseSubjects extends StatefulWidget{
  const SemViseSubjects({super.key});

  @override
  State<SemViseSubjects> createState() => _SemViseSubjectsState();
}

class _SemViseSubjectsState extends State<SemViseSubjects>{
  bool _isSearching = false;
  final storage = new FlutterSecureStorage();
  // late GlobalKey<RefreshIndicatorState> refreshKey;
  Random random = Random();

  @override
  void initState(){
    super.initState();

    // refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  // Future<void> _handleRefresh() async {
  //   await APIs.fetchSemSubjectName();
  //   await APIs.fetchAllSubjects();
  //   await Future.delayed(Duration(seconds: 1));
  // }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Subjects',
          style: GoogleFonts.epilogue(
            textStyle: TextStyle(
              color: Constants.BLACK,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: SvgPicture.asset(
              "assets/svgIcons/hamburger.svg",
              color: Constants.BLACK,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              "assets/svgIcons/notification.svg",
              color: Constants.BLACK,
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => NotificationScreen()));
            },
          ),
        ],
      ),
      drawer: CustomNavDrawer(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: WillPopScope(
          onWillPop: () {
            if (_isSearching) {
              setState(() {
                _isSearching = !_isSearching;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ListTile(
                      leading: Icon(Icons.search),
                      title: Text("Search Subject..."),
                      onTap: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (_) => SearchPage()));
                      },
                    ),
                  ),
                  SizedBox(height: 16), // Space between search bar and heading
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Semester ${APIs.me!.semester}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  if (APIs.me!.branch == "ECE")
                    _subCardList(APIs.semSubjectName?.ece ?? []),
                  if (APIs.me!.branch == "IT")
                    _subCardList(APIs.semSubjectName?.it ?? []),
                  if (APIs.me!.branch == "ITBI")
                    _subCardList(APIs.semSubjectName?.itBi ?? []),
                  const SizedBox(height: 20,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _subCardList(List<String> eceList) {
    bool isAnyTrue = eceList.any((subName) {
      List<String> parts = subName.split('_');
      if (parts.length == 2) {
        String number = parts[0]; // "1"
        return (number == APIs.me!.semester.toString());
      }
      return false;
    });

    if (eceList.isEmpty || !isAnyTrue) {
      return Center(
        child: Container(
          padding: EdgeInsets.only(top: 100, left: 50, right: 50),
          child: Column(
            children: [
              Lottie.asset('assets/animation/nodatafound.json'),
              SizedBox(height: 20),
              Text(
                "✏️ NO DATA FOUND!!",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: eceList.length,
        itemBuilder: (context, index) {
          return _subCard(eceList[index]);
        },
      );
    }
  }


  Widget _subCard(String subName) {
    List<String> parts = subName.split('_');
    String number ="";
    String department ="";
    bool check = false;

    if (parts.length == 2) {
      number = parts[0]; // "1"
      department = parts[1]; // "ECE"
      check = (number == APIs.me!.semester.toString());
    } else {
    }
    if(check){
      return Padding(padding: EdgeInsets.symmetric(horizontal: 20),
          child:
          InkWell(
            onTap: () async{
              var temp = await storage.read(key: "$department");
              if (temp != null) {
                Map<String, dynamic> tempJson = json.decode(temp);
                SpecificSubject specificSubject = SpecificSubject.fromJson(tempJson);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SubjectDetail(subject: specificSubject),
                  ),
                );
              } else {
                Dialogs.showSnackbar(context, "No data found");
              }
            },

            child: Card(
              color: Color.fromRGBO(232, 229, 239, 1),
              child: ListTile(
                leading: IconButton(
                  icon: SvgPicture.asset(
                    "assets/svgIcons/file.svg",
                  ),
                  onPressed: () {
                    // Handle drawer opening

                  },
                ),
                title: Text(department ,style: GoogleFonts.epilogue(
                  textStyle: TextStyle(
                    color: Constants.BLACK,
                    fontWeight: FontWeight.bold,
                  ),
                ),),
                subtitle: Text("${10 + random.nextInt(51)} Files"),
                trailing: IconButton(
                  onPressed: (){},
                  icon: Icon(Icons.more_vert),
                ),
              ),
            ),
          )
      );
    }else{
      return Container();
    }
  }
}
