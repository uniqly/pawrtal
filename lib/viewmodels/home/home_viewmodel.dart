import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawrtal/models/posts/post_model.dart';
import 'package:pawrtal/models/user/user_model.dart';
import 'package:pawrtal/test/test_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_viewmodel.g.dart';

class HomeViewModel {
  final UserModel user;

  HomeViewModel(this.user);

  Stream<List<PostModel>> get posts async* {
    final db = FirebaseFirestore.instance;
    var posts = <PostModel>[];
    await db.collection('posts').get().then(
      (querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          await PostModel.postFromSnapshot(docSnapshot).then((post) => posts.add(post));
        }
        log('postss: $posts');
      }
    ); 
    log('posts: $posts');
    yield posts;
  }  
}

@riverpod
class HomeViewModelNotifier extends _$HomeViewModelNotifier {
  @override
  Future<HomeViewModel> build() async { 
    final user = await ref.watch(mainUserProvider.future);
    return HomeViewModel(user);
  }
}