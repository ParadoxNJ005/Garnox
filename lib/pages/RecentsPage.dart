import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart'; // Added for clipboard functionality
import 'package:sembreaker/pages/SearchPage.dart';
import 'package:url_launcher/url_launcher.dart'; // Added for launching URLs
import '../components/Custom_navDrawer.dart';
import '../components/custom_helpr.dart';
import '../components/nocontent_animatedtext.dart';
import '../database/Locals.dart';
import '../models/recentsModel.dart';
import '../utils/contstants.dart';
import 'package:share_plus/share_plus.dart';

import 'NotificationPage.dart';
import 'OpenPdf.dart';

class RecentsPage extends StatefulWidget {
  const RecentsPage({super.key});

  @override
  State<RecentsPage> createState() => _RecentsPageState();
}

class _RecentsPageState extends State<RecentsPage> {
  final storage = FlutterSecureStorage();
  bool _isSearching = false;
  List<Recents> _list = [];

  @override
  void initState() {
    super.initState();
    // _requestPermissions();
  }

  // Future<void> _requestPermissions() async {
  //   var status = await Permission.storage.status;
  //   if (!status.isGranted) {
  //     if (await Permission.storage.request().isGranted) {
  //       log("Storage permission granted");
  //     } else {
  //       log("Storage permission denied");
  //     }
  //   } else {
  //     log("Storage permission already granted");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Recents',
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
              Navigator.push(context, MaterialPageRoute(builder: (_)=>NotificationScreen()));
            },
          ),
        ],
      ),
      drawer: CustomNavDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>const SearchPage()));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search subjects...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  // onChanged: (text) {
                  //   setState(() {
                  //     _isSearching = text.isNotEmpty;
                  //   });
                  //   // Implement search logic here
                  // },
                ),
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
                    return Expanded(child: NoContentAnimatedText());
                  } else {
                    return Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: _list.map((subName) {
                            return _fileCard(subName);
                          }).toList(),
                        ),
                      ),
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
      ),
    );
  }

  Widget _fileCard(Recents temp) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: InkWell(
        onTap: () async {
          // log("${temp.Type} ${temp.URL}");
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
                log("File icon pressed");
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
              constraints: BoxConstraints(maxWidth: 40), // Ensure the trailing icon is properly sized
              child: PopupMenuButton<String>(
                onSelected: (value) async {
                  log("Popup menu item selected: $value");
                  switch (value) {
                    case 'share':
                      // log("Copying link to clipboard");
                      Share.share("Here is the Url of ${temp.Title} \n ${temp.URL}");
                      // Clipboard.setData(ClipboardData(text: temp.URL));
                      // Dialogs.showSnackbar(context, "🔗 Link copied to clipboard!");
                      break;
                    case 'download':
                      // log("Download selected");
                      Clipboard.setData(ClipboardData(text: temp.URL));
                      Dialogs.showSnackbar(context, "🔗 Link copied to clipboard!");
                      await _showDownloadInstructions(temp.URL);
                      break;
                  }
                },
                itemBuilder: (BuildContext context) {
                  log("Building popup menu items");
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
                        leading: Icon(Icons.download_sharp, color: Constants.APPCOLOUR),
                        title: Text("Download"),
                      ),
                    ),
                  ];
                },
                onCanceled: () {
                  log("Popup menu canceled");
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
        await launch(url, forceSafariVC: false, forceWebView: false); // Open in default browser (Chrome)
        log("URL opened in browser");
      } else {
      }
    } catch (e) {
      log("Error opening URL: $e");
    }
  }
}
