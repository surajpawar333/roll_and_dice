import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'constants.dart';

class FirebaseService {
  FirebaseService._internal();

  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- sign in, up and out
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e) {
      throw e;
    }
  }

  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e) {
      throw e;
    }
  }

  Future<void> addUser({required User user, required String username, required String email}) async {
    await user.updateDisplayName(username).then((value) {
      _firestore.collection('users').doc(user.uid).set({
        ConstantStrings.userName: username,
        ConstantStrings.email: email,
        ConstantStrings.attemptRemaining: 10,
        ConstantStrings.score: 0
      });
    });
  }

  Future<void> updateUser({required String userId, required int attemptRemaining, required int score}) async {
    _firestore.collection('users').doc(userId).set(
      {ConstantStrings.attemptRemaining: attemptRemaining, ConstantStrings.score: score},
      SetOptions(merge: true),
    );
  }

  Future<QuerySnapshot> getLeaderboard() async {
    return await _firestore
        .collection('users')
        .where(ConstantStrings.attemptRemaining, isEqualTo: 0)
        .orderBy(ConstantStrings.score, descending: true)
        .get();
  }

  Future<DocumentSnapshot> getUserDetails(String userId) async {
    return await FirebaseFirestore.instance.collection('users').doc(userId).get();
  }

  Future<void> signOut() async {
    // _snapshotService.setWasteLessLifeUserObject({});
    return _firebaseAuth.signOut();
  }
}
