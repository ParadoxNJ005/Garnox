import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../database/Apis.dart';
import '../pages/AuthPage.dart';
import '../pages/ProfilePage.dart';
import '../pages/developerPage.dart';
import '../pages/sem_vise_subjects.dart';
import '../utils/contstants.dart';
import 'custom_helpr.dart';

class CustomNavDrawer extends StatefulWidget {
  const CustomNavDrawer({super.key});

  @override
  State<CustomNavDrawer> createState() => _CustomNavDrawerState();
}

class _CustomNavDrawerState extends State<CustomNavDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
          children: <Widget>[
            Container(
              color: Constants.WHITE,
              height: 150,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: Container(
                      height: 60,
                      width: 60,
                      child: CachedNetworkImage(
                        imageUrl: APIs.me!.imageUrl!,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                                colorFilter:
                                ColorFilter.mode(Colors.white, BlendMode.colorBurn)),
                          ),
                        ),
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                  title: Text(
                    APIs.me!.name!,
                    style: GoogleFonts.epilogue(
                      textStyle: TextStyle(
                        fontSize: 20,
                        color: Constants.BLACK,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  subtitle: Text(
                    APIs.me!.email!,
                    style: GoogleFonts.epilogue(
                      textStyle: TextStyle(
                        color: Constants.BLACK,
                      ),
                    ),
                  ),
                ),
              )
            ),
            _list(Icons.calendar_today_rounded, "Subjects", (){Navigator.push(context, MaterialPageRoute(builder: (_)=>SemViseSubjects()));}),
            _list(Icons.notifications_active, "Notifications", (){Dialogs.showSnackbar(context, "Oops! 😞 No Notification to Show");}),
            _list(Icons.location_on_outlined, "Address", (){Dialogs.showSnackbar(context, "😞 Currently we do not have Address functionality");}),
            _list(Icons.person, "Profile", (){Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));}),
            // _list(Icons.payment, "Plan Your Day", (){
            //      Navigator.push(context, MaterialPageRoute(builder: (_)=>Classes()));
            // }),
            _list(Icons.local_offer_outlined, "About", (){Navigator.push(context, MaterialPageRoute(builder: (_)=>DeveloperPage()));}),
            _list(Icons.share, "Share", (){Share.share("Hurry Up ⏰!! \n Download SEMBREAKER from Playstore and Boost your College Prep.");}),
            _list(Icons.support_agent_outlined, "Support", () async{
              Dialogs.showSnackbar(context, "😞 Currently we do not have Support functionality");
            }),
            _list(Icons.logout_outlined, "Sign out", ()async{ await APIs.Signout(); Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>Auth()), (route) => false,);}),
            Spacer(),
            Text(
              'Made with ❤️ By Geek Heaven',
              // "",
              style: GoogleFonts.epilogue(
                textStyle: TextStyle(
                  fontSize: 15,
                  color: Constants.BLACK,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 50,)
          ],
        ),
      );
  }
  Widget _list(IconData icon, String name, VoidCallback onPress){
    return ListTile(
      onTap: onPress,
      leading: IconButton(icon: Icon(icon) , onPressed: onPress,),
      title: Text(name,style: GoogleFonts.epilogue(
        textStyle: TextStyle(
          fontSize: 20,
          color: Constants.BLACK,
          fontWeight: FontWeight.bold,
        ),
      )),
    );
  }
}
