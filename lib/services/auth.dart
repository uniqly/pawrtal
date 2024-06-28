import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pawrtal/models/myuser.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth.g.dart';
class AuthService {

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final _storage = FirebaseStorage.instance.ref();

  // create user object based on FirebaseUser
  static MyUser? _userFromFirebaseUser(User? user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  // sign in anon
  static Future<MyUser?> signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously(); //AuthResult result = await _auth.signInAnonymously();
      User? user = result.user; // FirebaseUser user = result.user;
      return _userFromFirebaseUser(user!);
    } catch(e) {
      log('error on anon sign in: $e');
      return null;
    }
  }


  // sign in with username
  static Future<MyUser?> signInWithUsernameAndPassword(String input, String password) async {
    try {
      String email;
      // Check if the input is an email
      bool isEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(input);
      
      if (isEmail) {
        email = input;
      } else {
        // Fetch the email associated with the username
        final userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: input)
            .limit(1)
            .get();

        if (userSnapshot.docs.isEmpty) {
          throw FirebaseAuthException(
            code: 'user-not-found',
            message: 'No user found for that username.',
          );
        }

        email = userSnapshot.docs.first.get('email');
      }

      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      log('error on username sign in: $e');
      return null;
    }
  }

  // sign in with google 
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return null; // User aborted the sign in process
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      // Check if user data exists in Firestore
      if (user != null) {
        final pfp = await _storage.child('images/users/default-pfp.png').getDownloadURL();
        final banner = await _storage.child('images/users/default-banner.png').getDownloadURL();
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          // If user data does not exist, add it to Firestore
          await _firestore.collection('users').doc(user.uid).set({
            'displayName': user.displayName,
            'username': user.uid,
            'email': user.email,
            'createdAt': FieldValue.serverTimestamp(),
            'location': '',
            'bio': '',
            'followers': 0,
            'following': 0,
            'pfp': pfp,
            'banner': banner,
          });
        }
      }

      return userCredential;
    } catch (e) {
      log('error on google sign in: $e');
      return null;
    }
  }

  // register with email and password
  static Future<MyUser?> registerWithEmailandPassword(String email, String username, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      // Update user profile with username
      if (user != null) {
        await user.updateDisplayName(username);
        await user.reload();
        user = _auth.currentUser;

        final pfp = await _storage.child('images/users/default-pfp.png').getDownloadURL();
        final banner = await _storage.child('images/users/default-banner.png').getDownloadURL();
        
        // Store user information in Firestore
        await _firestore.collection('users').doc(user?.uid).set({
          'displayName': username,
          'username': username,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
          'location': '',
          'bio': '',
          'followerCount': 0,
          'followingCount': 0,
          'pfp': pfp,
          'banner': banner,
        });
      }
      
      return _userFromFirebaseUser(user);
    } catch(e) {
      log('error while registering: $e');
      return null;
    }
  }

  // sign out
  static Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      log('error while signing out: $e');
    }
  }

}

@riverpod
Stream<User?> authUser(AuthUserRef ref) {
  return FirebaseAuth.instance.authStateChanges();
}