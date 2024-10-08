import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth.g.dart';

enum AuthResult { success, takenUsername, alreadyExists, failure }
class AuthService {

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final _storage = FirebaseStorage.instance.ref();

  Future<String?> getCurrentUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    }
    return null; // Return null or handle appropriately if user is not authenticated
  }

  static Future<bool> checkUsernameExists(String username) async {
    // return true if username exists in Firestore
    final check = await _firestore.collection('users').where('username', isEqualTo: username).limit(1).get();
    return check.docs.isNotEmpty;
  }

  static Future<bool> checkEmailExists(String email) async {
    // return true if email already has an account
    final check = await _firestore.collection('users').where('email', isEqualTo: email).limit(1).get();
    return check.docs.isNotEmpty;
  }

  // sign in with username
  static Future<AuthResult> signInWithUsernameAndPassword(String input, String password) async {
    String email;
    // Check if the input is an email
    bool isEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(input);
    
    if (isEmail) {
      email = input;
      if (!await checkEmailExists(email)) { // email doesnt exist  
        return AuthResult.failure;
      }
    } else {
      // Fetch the email associated with the username
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: input)
          .limit(1)
          .get();

      if (userSnapshot.docs.isEmpty) { // username doesnt exist
        return AuthResult.failure;
      }

      email = userSnapshot.docs.first.get('email');
    }

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password); // attempt to log in
      return AuthResult.success;
    } catch (e) {
      log('invalid login: $e');
      return AuthResult.failure;
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
            'followerCount': 0,
            'followingCount': 0,
            'following': FieldValue.arrayUnion([]),
            'followers': FieldValue.arrayUnion([]),
            'notificationCount': 0,
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
  static Future<AuthResult> registerWithEmailandPassword(String email, String username, String password) async {
    if (await checkEmailExists(email)) {
      log('account already exists: $email');
      return AuthResult.alreadyExists;
    }
    else if (await checkUsernameExists(username)) {
      log('username: $username already exists, cannot create account');
      return AuthResult.takenUsername;
    }
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
          'following': FieldValue.arrayUnion([]),
          'followers': FieldValue.arrayUnion([]),
          'notificationCount': 0,
          'pfp': pfp,
          'banner': banner,
        });
      }
      
      return AuthResult.success;
    } catch(e) {
      log('error while registering: $e');
      return AuthResult.failure;
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