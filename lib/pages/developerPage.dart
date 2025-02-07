import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sembreaker/utils/contstants.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperPage extends StatefulWidget {
  const DeveloperPage({super.key});

  @override
  State<DeveloperPage> createState() => _DeveloperPageState();
}

class _DeveloperPageState extends State<DeveloperPage> with TickerProviderStateMixin{
  late AnimationController _controller1;
  late Animation<Offset> animation1;
  late AnimationController _controller2;
  late Animation<Offset> animation2;

  @override
  void initState(){
    super.initState();

    _controller1 = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    animation1 = Tween<Offset>(
      begin: const Offset(0.0, -5.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller1, curve: Curves.bounceInOut),
    );

    _controller2 = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    animation2 = Tween<Offset>(
      begin: const Offset(0.0, 5.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller2, curve: Curves.bounceOut),
    );

    _controller1.forward();
    _controller2.forward();
  }

  @override
  void dispose(){
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  final String defaultUrl = "https://drive.google.com/file/d/1HIsqYoRY6bs2z95J6qFW8ubIlTSWIcQM/view?usp=sharing";

  Widget _buildDeveloperGrid(){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('developer').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading developers'));
        }

        if (snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator());
        }

        var developers = snapshot.data!.docs;
        var rows = <Widget>[];

