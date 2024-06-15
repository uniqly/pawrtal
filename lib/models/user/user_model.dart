import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pawrtal/services/auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_model.g.dart';

// TODO: Integrate with firebase auth
class UserModel {
  static final _db = FirebaseFirestore.instance;
  static final _storage = FirebaseStorage.instance.ref();

  final String uid;
  String? _displayName;
  String? get displayName => _displayName;
  String? _username;
  String? get username => _username;
  String? _pfp;
  String? get pfp => _pfp;
  String? _banner;
  String? get banner => _banner;
  String? _location;
  String? get location => _location;
  String? _bio;
  String? get bio => _bio;
  int? _followerCount;
  int? get followerCount => _followerCount;
  int? _followingCount;
  int? get followingCount => _followingCount;

  UserModel(this.uid);

  static Future<UserModel> fromSnapshot({required String uid, required DocumentSnapshot<Map<String, dynamic>> snapshot}) async {
    final user = UserModel(uid);
    user._username = snapshot['username'] ?? '<NULL>';
    user._location = snapshot['location'] ?? '';
    user._bio = snapshot['bio'] ?? '';
    user._followerCount = snapshot['followers'] ?? 0;
    user._followingCount = snapshot['following'] ?? 0;
    user._pfp = await _storage.child('images/users/$uid-pfp.png').getDownloadURL().onError((e, s) => '');
    user._banner = await _storage.child('images/users/$uid-banner.png').getDownloadURL().onError((e, s) => '');
    return user;
  }

  DocumentReference get dbRef {
    return _db.collection('users').doc(uid);
  }


  Future<UserModel> get updated async {
    final dataSnapshot = await _db.collection('users').doc(uid).get();
    if (dataSnapshot.data() != null) {
      final data = dataSnapshot.data()!;
      
      _displayName = data['displayName'];
      _username = data['username'];
      _pfp = await _storage.child('images/users/$uid-pfp.png').getDownloadURL().onError((e, s) => '');
      _banner = await _storage.child('images/users/$uid-banner.png').getDownloadURL().onError((e, s) => '');
      _location = data['location'];
      _bio = data['bio'];
      _followerCount = data['followers'];
      _followingCount = data['following'];
    }

    return this;
  }

  @override
  String toString() {
    return 'user: $uid, $_displayName, $_username, $_bio, $_location, $_banner, $_followerCount, $_followingCount';
  }
}

@riverpod
Stream<UserModel?> appUser(AppUserRef ref) async* { 
  final auth = ref.watch(authUserProvider);
  final user = auth.value;
  if (user != null) {
    yield* FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots().asyncMap((snapshot) { 
      if (snapshot.exists) {
        return UserModel.fromSnapshot(uid: user.uid, snapshot: snapshot);
      } else {
        return null;
      }
    });
  } else {
   yield null;
  }
}