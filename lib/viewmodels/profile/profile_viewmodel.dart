import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pawrtal/models/posts/post_model.dart';
import 'package:pawrtal/models/user/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_viewmodel.g.dart';

class ProfileViewModel {
  static final _db = FirebaseFirestore.instance;
  static final _storage = FirebaseStorage.instance.ref();

  final UserModel _profile;
  final UserModel _currUser;

  ProfileViewModel(this._profile, this._currUser);

  // get info to display onto page
  Map<String, dynamic> get profileInfo {
    return { 
      "name": _profile.displayName,
      "username": _profile.username,
      "pfp": _profile.pfp,
      "bio": _profile.bio,
      "banner": _profile.banner,
      "location": _profile.location,
      "followers": _profile.followerCount,
      "following": _profile.followingCount,
    };
  }

  bool get isCurrUserProfile => _profile.uid == _currUser.uid;
  
  // get posts for the user
  Stream<List<PostModel>> get posts {
    // gets the posts ordered in reverse chronological order
    log('${_profile.dbRef}');
    return _db.collection('posts')
      .where('poster', isEqualTo: _profile.dbRef)
      .orderBy('timestamp', descending: true)
      .snapshots()
      .asyncMap(
        (querySnapshot) async {
          var posts = <PostModel>[];
          for (var docSnapshot in querySnapshot.docs) {
            await PostModel.postFromSnapshot(docSnapshot).then((post) => posts.add(post));
          }
          final temp = [for (var p in posts) p.caption];
          log('homeposts: $temp');
          return posts;
        }
      ); 
  }

  // gets liked posts of the user excluding self likes
  Stream<List<PostModel>> get likedPosts {
    return _db.collection('posts')
      .where('likes', arrayContains: _profile.dbRef)
      .where('poster', isNotEqualTo: _profile.dbRef)
      .orderBy('timestamp', descending: true)
      .snapshots()
      .asyncMap(
        (querySnapshot) async {
          var posts = <PostModel>[];
          for (var docSnapshot in querySnapshot.docs) {
            await PostModel.postFromSnapshot(docSnapshot).then((post) => posts.add(post));
          }
          final temp = [for (var p in posts) p.caption];
          log('homeposts: $temp');
          return posts;
        }
      );
  }

  // get media from the user
  Stream<List<String>> get media {
    return posts.asyncMap((posts) async { 
      final images = <String>[];
      for (var post in posts) {
        images.addAll(post.images ?? const Iterable.empty());
      }
      log('$images');
      return images;
    });
  }

  Future<void> updateProfile(File? pfp, File? banner, String displayName, String username, String bio, String location) async { 
    // check for banner to upload 
    var bannerString = _currUser.banner;
    if (banner != null) {
      bannerString = await _storage.child('images/users/${_currUser.uid}-banner.png').putFile(banner).then((snapshot) =>
        snapshot.ref.getDownloadURL()
      );
    }

    // check for pfp to upload
    var pfpString = _currUser.pfp;
    if (pfp != null) {
      pfpString = await _storage.child('images/users/${_currUser.uid}-pfp.png').putFile(pfp).then((snapshot) =>
        snapshot.ref.getDownloadURL()
      );
    }

    final updated = {
      'displayName': displayName,
      'username': username,
      'bio': bio,
      'location': location,
      'banner': bannerString,
      'pfp': pfpString,
    };  
    
    _db.collection('users').doc(_currUser.uid).update(updated);
  }
}

@riverpod
class ProfileViewModelNotifier extends _$ProfileViewModelNotifier {
  @override
  Future<ProfileViewModel> build({required String uid}) async {
    log('getting user: $uid');
    final profile = await UserModel(uid).updated;
    final mainUser = ref.watch(appUserProvider).value!;
    return ProfileViewModel(profile, mainUser);
  }
}