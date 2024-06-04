import 'dart:developer';

import 'package:pawrtal/models/posts/post_model.dart';
import 'package:pawrtal/models/user/user_model.dart';
import 'package:pawrtal/test/test_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_viewmodel.g.dart';

class ProfileViewModel {
  final UserModel _profile;
  final UserModel _currUser;

  ProfileViewModel(this._profile, this._currUser);

  // get info to display onto page
  Map<String, dynamic> get profileInfo {
    return { 
      "name": _profile.displayName,
      "handle": _profile.handle,
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
  Stream<List<PostModel>> get posts async* {
    throw UnimplementedError();
  }
  
  // get media from the user
  Stream<List<String>> get media async* {
    throw UnimplementedError();
  }

}

@riverpod
class ProfileViewModelNotifier extends _$ProfileViewModelNotifier {
  @override
  Future<ProfileViewModel> build({required String uid}) async {
    log('getting user: $uid');
    final profile = await UserModel.userFromFirebase(uid);
    final mainUser = await ref.watch(mainUserProvider.future);
    return ProfileViewModel(profile, mainUser);
  }
}