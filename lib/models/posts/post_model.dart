import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pawrtal/models/portals/portal_model.dart';
import 'package:pawrtal/models/user/user_model.dart';

class PostModel {
  static final _db = FirebaseFirestore.instance;
  static final _storage = FirebaseStorage.instance.ref();

  final String uid;
  final PortalModel portal;
  final UserModel poster;
  final String? caption;
  final String? description;
  final List<String>? images;
  final int? likeCount;
  final int? commentCount;

  // TODO: Implement Likes and Bookmarks

  PostModel({required this.uid, required this.portal, required this.poster, this.caption, 
      this.description, this.images, this.likeCount, this.commentCount});

  /*
  Future<List<String>?> get postImages async {
    return (images ?? 0) == 0 ? null : [
      for (var i = 1; i <= images!; i++)
        await _storage.child('images/posts/$uid-$i.png').getDownloadURL().onError((e, s) => '')
    ];
  }
  */

  static Future<PostModel> postFromFirebase(String uid) async {
    final postSnapshot = await _db.collection('posts').doc(uid).get();
    final postData = postSnapshot.data()!;
    final portal = await PortalModel.portalFromFirebase(postData['portal'].id);
    final poster = await UserModel(postData['poster'].id).updated;
    return PostModel( 
      uid: uid,
      portal: portal,
      poster: poster,
      caption: postData['caption'],
      description: postData['description'],
      images: List.from(postData['images'] ?? const Iterable.empty()),
      likeCount: postData['likes'],
      commentCount: postData['comments'],
    );
  }

  static Future<PostModel> postFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) async {
    final postData = snapshot.data()!;
    final portal = await PortalModel.portalFromFirebase(postData['portal'].id);
    final poster = await UserModel(postData['poster'].id).updated;
    log('post from snapshot: ${snapshot.id}, ${postData['caption']}, ${portal.name}, ${poster.username}');
    final post = PostModel( 
      uid: snapshot.id,
      portal: portal,
      poster: poster,
      caption: postData['caption'],
      description: postData['description'],
      images: List.from(postData['images'] ?? const Iterable.empty()),
      likeCount: postData['likes'],
      commentCount: postData['comments'],
    );
    log('post: $post');
    return post;
  }
}