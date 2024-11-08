import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../database/Apis.dart';
import '../utils/contstants.dart';
import 'EditProfile.dart';
import 'HomePage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  void initState(){
    super.initState();
    // APIs.myInfo();
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
          'Profile',
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
                                        // ColorFilter.mode(Constants.APPCOLOUR, BlendMode.colorBurn)
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
            Container(
              width: double.infinity,
              height: 40,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 130),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>EditProfile() ));
                  },
                  child: Text("Edit Profile",style: TextStyle(color: Colors.white),),
                ),
              ),
            ),
        
            //------------------------------Content--------------------------------------//
            Container(
              color: Color.fromRGBO(246,246,246,1),
              width: double.infinity,
              height: 35,
              margin: EdgeInsets.only(top: 30 ,bottom: 5),
              child: Padding(
                padding: const EdgeInsets.only(left: 10 ,top: 10 ,bottom: 10),
                child: Text("Content",style: GoogleFonts.epilogue(
                            textStyle: TextStyle(
                            fontSize: 15,
                            color: Constants.BLACK,
                              fontWeight: FontWeight.bold,
                            ),
                ),),
              ),
            ),
            _list(Icons.favorite_border_rounded , "Content" , (){}),
            _list(Icons.download_outlined , "Download" , (){}),
        
            //------------------------------preferences--------------------------------------//
            Container(
              color: Color.fromRGBO(246,246,246,1),
              width: double.infinity,
              height: 35,
              margin: EdgeInsets.only(top: 5 ,bottom: 5),
              child: Padding(
                padding: const EdgeInsets.only(left: 10 ,top: 10 ,bottom: 10),
                child: Text("Preferences",style: GoogleFonts.epilogue(
                  textStyle: TextStyle(
                    fontSize: 15,
                    color: Constants.BLACK,
                    fontWeight: FontWeight.bold,
                  ),
                ),),
              ),
            ),
            _list(Icons.language_outlined , "Language" , (){}),
            _list(Icons.nights_stay_outlined , "Darkmode" , (){}),
            _list(Icons.message_outlined , "Contact us" , (){}),
            _list(Icons.change_circle_outlined , "Change Semister" , (){}),
        
            //------------------------------Made with love geekheaven--------------------------------------//
            SizedBox(height: 30,),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text("Made with ❤️ Geek Heaven" , style: TextStyle(fontWeight: FontWeight.bold),),
            )
          ],
        ),
      ),
    );
  }

  Widget _list(IconData icon, String name, VoidCallback onPress){
    return ListTile(
      leading: IconButton(icon: Icon(icon) , onPressed: onPress,),
      title: Text(name,style: GoogleFonts.epilogue(
                    textStyle: TextStyle(
                    fontSize: 15,
                    color: Constants.BLACK,
                    fontWeight: FontWeight.bold,
                  ),
      )),
      trailing: Icon(Icons.arrow_forward_ios),
    );
  }
}
