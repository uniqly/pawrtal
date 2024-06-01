import 'package:pawrtal/models/posts/post_model.dart';
import 'package:pawrtal/models/user/user_model.dart';
import 'package:pawrtal/test/test_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_viewmodel.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  Future<UserModel> build() async { 
    return ref.watch(mainUserProvider.future);
  }

  // Integrate post finding
  Stream<List<PostModel>> retrievePosts() async* { 
    final postIds = <String>['testpost', 'testpost2'];
    yield [ 
      for (var id in postIds) 
        await PostModel.postFromFirebase(id)
    ];
  }
}