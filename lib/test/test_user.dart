import 'package:pawrtal/test/placeholder_users.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'test_user.g.dart';

@riverpod
class MainUser extends _$MainUser {
  @override
  TestUser build() {
    return mainUser;
  }

  void incrFollows() {
    state = TestUser(state.uid, state.pfp, state.banner, state.displayName, 
      state.handle, state.location!, state.bio, state.followsCount + 1, state.followerCount);
  }
}