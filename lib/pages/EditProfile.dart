import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sembreaker/pages/HomePage.dart';

import '../components/custom_helpr.dart';
import '../database/Apis.dart';
import '../utils/contstants.dart';
import 'NotificationPage.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final semesterController = TextEditingController();
  final nameController = TextEditingController();
  final branchController = TextEditingController();
  final storage = new FlutterSecureStorage();

  String Branch = APIs.me!.branch!;

  var branchitems = [
    'IT',
    'ITBI',
    'ECE',
  ];

  String Year = '${APIs.me!.batch! - 4}-${APIs.me!.batch!}';

  var yearitems = [
    '2023-2027',
    '2022-2026',
    '2021-2025',
    '2024-2028',
  ];

  int Semester = APIs.me!.semester!;

  var semesteritems = [
    1,
    2,
    3,
    4,
    6,
    7,
    8,
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.light, // Light or dark depending on background color
    ));
  }

  @override
  void dispose() {
    emailController.dispose();
    semesterController.dispose();
    nameController.dispose();
    branchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double containerWidth = 120;
    double screenWidth = MediaQuery.of(context).size.width;
    double leftPosition = (screenWidth - containerWidth) / 2;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Constants.APPCOLOUR,
        elevation: 0,
        title: Text(
          'Edit Profile',
          style: GoogleFonts.epilogue(
            textStyle: TextStyle(
              color: Constants.WHITE,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>HomePage()));
          },
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              "assets/svgIcons/notification.svg",
              color: Constants.WHITE,
            ),
            onPressed: () {
              // Handle notification action
              Navigator.push(context, MaterialPageRoute(builder: (_)=>NotificationScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //-----------------------------profile image-----------------------------------//
            Container(
              width: double.infinity,
              height: 200,
              color: Constants.WHITE,
              child: Stack(
                children: [
                  Positioned(
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      color: Constants.APPCOLOUR,
                    ),
                  ),
                  Positioned(
                    top: 80,
                    left: leftPosition,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: Container(
                        width: containerWidth,
                        height: containerWidth,
                        color: Constants.WHITE,
                        child: Align(
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(80),
                            child: Container(
                              child: CachedNetworkImage(
                                imageUrl: APIs.me!.imageUrl!,
                                imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                        // colorFilter:
                                        // ColorFilter.mode(Constants.WHITE)
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => CircularProgressIndicator(),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            //-----------------------------Edit Profile button----------------------------//
            // Container(
            //   width: double.infinity,
            //   height: 40,
            //   child: Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 110),
            //     child: ElevatedButton(
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: Colors.black,
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(10),
            //         ),
            //       ),
            //       onPressed: (){},
            //       child: Text("Change Picture",style: TextStyle(color: Colors.white),),
            //     ),
            //   ),
            // ),

            //---------------------------Enter Fields------------------------------------------------------//
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 30),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name",
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              APIs.me?.name ?? '',
                              style: TextStyle(color: Colors.black ,fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Email",
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              APIs.me!.email!,
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Branch",
                              style: TextStyle(color: Colors.black),
                            ),
                            DropdownButtonFormField(
                              decoration: InputDecoration.collapsed(hintText: ''),
                              value: Branch,
                              icon: const Icon(Icons.edit),
                              items: branchitems.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  Branch = newValue!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Semester",
                              style: TextStyle(color: Colors.black),
                            ),
                            DropdownButtonFormField(
                              decoration: InputDecoration.collapsed(hintText: ''),
                              value: Semester,
                              icon: const Icon(Icons.edit),
                              items: semesteritems.map((int items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text("Sem ${items.toString()}"),
                                );
                              }).toList(),
                              onChanged: (int? newValue) {
                                setState(() {
                                  Semester = newValue!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Year",
                              style: TextStyle(color: Colors.black),
                            ),
                            DropdownButtonFormField(
                              decoration: InputDecoration.collapsed(hintText: ''),
                              value: Year,
                              icon: const Icon(Icons.edit),
                              items: yearitems.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  Year = newValue!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 45,
                      width: 180,
                      child: ElevatedButton(
                        onPressed: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.blue, // Set the color to blue
                                ),
                              );
                            },
                          );

                          try {
                            // Perform the update operation
                            await storage.delete(key: "${APIs.me!.batch!}");
                            await APIs.updateCollegeDetails(hi(Year), Branch, 1);
                            await APIs.myInfo();
                            await APIs.fetchSemSubjectName();

                            // Dismiss the progress indicator
                            Navigator.pop(context);

                            // Show a success message using Snackbar
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Profile updated successfully!'),
                                backgroundColor: Colors.green,
                              ),
                            );

                          } catch (error) {
                            // Dismiss the progress indicator
                            Navigator.pop(context);

                            // Show an error message using Snackbar
                            Dialogs.showSnackbar(context, "⚠️ Oops! Check Your Internet Connection");
                          }
                        },

                        child: Text(
                          "Upload",
                          style: TextStyle(color: Constants.WHITE, fontSize: 20),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Constants.APPCOLOUR),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ), // Add some space at the bottom
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int hi(String s){
    if(s == "2024-2028"){
      return 2028;
    }else if(s == "2023-2027"){
      return 2027;
    }else if(s == "2022-2026"){
      return 2026;
    }else{
      return 2025;
    }

  }
}
