import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawrtal/models/posts/post_model.dart';
import 'package:pawrtal/models/user/user_model.dart';
import 'package:pawrtal/test/test_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_viewmodel.g.dart';

class ProfileViewModel {
  static final _db = FirebaseFirestore.instance;

  final UserModel _profile;
  final UserModel _currUser;

  ProfileViewModel(this._profile, this._currUser);

  // get info to display onto page
  Map<String, dynamic> get profileInfo {
    return { 
      "name": _profile.displayName,
      "username": _profile.username,
      "pfp": _profile.pfp,
      "bio": _profile.bio!.isNotEmpty ? _profile.bio : '- empty bio -',
      "banner": _profile.banner,
      "location": _profile.location!.isNotEmpty ? _profile.bio : 'unknown location',
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
  
  // get media from the user
  Stream<List<String>> get media {
    return posts.asyncMap((posts) async { 
      final images = <String>[];
      for (var post in posts) {
        images.addAll(await post.postImages ?? const Iterable.empty());
      }
      log('$images');
      return images;
    });
  }

}

@riverpod
class ProfileViewModelNotifier extends _$ProfileViewModelNotifier {
  @override
  Future<ProfileViewModel> build({required String uid}) async {
    log('getting user: $uid');
    final profile = await UserModel(uid).updated;
    final mainUser = await ref.watch(mainUserProvider.future);
    return ProfileViewModel(profile, mainUser);
  }
}