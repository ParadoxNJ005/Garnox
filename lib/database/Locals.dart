import 'dart:convert';
import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/SemViseSubModel.dart';
import '../models/SpecificSubjectModel.dart';
import '../models/recentsModel.dart';

class LOCALs{

    static final local_storage = new FlutterSecureStorage();
    static List<Recents> finalSeachDataList = [];

    //-------------------Store the Recents Documents------------------------//
    static Future<void> recents(String title, String url, String type) async {

      String? stringOfItems = await local_storage.read(key: 'recents');
      if (stringOfItems != null) {
        List<dynamic> listOfItems = jsonDecode(stringOfItems);

        Map<String, String> newItem = {'Title': title, 'URL': url, 'Type': type};
        listOfItems.add(newItem);

        await local_storage.write(key: 'recents', value: jsonEncode(listOfItems));

        String? updatedStringOfItems = await local_storage.read(key: 'recents');
        List<dynamic> updatedListOfItems = jsonDecode(updatedStringOfItems!);

        log("$updatedListOfItems");
      } else {
        List<Map<String, String>> listOfItems = [];

        Map<String, String> newItem = {'Title': title, 'URL': url, 'Type': type};
        listOfItems.add(newItem);

        await local_storage.write(key: 'recents', value: jsonEncode(listOfItems));

        String? updatedStringOfItems = await local_storage.read(key: 'recents');
        List<dynamic> updatedListOfItems = jsonDecode(updatedStringOfItems!);

        log("$updatedListOfItems");
      }

      await LOCALs.fetchRecents();
    }

    //-------------------Fetch ALL Recents Documents from local storage---------//
    static Future<List<Recents>> fetchRecents() async {
      String? stringOfItems = await local_storage.read(key: "recents");
      if (stringOfItems != null) {
        List<dynamic> listOfItems = jsonDecode(stringOfItems);
        List<Recents> recentsList = listOfItems.map((item) => Recents.fromJson(item)).toList();

        final seenTitles = <String>{};
        recentsList = recentsList.where((recents) => seenTitles.add(recents.Title)).toList();

        return recentsList;
      } else {
        return [];
      }
    }


    //----------------------Launch Url-----------------------------------------//
    /*
          Currently this will not work as permissions are not given
     */
    static Future<void> launchURL(String url) async {
      try {
        if (await canLaunch(url)) {
          await launch(url, forceSafariVC: false);
        } else {
          throw 'Could not launch $url';
        }
      } catch (e) {
        log('Error launching URL: $e');
        throw 'Could not launch $url';
      }
    }

    //----------------Implement Search Functionality----------------------------//
    static Future<void> MakeSearchFunctionality() async {
      try {
        // Getting data from DATA Collection
        List<String> finalSearchSubjectList = [];

        // For 2026 batch   UPDATE THIS FOR LOOP WHEN YOU ADD OTHER BATCH DETAILS
        for (var i = 2025; i <= 2028; i++) {
          String yearName = i.toString();
          String? updatedStringOfItems = await local_storage.read(key: yearName);
          if (updatedStringOfItems != null) {
            var decodedJson = jsonDecode(updatedStringOfItems);
            if (decodedJson is Map<String, dynamic>) {
              var subject = SemViseSubject.fromJson(decodedJson);

              // Extract and process the ece subjects
              if (subject.ece != null) {
                subject.ece!.forEach((eceItem) {
                  finalSearchSubjectList.add(eceItem.split('_').last);
                });
              }

              // Extract and process the IT subjects
              if (subject.it != null) {
                subject.it!.forEach((eceItem) {
                  finalSearchSubjectList.add(eceItem.split('_').last);
                });
              }

              // Extract and process the IT-BI subjects
              if (subject.itBi != null) {
                subject.itBi!.forEach((eceItem) {
                  finalSearchSubjectList.add(eceItem.split('_').last);
                });
              }

              finalSearchSubjectList = finalSearchSubjectList.toSet().toList();

              // log('Final Search Subject List: $finalSearchSubjectList');
            } else {
              log('Error: Decoded JSON is not a map');
            }
          } else {
            log('Error: Updated String of Items is null');
          }
        }

        // For Navigating for each subject
        for (var i = 0; i < finalSearchSubjectList.length; i++) {
          String sub = finalSearchSubjectList[i];
          String? updatedStringOfItems2 = await local_storage.read(key: sub);
          // log("update sub : $sub => $updatedStringOfItems2");
          if (updatedStringOfItems2 != null) {
            var decodedJson2 = jsonDecode(updatedStringOfItems2);
            if (decodedJson2 is Map<String, dynamic>) {
              var subject2 = SpecificSubject.fromJson(decodedJson2);

              // Extract and process the Materials subjects
              if (subject2.material != null) {
                subject2.material.forEach((item) {
                  Recents newItem = Recents(
                      Title: item.title,
                      URL: item.contentURL,
                      Type: "material"
                  );
                  finalSeachDataList.add(newItem);
                });
              }

              // Extract and process the Important Links subjects
              if (subject2.importantLinks != null) {
                subject2.importantLinks.forEach((item) {
                  Recents newItem = Recents(
                      Title: item.title,
                      URL: item.contentURL,
                      Type: "links"
                  );
                  finalSeachDataList.add(newItem);
                });
              }

              // Extract and process the Question Papers subjects
              if (subject2.questionPapers != null) {
                subject2.questionPapers.forEach((item) {
                  Recents newItem = Recents(
                      Title: item.title,
                      URL: item.url,
                      Type: "papers"
                  );
                  finalSeachDataList.add(newItem);
                });
              }

              finalSeachDataList = finalSeachDataList.toSet().toList();

              // log('Final Search DATA List: $finalSeachDataList');
            } else {
              log('Error: Decoded JSON is not a map');
            }
          } else {
            log('Error: Updated String of Items is null');
          }
        }
      } catch (e) {
        log('Error in Making Search Functionality: $e');
        throw 'me toh tut gya, barbaad ho gya';
      }
    }


}