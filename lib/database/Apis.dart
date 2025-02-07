import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/SemViseSubModel.dart';
import '../models/SpecificSubjectModel.dart';
import '../models/chatuser.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static User get user=> auth.currentUser!;                          //google user
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static ChatUser? me;  //my info
  static SemViseSubject? semSubjectName;
  static SpecificSubject? allSubject;                              //no usage
  static final user_uid = auth.currentUser!.uid;

//--------------FETCH ALL SUBJECTS DATA AND STORE IT INTO LOCAL STORAGE--------------------------------------------//
  static Future<void> fetchAllSubjects() async {
    final storage = new FlutterSecureStorage();
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Subjects')
          .get();

      // Convert each document's data into a plain Map and then into a list
      List<Map<String, dynamic>> allData = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      querySnapshot.docs.forEach((doc) async {
        try {
          var jsonData = doc.data();
          var subject = SpecificSubject.fromJson(jsonData);
          var encodedSubject = jsonEncode(subject.toJson());
          await storage.write(key: subject.subjectCode, value: encodedSubject);
        } catch (e) {
        }}
      );


    }catch(e){
    }
  }

  static Future<UserCredential?> signupWithEmailAndPassword(
     String name, String email, String password) async {
    try {
      UserCredential userCredential =
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot userDoc =
        await firestore.collection('user').doc(user.uid).get();

        ChatUser chatUser;
        if (!userDoc.exists) {
          chatUser = ChatUser(
            uid: user.uid,
            batch: 2026,
            branch: "ITBI",
            college: "IIIT Allahabad",
            semester: 1,
            name: name ?? "A",
            email: user.email ?? email,
            imageUrl: "",
          );
          await firestore.collection('user').doc(user.uid).set(chatUser.toJson());
          // const storage = FlutterSecureStorage();
          // await storage.write(key: 'me' ,value: jsonEncode(chatUser.toJson()));
        }
      }
      return userCredential;
    } catch (e) {
      return null;
    }
  }

//--------------Login User through email and password-----------------------------------------------------//
  static Future<UserCredential?> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        DocumentSnapshot userDoc =
        await firestore.collection('user').doc(user.uid).get();

        ChatUser chatUser;
        if (!userDoc.exists) {
          chatUser = ChatUser(
            uid: user.uid,
            batch: 2026,
            branch: "ITBI",
            college: "IIIT Allahabad",
            semester: 1,
            name: user.displayName ?? "Anonymous",
            email: user.email ?? email,
            imageUrl: user.photoURL ?? "",
          );
          await firestore.collection('user').doc(user.uid).set(chatUser.toJson());
        } else {
          final data = userDoc.data() as Map<String, dynamic>;
          chatUser = ChatUser.fromJson(data);
        }
        // final storage = new FlutterSecureStorage();
        // await storage.write(key: 'me' ,value: jsonEncode(chatUser.toJson()));
      }
      return userCredential;
    } catch (e) {
      return null;
    }
  }

//--------------FETCH ALL SUBJECTS Name Based on the Semester AND STORE IT INTO LOCAL STORAGE--------------------------------------------//
  static Future<void> fetchSemSubjectName() async{

    int yearName = me!.batch!;
    int semesterName = me!.semester!;
    String branchName = me!.branch!;
    String keyName = "${yearName}";

    final storage = new FlutterSecureStorage();
    await firestore.collection('Data').doc(yearName.toString()).get().then((user) async {
      if (user.exists) {

        semSubjectName = SemViseSubject.fromJson(user.data()!);
        var res = (SemViseSubject.fromJson(user.data()!)).toJson();
        await storage.write(key: keyName, value: jsonEncode(res));
      } else {
      }
    });
  }

//-----------------------------Fetch the user data-------------------------------------------------//
  static Future<void> myInfo() async{
    final storage = new FlutterSecureStorage();
    await firestore.collection('user').doc(user_uid).get().then((user) async {
      if (user.exists) {

        me = ChatUser.fromJson(user.data()!);
        var res = (ChatUser.fromJson(user.data()!)).toJson();
        await storage.write(key: "me", value: jsonEncode(res));
      } else {
      }
    });
  }

//-----------------------------If User Exists Store All the Data From Local Storage to me-------------------//
  static Future<void> offlineInfo() async {
    final storage = new FlutterSecureStorage();

    try {
      String? stringOfItems = await storage.read(key: "me");
      if (stringOfItems != null) {
        Map<String, dynamic> jsonData = jsonDecode(stringOfItems);
        me = ChatUser.fromJson(jsonData);
      } else {
        await myInfo();
      }

      int yearName = me!.batch!;

      String? stringofsemSubjectName = await storage.read(key: "${yearName}");
      if (stringofsemSubjectName != null) {
        Map<String, dynamic> jsonData = jsonDecode(stringofsemSubjectName);
        semSubjectName = SemViseSubject.fromJson(jsonData);
      } else {
        await fetchSemSubjectName();
      }

      String? stringofsemAllSubjects = await storage.read(key: "LAL");
      if (stringofsemAllSubjects != null){
      }else{
        await fetchAllSubjects();
      }

    } catch (e) {
    }
  }

//-----------------------------check user exists-----------------------------------//
  static Future<bool> userExists() async {
    final user = auth.currentUser;
    if (user != null) {
      final doc = await firestore.collection('user').doc(user.uid).get();
      return doc.exists;
    }
    return false;
  }

  static Future<bool> checkEmailExistsInFirestore(String email) async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

//-----------------------------create user through google-----------------------------------//
  static Future<void> createGoogleUser() async {
    final chatUser = ChatUser(
        uid: user.uid,
        batch: 2026,
        branch: "ECE",
        college: "IIIT Allahabad",
        semester: 1,
        name: user.displayName.toString(),
        email: user.email.toString(),
        imageUrl: user.photoURL.toString());

    return await firestore
        .collection('user')
        .doc(user.uid)
        .set(chatUser.toJson());
  }


//-----------------------------Google Sign IN-----------------------------------//
  static Future<UserCredential?> googleSignIn()async{
    try{
      await InternetAddress.lookup('google.com');

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await auth.signInWithCredential(credential);
    } catch (e) {
      return null;
    }
  }

//-----------------------------Fetch the user data-------------------------------------------------//
  static Future<void> updateCollegeDetails(int batch , String branch , int semester) async{

      try{
        await firestore.collection("user").doc(user_uid).update({
          "batch" : batch,
          "branch" : branch,
          "college" : "IIIT Allahabad",
          "semester" : semester,
        });
      }catch(e){
      }
  }

//----------------------------Sign Out User From the Application-----------------------------------//
  static Future<void> Signout() async{
    final storage =  new FlutterSecureStorage();
    await storage.delete(key: "me");
    await storage.delete(key: "${APIs.me!.batch}");
    await storage.delete(key: "recents");
    await auth.signOut();
  }

  //----------------------------Notification Display Api--------------------------------------------//
  static Future<List<Map<String, dynamic>>> fetchNotifications() async {
    try {
      final notifications = <Map<String, dynamic>>[];

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Notification')
          .orderBy('time', descending: true)
          .get();
      for (var doc in snapshot.docs) {
        notifications.add(doc.data() as Map<String, dynamic>);
      }

      return notifications;
    } catch (e) {
      return [];
    }
  }
}
