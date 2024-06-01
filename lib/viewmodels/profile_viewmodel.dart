import 'package:pawrtal/models/user/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_viewmodel.g.dart';

@riverpod
class ProfileViewModel extends _$ProfileViewModel {
  @override
  Future<UserModel> build({required String uid}) async {
    return UserModel.userFromFirebase(uid);
  }
}