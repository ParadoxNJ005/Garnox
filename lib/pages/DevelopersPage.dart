import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Developer {
  final String imageUrl;
  final String name;
  final String github;
  final String linkedin;

  Developer({
    required this.imageUrl,
    required this.name,
    required this.github,
    required this.linkedin,
  });
}

class DevelopersPage extends StatelessWidget {
  final List<Developer> developers = [
    Developer(
      imageUrl: 'https://avatars.githubusercontent.com/u/583231?v=4',
      name: 'Aarav',
      github: 'https://github.com/aarav0180',
      linkedin: 'https://linkedin.com/in/aarav-kashyap-a061b72a4/',
    ),
    Developer(
      imageUrl: 'https://avatars.githubusercontent.com/u/77547378?v=4',
      name: 'Jane Smith',
      github: 'https://github.com/janesmith',
      linkedin: 'https://linkedin.com/in/janesmith',
    ),
    Developer(
      imageUrl: 'https://avatars.githubusercontent.com/u/102702?v=4',
      name: 'Alice Johnson',
      github: 'https://github.com/alicejohnson',
      linkedin: 'https://linkedin.com/in/alicejohnson',
    ),
    Developer(
      imageUrl: 'https://avatars.githubusercontent.com/u/9919?v=4',
      name: 'Bob Lee',
      github: 'https://github.com/boblee',
      linkedin: 'https://linkedin.com/in/boblee',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Meet the Developers',
          style: GoogleFonts.poppins(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: Colors.blue[50],
        child: GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.9,
          ),
          itemCount: developers.length,
          itemBuilder: (context, index) {
            return _buildDeveloperCard(context, developers[index]);
          },
        ),
      ),
    );
  }

  Widget _buildDeveloperCard(BuildContext context, Developer developer) {
    return GestureDetector(
      onTap: () {
        _showDeveloperDetails(context, developer);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[400]!, Colors.blue[700]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(developer.imageUrl),
            ),
            const SizedBox(height: 10),
            Text(
              developer.name,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeveloperDetails(BuildContext context, Developer developer) {
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
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(developer.imageUrl),
                ),
                const SizedBox(height: 16),
                Text(
                  developer.name,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildIconButton(Icons.code, developer.github),
                    const SizedBox(width: 16),
                    _buildIconButton(Icons.business, developer.linkedin),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIconButton(IconData icon, String url) {
    return GestureDetector(
      onTap: () async {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          debugPrint("Could not launch $url");
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue[100],
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.blue[700], size: 24),
      ),
    );
  }
}
