import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:sembreaker/utils/contstants.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperPage extends StatefulWidget {
  const DeveloperPage({super.key});

  @override
  State<DeveloperPage> createState() => _DeveloperPageState();
}

class _DeveloperPageState extends State<DeveloperPage>{

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  final String defaultUrl = "https://drive.google.com/file/d/1HIsqYoRY6bs2z95J6qFW8ubIlTSWIcQM/view?usp=sharing";

  Widget _buildDeveloperGrid() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('developer').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading developers'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        var developers = snapshot.data!.docs;
        var otherDevelopers = developers.where((dev) => dev['role'] != 'Coordinator').toList();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), // Prevents scrolling within GridView
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 cards per row
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 0.0,
              childAspectRatio: 0.9, // Adjust aspect ratio for equal-sized cards
            ),
            itemCount: otherDevelopers.length,
            itemBuilder: (context, index) {
              return _devCard(
                otherDevelopers[index]['image'] ?? defaultUrl,
                otherDevelopers[index]['name'] ?? 'Unknown',
                otherDevelopers[index]['role'] ?? 'Unknown Role',
                otherDevelopers[index]['github'] ?? 'Unknown',
                otherDevelopers[index]['linkdin'] ?? 'Unknown',
              );
            },
          ),
        );
      },
    );
  }


  Widget _buildNaitikJainCard() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('developer').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading developer'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        var developers = snapshot.data!.docs;

        try {
          // Find all developers with the role 'Coordinator'
          var coordinators = developers.where((dev) =>
          dev['role'] == 'Coordinator').toList();

          if (coordinators.isEmpty) {
            // If no coordinators are found, return an empty widget
            return const SizedBox.shrink();
          }

          // If only one coordinator is present, center it
          if (coordinators.length == 1) {
            return Center(
              child: _devCard(
                coordinators[0]['image'] ?? defaultUrl,
                coordinators[0]['name'] ?? 'Unknown',
                coordinators[0]['role'] ?? 'Unknown Role',
                coordinators[0]['github'] ?? 'Unknown',
                coordinators[0]['linkdin'] ?? 'Unknown',
              ),
            );
          }

          // If two coordinators are present, display them in a GridView
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              // Prevents scrolling within GridView
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 cards per row
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 0.0,
                childAspectRatio: 0.9, // Adjust aspect ratio for equal-sized cards
              ),
              itemCount: coordinators.length,
              // Number of coordinators
              itemBuilder: (context, index) {
                return _devCard(
                  coordinators[index]['image'] ?? defaultUrl,
                  coordinators[index]['name'] ?? 'Unknown',
                  coordinators[index]['role'] ?? 'Unknown Role',
                  coordinators[index]['github'] ?? 'Unknown',
                  coordinators[index]['linkdin'] ?? 'Unknown',
                );
              },
            ),
          );
        } catch (e){
          return const SizedBox.shrink();
        }
      }
    );
  }

// Widget to build a small card for other developers
  Widget _devCard(String imageUrl, String name, String role, String github, String linkedin) {
    return InkWell(
      onTap: () {
        _showDeveloperDetails(
          context,
          name,
          imageUrl,
          role,
          github,
          linkedin,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
              radius: 40, // Smaller avatar for other developers
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              role,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

// Function to show developer details in a dialog
  void _showDeveloperDetails(
      BuildContext context,
      String name,
      String image,
      String role,
      String github,
      String linkedin,
      ) {
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
                colors: [Colors.blue[50]!,
                  Colors.blue[50]!,
                  Colors.blue[50]!,
                  Colors.blue[100]!],
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
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.colorBurn,
                            ),
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
                const SizedBox(height: 5),
                Text(
                  role,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildIconButton(true, github),
                    const SizedBox(width: 16),
                    _buildIconButton(false, linkedin),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// Widget to build GitHub and LinkedIn icon buttons
  Widget _buildIconButton(bool isGithub, String url) {
    return GestureDetector(
      onTap: () async {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not launch the link')),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        child: isGithub
            ? Image.asset(
          'assets/svgIcons/github.png',
          width: 30,
          height: 30,
        )
            : Image.asset(
          'assets/svgIcons/linkedin.png',
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
              Container(
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
                        'Meet Our Team',
                        style: GoogleFonts.epilogue(
                          textStyle: const TextStyle(
                            fontSize: 30,
                            color: Constants.WHITE,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Column(
                children: [
                  _buildNaitikJainCard(),
                  _buildDeveloperGrid(),
                ],
              ),
              const SizedBox(height: 15),
              // const SizedBox(height: 15),
              // Center(
              //   child: Center(
              //     child: Column(
              //       children: [
              //         Lottie.asset('assets/animation/nodatafound.json'),
              //         // Container(width: double.infinity ,child: Center(child: Text("✏️ NO DATA FOUND!!" ,style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w600),))),
              //       ],
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 30),
              Container(
                width: double.infinity,
                height: 70,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Constants.APPCOLOUR, // Background color
                  borderRadius: BorderRadius.circular(10), // Optional rounded corners
                ),
                child: Center(
                  child: Text(
                    'About',
                    style: GoogleFonts.epilogue(
                      textStyle: const TextStyle(
                        fontSize: 25,
                        color: Colors.white, // Changed to white for better contrast
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Hola Friends, ',
                          style: GoogleFonts.epilogue(
                            textStyle: const TextStyle(
                              fontSize: 18,
                              color: Constants.APPCOLOUR, // Change to blue
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        TextSpan(
                          text: "its a common scene on the night before the examinations, "
                              "we the students knock at each of our toppers door to get his/her notes "
                              "and waste a lot of our precious time in doing that. What if there is a "
                              "central place where you would get all the magical notes and material to "
                              "pass the papers, the destination is here, the SemBreaker App. Sounds fun Right?",
                          style: GoogleFonts.epilogue(
                            textStyle: const TextStyle(
                              fontSize: 18,
                              color: Constants.BLACK,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.left,
                  )
                ),
              ),
              const SizedBox(height: 15),
              // // Team Section Title

              // Column(
              //   children: [
              //     _buildNaitikJainCard(),
              //     _buildDeveloperGrid(),
              //   ],
              // ),
              // const SizedBox(height: 15),

              // IIITA Community Section
              Container(
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
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (await launch("https://www.instagram.com/geekhaven_iiita/?hl=en")) {
                        await canLaunch("https://www.instagram.com/geekhaven_iiita/?hl=en");
                      }
                    },
                    child: Image.asset(
                      'assets/svgIcons/instagram.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
                  const SizedBox(width: 30),
                  GestureDetector(
                    onTap: () async {
                      if (await launch("https://discord.com/channels/885149696249708635/885151791329722448")) {
                        await canLaunch("https://discord.com/channels/885149696249708635/885151791329722448");
                      }
                    },
                    child: Image.asset(
                      'assets/svgIcons/discord.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
                  const SizedBox(width: 30),
                  GestureDetector(
                    onTap: () async {
                      if (await launch("https://www.linkedin.com/company/geekhaven-iiita/posts/?feedView=all")) {
                        await canLaunch("https://www.linkedin.com/company/geekhaven-iiita/posts/?feedView=all");
                      }
                    },
                    child: Image.asset(
                      'assets/svgIcons/linkedin.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text(
                  'Made with ❤️ By GeekHaven',
                  style: GoogleFonts.epilogue(
                    textStyle: const TextStyle(
                      fontSize: 15,
                      color: Constants.BLACK,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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