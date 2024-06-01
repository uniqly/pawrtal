import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// TODO: Integrate with firebase auth
class UserModel {
  final String uid;
  final String? displayName;
  final String? handle;
  final String? pfp;
  final String? banner;
  final String? location;
  final String? bio;
  final int? followerCount;
  final int? followingCount;


  UserModel({required this.uid, this.displayName, this.handle, this.pfp, this.banner, 
      this.location, this.bio, this.followerCount, this.followingCount});

  static Future<UserModel> userFromFirebase(String uid) async {
    final storage = FirebaseStorage.instance.ref();
    final db = FirebaseFirestore.instance;
    final dataSnapshot = await db.collection('users').doc(uid).get();
    final data = dataSnapshot.data()!;
    return UserModel(
      uid: uid,
      displayName: data['displayName'] ,
      handle: data['handle'],
      pfp: await storage.child('images/users/$uid-pfp.png').getDownloadURL(),
      banner: await storage.child('images/users/$uid-banner.png').getDownloadURL(),
      location: data['location'],
      bio: data['bio'],
      followerCount: data['followers'],
      followingCount: data['following'],
    );
  }
}

