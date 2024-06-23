import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pawrtal/models/comments/comment_model.dart';
import 'package:pawrtal/models/portals/portal_model.dart';
import 'package:pawrtal/models/user/user_model.dart';
import 'package:uuid/uuid.dart';

class PostModel {
  static final _db = FirebaseFirestore.instance;
  static final _storage = FirebaseStorage.instance.ref();

  final String uid;
  PortalModel? _portal;
  UserModel? _poster;
  String? _caption;
  String? _description;
  List<String>? _images;
  int? _likeCount;
  int? _commentCount;

  PortalModel? get portal => _portal;
  UserModel? get poster => _poster;
  String? get caption => _caption;
  String? get description => _description;
  List<String>? get images => _images;
  int? get likeCount => _likeCount;
  int? get commentCount => _commentCount;

  Stream<List<CommentModel>> get comments { 
    return _db.collection('posts')
      .doc(uid)
      .collection('comments')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .asyncMap((querySnapshot) async {
        final comments = <CommentModel>[];
        for (var docSnapshot in querySnapshot.docs) {
          log(docSnapshot.id);
          comments.add(await CommentModel.commentFromSnapshot(docSnapshot));
        }
        log('post comments $comments');

        return comments;
      });
  }
  // TODO: Implement Likes and Bookmarks
  PostModel({required this.uid});

  /*
  Future<List<String>?> get postImages async {
    return (images ?? 0) == 0 ? null : [
      for (var i = 1; i <= images!; i++)
        await _storage.child('images/posts/$uid-$i.png').getDownloadURL().onError((e, s) => '')
    ];
  }
  */

  Future<PostModel> get updated async {
    final postSnapshot = await _db.collection('posts').doc(uid).get();
    final postData = postSnapshot.data()!;
    final portal = await PortalModel.portalFromFirebase(postData['portal'].id);
    final poster = await UserModel(postData['poster'].id).updated;

    _portal =  portal;
    _poster = poster;
    _caption = postData['caption'];
    _description = postData['description'];
    _images = List.from(postData['images'] ?? const Iterable.empty());
    _likeCount = postData['likes'];
    _commentCount = postData['comments'];

    return this;
  }

  Future<void> uploadComment({required String message, required UserModel commenter}) async {
    final newUuid = const Uuid().v4();
    final commenterRef = commenter.dbRef;

    final commentUpload = {
      'commenter': commenterRef,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    };

    // upload process
    _db.collection('posts').doc(uid)
      .collection('comments').doc(newUuid)
      .set(commentUpload) // first upload to db
      .then((_) { // then only when completed increment comment count
        _commentCount = _commentCount! + 1;
        _db.collection('posts').doc(uid)
          .set({ 'comments': _commentCount! + 1 }, SetOptions(merge: true));
      });
  }

  static Future<PostModel> postFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) async {
    final postData = snapshot.data()!;
    final portal = await PortalModel.portalFromFirebase(postData['portal'].id);
    final poster = await UserModel(postData['poster'].id).updated;
    log('post from snapshot: ${snapshot.id}, ${postData['caption']}, ${portal.name}, ${poster.username}');
    final post = PostModel(uid: snapshot.id);
    post._portal = portal;
    post._poster = poster;
    post._caption = postData['caption'];
    post._description = postData['description'];
    post._images = List.from(postData['images'] ?? const Iterable.empty());
    post._likeCount = postData['likes'];
    post._commentCount = postData['comments'];

    log('post: $post');
    return post;
  }
}