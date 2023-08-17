import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'usersettings.dart';
//import 'package:firebase_storage/firebase_storage.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  //final _storage = FirebaseStorage.instance;

//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
//                   Google sign in logic!!!
//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

  final _googleSignIn = GoogleSignIn();

  signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);
        await _auth.signInWithCredential(authCredential);
        UserProvider().userID = _auth.currentUser!.uid; //neccesary?
      }
    } on FirebaseAuthException catch (error) {
      print(error.message); //remove on release
      //add notification about error!
      rethrow;
    }
  }

  googleSignOut() async {
    UserProvider().userID = '';
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  getUserId() {
    return _auth.currentUser!.uid;
  }

  setUserId() {
    UserProvider().userID = _auth.currentUser!.uid;
  }

//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
//     Fetches VerbGame Data
//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

  late List sentences;

  Future<List> getFindMistakesData() async {
    final snapshot = await _db
        .collection(UserSettings.getClassKey()) //class key identifier
        .doc('sentenceData')
        .get();
    final sentenceMap = snapshot.data()?['sentenceMap'] ??
        ["null"]; //return null map if error with retreiving sentenceMap

    return sentenceMap;
  }

//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
//         Fetches and stores data for the Verb game!
//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

  late List questions; 
  
}









//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
//     Fetches and stores data for the Find the Mistakes game!
//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

class SentenceData {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List> getData() async {
    final snapshot =
        await _firestore.collection('FindMistakes').doc('sentenceData').get();
    final sentenceMap = snapshot.data()?['sentenceMap'] ?? [];

    sentences = sentenceMap;
    return sentences;
  }

  static late List sentences;
}

//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
//         Fetches and stores data for the Verb game!
//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

class VerbData {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List> getData() async {
    final snapshot =
        await _firestore.collection('VerbGame').doc('verbData').get();
    final verbData = snapshot.data()?['verbMap'] ?? [];

    questions = verbData;
    return verbData;
  }

  static late List questions;
}
