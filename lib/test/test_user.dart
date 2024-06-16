import 'package:pawrtal/models/user/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'test_user.g.dart';

// Test user
@riverpod 
class MainUser extends _$MainUser {
  @override
  Future<UserModel> build() {
    return UserModel('mainuser').updated;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async { 
      return state.value!.updated;
    });
  }
}