        for (var i = 0; i < developers.length; i += 2) {
          var row = Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _devImage(
                developers[i]['image'] ?? defaultUrl,
                developers[i]['name'] ?? 'Unknown',
                developers[i]['github'] ?? 'Unknown',
                developers[i]['linkdin'] ?? 'Unknown'
              ),
              if (i + 1 < developers.length)
                _devImage(
                  developers[i + 1]['image'] ?? defaultUrl,
                  developers[i + 1]['name'] ?? 'Unknown',
                  developers[i]['github'] ?? 'Unknown',
                  developers[i]['linkdin'] ?? 'Unknown'
                ),
            ],
          );

          rows.add(SlideTransition(
            position: animation1,
            child: row,
          ));
          rows.add(const SizedBox(height: 20));
        }

        return Column(children: rows);
      },
    );
  }

  // void openWhatsApp() async {
  //   final whatsappUrl = 'https://wa.me/?text=${Uri.encodeComponent(message)}';
  //   if (await launch(whatsappUrl)) {
  //     await canLaunch(whatsappUrl);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('WhatsApp is not installed on this device')),
  //     );
  //   }
  // }

  Widget _devImage(String url, String name, String github , String linkdin){
    return Column(
      children: [
        InkWell(
          onTap: (){
            _showDeveloperDetails(context , name , url , github , linkdin);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: SizedBox(
              height: 100,
              width: 100,
              child: CachedNetworkImage(
                imageUrl: url,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.colorBurn),
                    ),
                  ),
                ),
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.person),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          name,
          style: GoogleFonts.epilogue(
            textStyle: const TextStyle(
              fontSize: 15,
              color: Constants.BLACK,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }

  void _showDeveloperDetails(BuildContext context, String name , String image , String github , String linkdin){
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[50]!, Colors.blue[100]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: SizedBox(
                    height: 120,
                    width: 120,
                    child: CachedNetworkImage(
                      imageUrl: image,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.colorBurn),
                          ),
                        ),
                      ),
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(Icons.person),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildIconButton(true ,github),
                    const SizedBox(width: 16),
                    _buildIconButton(false ,linkdin),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIconButton(bool a , String url){
    return GestureDetector(
      onTap: () async {
        if (await launch(url)) {
          await canLaunch(url);
        } else {
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        child: (a) ? Image.asset(
          'assets/svgIcons/github.png',
          color: Constants.BLACK,
          width: 30,
          height: 30,
        ) : Image.asset(
          'assets/svgIcons/linkedin.png',
          color: Constants.BLACK,
          width: 30,
          height: 30,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "About",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // App Logo Section
              SlideTransition(
                position: animation1,
                child: Container(
                  width: double.infinity,
                  height: 80,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Constants.APPCOLOUR,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/svgIcons/applogo.svg',
                          colorFilter: const ColorFilter.mode(Constants.WHITE, BlendMode.srcIn),
                          height: 40,
                          width: 40,
                        ),
                        const SizedBox(width: 20),
                        Text(
                          'SEMBREAKER',
                          style: GoogleFonts.epilogue(
                            textStyle: const TextStyle(
                              fontSize: 30,
                              color: Constants.WHITE,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Team Section Title
              SlideTransition(
                position: animation1,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: Text(
                      'Meet Our Team',
                      style: GoogleFonts.epilogue(
                        textStyle: const TextStyle(
                          fontSize: 25,
                          color: Constants.BLACK,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Developer Grid
              _buildDeveloperGrid(),
              const SizedBox(height: 30),
              // About Section
              SlideTransition(
                position: animation2,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: Text(
                      'About',
                      style: GoogleFonts.epilogue(
                        textStyle: const TextStyle(
                          fontSize: 25,
                          color: Constants.BLACK,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SlideTransition(
                position: animation2,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: Text(
                      'Hola Friends, its a common scene on the night before the examinations, '
                    'we the students knock at each of our toppers door to get his/her notes '
                    'and waste a lot of our precious time in doing that. What if there is a '
                      'central place where you would get all the magical notes and material to '
                      'pass the papers, the destination is here, the SemBreaker App. Sounds fun Right?',
                      style: GoogleFonts.epilogue(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          color: Constants.BLACK,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              // IIITA Community Section
              SlideTransition(
                position: animation2,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: MediaQuery.sizeOf(context).height*.55,
                  decoration: BoxDecoration(
                    color: Constants.BLACK,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: Constants.BLACK,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        width: double.infinity,
                        height: MediaQuery.sizeOf(context).height * 0.2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15), // Matches the container's borderRadius
                          child: Image.asset(
                            'assets/images/geek.jpeg', // Replace with your image asset path
                            fit: BoxFit.contain, // Ensures the image covers the entire container
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Text(
                          'Join \nGeekHaven Community \nnow',
                          style: GoogleFonts.epilogue(
                            textStyle: const TextStyle(
                              fontSize: 30,
                              color: Constants.WHITE,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height:40,
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: ElevatedButton(
                          onPressed: () async {
                            const url = 'https://geekhaven.iiita.ac.in/';
                            if (await launch(url)) {
                              await canLaunch(url);
                            } else {
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Constants.APPCOLOUR),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          child: const Text(
                            "Join",
                            style: TextStyle(color: Constants.WHITE, fontSize: 25),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text(
                  'Made with ❤️ By GeekHeaven',
                  style: GoogleFonts.epilogue(
                    textStyle: const TextStyle(
                      fontSize: 15,
                      color: Constants.BLACK,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.sizeOf(context).height*0.05,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (await launch("https://www.instagram.com/geekhaven_iiita/?hl=en")) {
                          await canLaunch("https://www.instagram.com/geekhaven_iiita/?hl=en");
                        } else {
                        }
                      },
                      child: Image.asset(
                        'assets/svgIcons/instagram.png',
                        color: Constants.BLACK,
                        width: 40,
                        height: 40,
                      ),
                    ),
                    const SizedBox(width: 40,),
                    GestureDetector(
                      onTap: () async {
                        if (await launch("https://discord.com/channels/885149696249708635/885151791329722448")) {
                          await canLaunch("https://discord.com/channels/885149696249708635/885151791329722448");
                        } else {
                        }
                      },
                      child: Image.asset(
                        'assets/svgIcons/discord.png',
                        color: Constants.BLACK,
                        width: 40,
                        height: 40,
                      ),
                    ),
                    const SizedBox(width: 40,),
                    GestureDetector(
                      onTap: () async {
                        if (await launch("https://www.linkedin.com/company/geekhaven-iiita/posts/?feedView=all")) {
                          await canLaunch("https://www.linkedin.com/company/geekhaven-iiita/posts/?feedView=all");
                        } else {
                        }
                      },
                      child: Image.asset(
                        'assets/svgIcons/linkedin.png',
                        color: Constants.BLACK,
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}