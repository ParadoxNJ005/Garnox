import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/Custom_navDrawer.dart';
import '../components/custom_helpr.dart';
import '../database/Apis.dart';
import '../database/Locals.dart';
import '../models/SpecificSubjectModel.dart';
import '../models/recentsModel.dart';
import '../utils/contstants.dart';
import 'NotificationPage.dart';
import 'OpenPdf.dart';
import 'package:shimmer/shimmer.dart';
import 'RecentsPage.dart';
import 'SearchPage.dart';
import 'Subject_detail.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool issearch = false;
  String _searchText = "";
  final List<Recents> _searchList = [];
  late List<Recents> _findFromSearchList = [];
  final storage = FlutterSecureStorage();
  List<Recents> _list = [];
  late GlobalKey<RefreshIndicatorState> refreshKey;
  List<String> eceList = [];
  Random random = Random();
  bool isthere = false;


  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
  }


  Future<void> _initializeData() async {
    await APIs.offlineInfo();
    await LOCALs.MakeSearchFunctionality();
    // _handleRefresh();
    // _findFromSearchList = await LOCALs.finalSeachDataList?? [];
    String branchName = APIs.me!.branch!;
    if (branchName == "ECE") {
      eceList = await APIs.semSubjectName?.ece ?? [];
    } else if (branchName == "ITBI") {
      eceList = await APIs.semSubjectName?.itBi ?? [];
    } else {
      eceList = await APIs.semSubjectName?.it ?? [];
    }
  }

  Future<void> _handleRefresh()async{
    await Future.delayed(Duration(seconds: 1));
    await APIs.fetchAllSubjects();
    await APIs.fetchSemSubjectName();
    setState(() {
      eceList = APIs.semSubjectName?.ece ?? [];
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'HomePage',
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
              Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationScreen()));
            },
          ),
        ],
      ),
      drawer: const CustomNavDrawer(),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: FutureBuilder(
          future: _initializeData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: _buildShimmer(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else {
              return WillPopScope(
                onWillPop: () {
                  if (issearch) {
                    return Future.value(false);
                  } else {
                    return Future.value(true);
                  }
                },
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: ListTile(
                        leading: Icon(Icons.search),
                        title: Text("Search Subject..."),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (_) => SearchPage(),
                          ));
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Subjects",
                      style: GoogleFonts.epilogue(
                        textStyle: TextStyle(
                          color: Constants.BLACK,
                          fontWeight: FontWeight.bold,
                        ),
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(height: 20),
                    _subCardList(),
                    SizedBox(height: 30,),
                    Text(
                      "My Files",
                      style: GoogleFonts.epilogue(
                        textStyle: TextStyle(
                          color: Constants.BLACK,
                          fontWeight: FontWeight.bold,
                        ),
                        fontSize: 25,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                              child: Container(
                                height: 25,
                                width: 120,
                                child: Center(
                                  child: Text(
                                    "Recently used ￬",
                                    style: TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (_) => RecentsPage(),
                              ));
                            },
                            child: Text(
                              "See all",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder(
                      future: LOCALs.fetchRecents(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text("Error: ${snapshot.error}"),
                          );
                        } else if (snapshot.hasData) {
                          _list = snapshot.data!;
                          if (_list.isEmpty) {
                            return SizedBox(
                              height: 200,
                              child: Center(
                                child: Text(
                                  "✏️ NO DATA FOUND!!",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Column(
                              children: _list.map((subName) {
                                return _fileCard(subName);
                              }).toList(),
                            );
                          }
                        } else {
                          return Center(
                            child: Text("No Files Found"),
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  //
  // Widget _subCardList() {
  //   if (eceList.isEmpty) {
  //     return Container(width: double.infinity,
  //         child: Center(child: Text("✏️ NO DATA FOUND!!", style: TextStyle(
  //             color: Colors.black,
  //             fontSize: 20,
  //             fontWeight: FontWeight.w500),)));
  //   } else
  //     return SingleChildScrollView(
  //       scrollDirection: Axis.horizontal,
  //       child: Row(
  //         children: eceList.map((subName) {
  //           return _subCard(subName);
  //         }).toList(),
  //       ),
  //     );
  // }

  Widget _subCardList() {
    bool isAnyTrue = eceList.any((subName) {
      List<String> parts = subName.split('_');
      if (parts.length == 2) {
        String number = parts[0]; // "1"
        return (number == APIs.me!.semester.toString());
      }
      return false;
    });

    if (!isAnyTrue) {
      return Container(
        width: double.infinity,
        height: 200,
        child: Center(
          child: Text(
            "✏️ NO DATA FOUND!!",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: eceList.map((subName) {
            return _subCard(subName);
          }).toList(),
        ),
      );
    }
  }

  Widget _subCard(String subName) {
    List<String> parts = subName.split('_');
    String number = "";
    String department = "";
    bool check = true;

    if (parts.length == 2) {
      number = parts[0]; // "1"
      department = parts[1];
      check = (number == APIs.me!.semester.toString());
    } else {
    }

    if (check) {
      return InkWell(
        onTap: () async {
          var temp = await storage.read(key: "$department");
          Dialogs.showProgressBar(context);

          if (temp != null) {
            Map<String, dynamic> tempJson = json.decode(temp);
            SpecificSubject specificSubject = SpecificSubject.fromJson(tempJson);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SubjectDetail(subject: specificSubject),
              ),
            ).then((_) {
              Navigator.pop(context);
            });
          } else {
            Navigator.pop(context);
            Dialogs.showSnackbar(context, "No data found");
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Container(
            color: Colors.white,
            child: Container(
              height: 180,
              width: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Container(
                      width: double.infinity,
                      height: 120,
                      color: Color.fromRGBO(232, 229, 239, 1),
                      child: Padding(
                        padding: const EdgeInsets.all(45.0),
                        child: SvgPicture.asset(
                          "assets/svgIcons/file.svg",
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      department,
                      style: GoogleFonts.epilogue(
                        textStyle: TextStyle(
                          color: Constants.BLACK,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(0),
                    child: Text(
                      "${10 + random.nextInt(51)} files",
                      style: GoogleFonts.epilogue(
                        textStyle: TextStyle(
                          color: Constants.BLACK,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }

  }

  Widget _fileCard(Recents temp) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: InkWell(
        onTap: () async {
          if(temp.Type == "material" || temp.Type == "papers"){
            Navigator.push(context, MaterialPageRoute(builder: (_)=>OpenPdf(link: temp.URL, title: temp.Title,)));
          }
        },
        child: Card(
          child: ListTile(
            leading: IconButton(
              icon: SvgPicture.asset(
                "assets/svgIcons/file.svg",
              ),
              onPressed: () {
                // log("File icon pressed");
                // Handle file icon pressed action
              },
            ),
            title: Text(
              temp.Title,
              style: GoogleFonts.epilogue(
                textStyle: TextStyle(
                  color: Constants.BLACK,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            trailing: Container(
              constraints: BoxConstraints(maxWidth: 40),
              // Ensure the trailing icon is properly sized
              child: PopupMenuButton<String>(
                onSelected: (value) async {
                  // log("Popup menu item selected: $value");
                  switch (value) {
                    case 'share':
                    // log("Copying link to clipboard");
                      Share.share("Here is the Url of ${temp.Title} \n ${temp.URL}");
                      break;
                    case 'download':
                    // log("Download selected");
                      Clipboard.setData(ClipboardData(text: temp.URL));
                      Dialogs.showSnackbar(
                          context, "🔗 Link copied to clipboard!");
                      await _showDownloadInstructions(temp.URL);
                      break;
                  }
                },
                itemBuilder: (BuildContext context) {
                  // log("Building popup menu items");
                  return [
                    PopupMenuItem(
                      value: 'share',
                      child: ListTile(
                        leading: Icon(Icons.share, color: Constants.APPCOLOUR),
                        title: Text("Share"),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'download',
                      child: ListTile(
                        leading: Icon(Icons.download_sharp, color: Constants
                            .APPCOLOUR),
                        title: Text("Download"),
                      ),
                    ),
                  ];
                },
                onCanceled: () {
                  // log("Popup menu canceled");
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDownloadInstructions(String url) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Download Instructions'),
          content: Text(
            'To download the PDF, please follow these steps:\n\n'
                '1. Open the Copied link in your browser:\n'
                '$url\n\n'
                '2. Log in with your college account: xxxxxxxxxx@iiita.ac.in\n\n'
                '3. Once logged in, you will be able to download the file.',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: BorderSide(color: Colors.black, width: 2.0),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _openInBrowser(url);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _openInBrowser(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url, forceSafariVC: false,
            forceWebView: false); // Open in default browser (Chrome)
        // log("URL opened in browser");
      } else {}
    } catch (e) {
      // log("Error opening URL: $e");
    }
  }

  Widget _buildShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Row(
              children: [
                Icon(Icons.search),
                SizedBox(width: 10,),
                Text(
                  "Search subjects...", style: TextStyle(),
                ),
              ],
            ),),
          SizedBox(height: 30),
          Text(
            "Subjects",
            style: GoogleFonts.epilogue(
              textStyle: TextStyle(
                color: Constants.BLACK,
                fontWeight: FontWeight.bold,
              ),
              fontSize: 25,
            ),
          ),
          SizedBox(height: 5),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(5, (index) => _buildSubCardShimmer()),
            ),
          ),
          SizedBox(height: 20),
          Text(
            "My Files",
            style: GoogleFonts.epilogue(
              textStyle: TextStyle(
                color: Constants.BLACK,
                fontWeight: FontWeight.bold,
              ),
              fontSize: 25,
            ),
          ),
          SizedBox(height: 10),
          _buildFileShimmer(),
        ],
      ),
    );
  }

  Widget _buildSubCardShimmer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 180,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: double.infinity,
                  height: 120,
                  color: Color.fromRGBO(232, 229, 239, 1),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 100,
                height: 20,
                color: Colors.white,
              ),
              SizedBox(height: 5),
              Container(
                width: 50,
                height: 20,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFileShimmer() {
    return Column(
      children: List.generate(3, (index) =>
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          )),
    );
  }
}
