import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawrtal/models/comments/comment_model.dart';
import 'package:pawrtal/models/portals/portal_model.dart';
import 'package:pawrtal/models/user/user_model.dart';
import 'package:uuid/uuid.dart';

class PostModel {
  static final _db = FirebaseFirestore.instance;

  final String uid;
  PortalModel? _portal;
  UserModel? _poster;
  String? _caption;
  String? _description;
  List<String>? _images;
  List<DocumentReference>? _likes;
  int? _likeCount;
  int? _commentCount;

  PortalModel? get portal => _portal;
  UserModel? get poster => _poster;
  String? get caption => _caption;
  String? get description => _description;
  List<String>? get images => _images;
  int? get likeCount => _likeCount;
  int? get commentCount => _commentCount;

  // TODO: Implement Likes and Bookmarks
  PostModel({required this.uid});

  DocumentReference get dbRef { 
    return _db.collection('posts').doc(uid);
  }

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

  Future<PostModel> get updated async {
    final postSnapshot = await _db.collection('posts').doc(uid).get();
    final postData = postSnapshot.data()!;
    final portal = await PortalModel(postData['portal'].id).updated;
    final poster = await UserModel(postData['poster'].id).updated;

    _portal =  portal;
    _poster = poster;
    _caption = postData['caption'];
    _description = postData['description'];
    _images = List.from(postData['images'] ?? const Iterable.empty());
    _likes = List.from(postData['likes'] ?? const Iterable.empty());
    _likeCount = postData['likeCount'];
    _commentCount = postData['commentCount'];

    return this;
  }

  bool isLikedBy(UserModel user) {
    return _likes!.contains(user.dbRef);
  }

  Future<void> addUserToLikes(UserModel user) async {
    // only add to likes if not already liked
    if (!isLikedBy(user)) { 
      _likes!.add(user.dbRef);
      _likeCount = _likeCount! + 1;
      await dbRef.update({ 'likes': FieldValue.arrayUnion([user.dbRef]), 'likeCount': _likeCount });
    }
  }

  Future<void> removeUserFromLikes(UserModel user) async {
    // only remove from likes if already liked
    if (isLikedBy(user)) {
      _likes!.remove(user.dbRef);
      _likeCount = _likeCount! - 1;
      await dbRef.update({ 'likes': FieldValue.arrayRemove([user.dbRef]), 'likeCount': _likeCount });
    }
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
    dbRef.collection('comments').doc(newUuid)
      .set(commentUpload) // first upload to db
      .then((_) { // then only when completed increment comment count
        _commentCount = _commentCount! + 1;
        _db.collection('posts').doc(uid)
          .update({ 'commentCount': _commentCount! });
      });
  }

  static Future<PostModel> postFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) async {
    final postData = snapshot.data()!;
    final portal = await PortalModel(postData['portal'].id).updated;
    final poster = await UserModel(postData['poster'].id).updated;
    log('post from snapshot: ${snapshot.id}, ${postData['caption']}, ${portal.name}, ${poster.username}');
    final post = PostModel(uid: snapshot.id);
    post._portal = portal;
    post._poster = poster;
    post._caption = postData['caption'];
    post._description = postData['description'];
    post._images = List.from(postData['images'] ?? const Iterable.empty());
    post._likeCount = postData['likeCount'];
    post._likes = List.from(postData['likes'] ?? const Iterable.empty());
    post._commentCount = postData['commentCount'];

    log('post: $post');
    return post;
  }
}