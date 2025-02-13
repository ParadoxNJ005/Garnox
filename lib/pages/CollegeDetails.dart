import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../database/Apis.dart';
import '../utils/contstants.dart';
import 'HomePage.dart';

class CollegeDetails extends StatefulWidget {
  const CollegeDetails({super.key});

  @override
  State<CollegeDetails> createState() => _CollegeDetailsState();
}

class _CollegeDetailsState extends State<CollegeDetails>{

  String Branch = 'IT';

  var branchitems = [
    'IT',
    'ITBI',
    'ECE',
  ];

  String Year = '2024-2028';

  var yearitems = [
    '2023-2027',
    '2022-2026',
    '2021-2025',
    '2024-2028',
  ];

  int Semester = 1;

  var semesteritems = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
  ];

  @override
  void initState() {
    super.initState();
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.white,
    //   statusBarIconBrightness: Brightness.dark, // Light or dark depending on background color
    // ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.WHITE,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 70),
              Padding(
                padding: EdgeInsets.all(0),
                child: Center(
                  child: Text(
                    "Welcome To IIITA",
                    style: GoogleFonts.epilogue(
                      fontSize: 30,
                      textStyle: TextStyle(
                        color: Constants.BLACK,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 35),
              Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  child: Image.asset(
                    "assets/svgIcons/page3.png",
                    fit: BoxFit.contain, // Adjust the fit property as needed
                  ),
                ),
              ),
              SizedBox(height: 55),
              Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Constants.APPCOLOUR),
                      ),
                    ),
                    value: Branch,
                    icon: const Icon(Icons.keyboard_arrow_down),
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
                ),
              ),
              SizedBox(height: 15),
              Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Constants.APPCOLOUR),
                      ),
                    ),
                    value: Year,
                    icon: const Icon(Icons.keyboard_arrow_down),
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
                ),
              ),
              SizedBox(height: 15),
              Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Constants.APPCOLOUR),
                      ),
                    ),
                    value: Semester,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: semesteritems.map((int items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items.toString()),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        Semester = newValue!;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 55),
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
                      await APIs.updateCollegeDetails(hi(Year), Branch, Semester);

                      // Dismiss the progress indicator
                      Navigator.pop(context);

                      // Navigate to the home screen
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
                    } catch (error) {
                      // Dismiss the progress indicator
                      Navigator.pop(context);

                      // Show an error message
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text(error.toString()),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
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
              ),
            ],
          ),
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
