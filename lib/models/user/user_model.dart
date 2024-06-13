import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// TODO: Integrate with firebase auth
class UserModel {
  static final _db = FirebaseFirestore.instance;
  static final _storage = FirebaseStorage.instance.ref();

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

  DocumentReference get dbRef {
    return _db.collection('users').doc(uid);
  }

  static Future<UserModel> userFromFirebase(String uid) async {
    final dataSnapshot = await _db.collection('users').doc(uid).get();
    final data = dataSnapshot.data()!;
    
    return UserModel(
      uid: uid,
      displayName: data['displayName'] ,
      handle: data['handle'],
      pfp: await _storage.child('images/users/$uid-pfp.png').getDownloadURL().onError((e, s) => ''),
      banner: await _storage.child('images/users/$uid-banner.png').getDownloadURL().onError((e, s) => ''),
      location: data['location'],
      bio: data['bio'],
      followerCount: data['followers'],
      followingCount: data['following'],
    );
  }

  UserModel copyWith({String? displayName, String? handle, String? bio, String? location,
      String? pfp, String? banner, int? followerCount, int? followingCount}) {
    return UserModel( 
      uid: uid,
      displayName: displayName ?? this.displayName,
      handle: handle ?? this.handle,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      pfp: pfp ?? this.pfp,
      banner: banner ?? this.banner,
      followerCount: followerCount ?? this.followerCount,
      followingCount: followingCount ?? this.followingCount
    );
  }
}

