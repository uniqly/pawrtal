import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pawrtal/models/portals/portal_model.dart';
import 'package:pawrtal/models/posts/post_model.dart';
import 'package:pawrtal/models/user/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_viewmodel.g.dart';

class ProfileViewModel {
  static final _db = FirebaseFirestore.instance;
  static final _storage = FirebaseStorage.instance.ref();

  final UserModel profile;
  final UserModel currUser;

  ProfileViewModel(this.profile, this.currUser);

  // get info to display onto page
  bool get isCurrUserProfile => profile.uid == currUser.uid;
  
  bool get isUserFollowingProfile => currUser.isFollowing(profile);

  Future<void> toggleFollow() async {
    // for some reason, updaing curruser first then profile causes desync issues
    // might be due to viewmodel reloading immediately on updating curr user
    log('toggle follow');
    if (isUserFollowingProfile) {
      log('toggle follow: unfollow');
      await profile.removeFollower(currUser);
      await currUser.unfollow(profile);
    } else {
      log('toggle follow: follow');
      await profile.addFollower(currUser);
      await currUser.follow(profile);
      log('toggle follow after: $profile');
    }
    log('toggle follow: ${profile.followerCount}');
  }

  // get posts for the user
  Stream<List<PostModel>> get posts {
    // gets the posts ordered in reverse chronological order
    log('${profile.dbRef}');
    return _db.collection('posts')
      .where('poster', isEqualTo: profile.dbRef)
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
      .where('likes', arrayContains: profile.dbRef)
      .where('poster', isNotEqualTo: profile.dbRef)
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

  Stream<List<PostModel>> get bookmarkedPosts {
    return _db.collection('posts')
      .where('bookmarks', arrayContains: profile.dbRef)
      .orderBy('timestamp', descending: true)
      .snapshots()
      .asyncMap((querySnapshot) async { 
        final posts = <PostModel>[];
        for (var docSnapshot in querySnapshot.docs) {
          posts.add(await PostModel.postFromSnapshot(docSnapshot));
        }
        return posts;
      });
  }

  // get media from the user
  Stream<List<String>> get media {
    return posts.asyncMap((posts) async { 
      final images = <String>[];
      for (var post in posts) {
        images.addAll(post.images);
      }
      log('$images');
      return images;
    });
  }

  Stream<List<PortalModel>> get portals {
    return _db.collection('portals')
      .where('members', arrayContains: profile.dbRef)
      .orderBy('memberCount', descending: true)
      .snapshots()
      .asyncMap( 
        (querySnapshot) async {
          var portals = <PortalModel>[];
          for (var documentSnapshot in querySnapshot.docs) {
            await PortalModel.portalFromSnapshot(documentSnapshot).then((portal) => portals.add(portal));
          }
          log('$portals');
          return portals;
        }
      );
  }

  Future<void> updateProfile(File? pfp, File? banner, String displayName, String username, String bio, String location) async { 
    // check for banner to upload 
    var bannerString = currUser.banner;
    if (banner != null) {
      bannerString = await _storage.child('images/users/${currUser.uid}-banner.png').putFile(banner).then((snapshot) =>
        snapshot.ref.getDownloadURL()
      );
    }

    // check for pfp to upload
    var pfpString = currUser.pfp;
    if (pfp != null) {
      pfpString = await _storage.child('images/users/${currUser.uid}-pfp.png').putFile(pfp).then((snapshot) =>
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
    
    await _db.collection('users').doc(currUser.uid).update(updated);
  }
}

@riverpod
class ProfileViewModelNotifier extends _$ProfileViewModelNotifier {
  @override
  Future<ProfileViewModel> build({required String uid}) async {
    log('getting user: $uid');
    final profile = await UserModel(uid).updated;
    final currUser = ref.watch(appUserProvider).value!;
    return ProfileViewModel(profile, currUser);
  }
}