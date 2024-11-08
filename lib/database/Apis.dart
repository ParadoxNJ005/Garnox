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

      // Log the whole JSON response
      log("Complete JSON Data: ${jsonEncode(allData)}");

      querySnapshot.docs.forEach((doc) async {
        try {
          var jsonData = doc.data();
          var subject = SpecificSubject.fromJson(jsonData);
          var encodedSubject = jsonEncode(subject.toJson());

          await storage.write(key: subject.subjectCode, value: encodedSubject);
          // log("${subject.subjectCode} : ${encodedSubject}");
        } catch (e) {
          print('Error writing to secure storage: $e');
        }}
      );


    }catch(e){
      log("fetchAllSubjects Error: $e");
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
        log("Thala For a Reason : ${res}");
      } else {
        log("NO Sem Subject Data FOUND {Failed to load SemSubjectName}");
      }
    });
  }

//-----------------------------Fetch the user data-------------------------------------------------//
  static Future<void> myInfo() async{
    log("${user_uid}");
    final storage = new FlutterSecureStorage();
    await firestore.collection('user').doc(user_uid).get().then((user) async {
      if (user.exists) {

        me = ChatUser.fromJson(user.data()!);
        var res = (ChatUser.fromJson(user.data()!)).toJson();
        await storage.write(key: "me", value: jsonEncode(res));
        log("${me!.imageUrl}");
      } else {
        log("NO SUCH USER FOUND {Failed to load myINFO}");
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
        log("Hey this is me: ${me}");
      } else {
        await myInfo();
      }

      int yearName = me!.batch!;

      String? stringofsemSubjectName = await storage.read(key: "${yearName}");
      if (stringofsemSubjectName != null) {
        log("Heisenburg");
        Map<String, dynamic> jsonData = jsonDecode(stringofsemSubjectName);
        semSubjectName = SemViseSubject.fromJson(jsonData);
        log(jsonEncode(semSubjectName));
      } else {
        await fetchSemSubjectName();
      }

      String? stringofsemAllSubjects = await storage.read(key: "LAL");
      if (stringofsemAllSubjects != null){
        log("Mahatma Gandhi");
        // Map<String, dynamic> jsonData = jsonDecode(stringofsemAllSubjects);
        // semSubjectName = SemViseSubject.fromJson(jsonData);
        // log("Hey this is SemALLSubjects : ${semSubjectName}");
      }else{
        await fetchAllSubjects();
      }

    } catch (e) {
      log("NO SUCH Offline User FOUND {Failed to load offline Info ${e}}");
    }
  }

//-----------------------------check user exists-----------------------------------//
  static Future<bool> userExists() async {
    final user = auth.currentUser;
    // log("hello bro");
    if (user != null) {
      // log("what are you doing ${user.uid}");
      final doc = await firestore.collection('user').doc(user.uid).get();
      return doc.exists;
    }
    return false;
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

//-----------------------------check user-----------------------------------//
  static Future<void> createUser(String collName, String id, String email, String name) async {
    try {
      await FirebaseFirestore.instance.collection(collName).doc(id).set({
        'name': name,
        'email': email,
        'uid': id,
      });
    } catch (e) {
      log('Error creating user: $e');
    }
  }

//-----------------------------Signup-----------------------------------//
  static Future<void> signup(String email, String password, String firstname, String lastname) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid;
      String name = '$firstname $lastname';

      await createUser("user", uid, email, name);

      await signin(email, password);

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log("Weak password");
      } else if (e.code == 'email-already-in-use') {
        log("Email already in use");
      } else {
        log("Firebase Auth Exception: ${e.code}");
      }
    } catch (e) {
      log('Error during signup: $e');
    }
  }

//-----------------------------Sign IN-----------------------------------//
  static Future<void> signin(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      await myInfo();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
      } else {
        log('Firebase Auth Exception: ${e.code}');
      }
    } catch (e) {
      log('Error during signin: $e');
    }
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
      log('\n_signInWithGoogle: $e');
      return null;
    }
  }

//-----------------------------Fetch All Semister wise subjects-----------------------------------//
  static Stream<QuerySnapshot<Map<String, dynamic>>> semViseSubjects() {
    try {
      int year = me!.batch!;
      final stream = APIs.firestore.collection('Data')
          .where('yearName', isEqualTo: year.toString())
          .snapshots();
      stream.listen((snapshot) {
        for (var doc in snapshot.docs) {
          log("Document data: ${jsonEncode(doc.data())}");
        }
      });
      return stream;
    } catch (e) {
      log("Error getting document stream: $e");
      // Return an empty stream in case of an error
      return const Stream.empty();
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

        log("College Details Updated");
      }catch(e){
        log("Error in updating college details: ${e}");
      }
  }

//----------------------------Sign Out User From the Application-----------------------------------//
  static Future<void> Signout() async{
    final storage =  new FlutterSecureStorage();
    await storage.delete(key: "me");
    await storage.delete(key: "${APIs.me!.batch}");

    await auth.signOut();
  }
}
