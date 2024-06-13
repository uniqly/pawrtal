import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pawrtal/models/posts/post_model.dart';
import 'package:pawrtal/models/user/user_model.dart';
import 'package:pawrtal/test/test_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_viewmodel.g.dart';

class HomeViewModel {
  static final _db = FirebaseFirestore.instance;

  final UserModel user;
  final Stream<List<PostModel>> _posts;

  HomeViewModel(this.user, this._posts);

  Stream<List<PostModel>> get posts {
    // gets the posts ordered in reverse chronological order
    return _db.collection('posts')
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
}

@riverpod
class HomeViewModelNotifier extends _$HomeViewModelNotifier {
  @override
  Future<HomeViewModel> build() async { 
    final user = await ref.watch(mainUserProvider.future);

    return HomeViewModel(user, const Stream.empty());
  }
}