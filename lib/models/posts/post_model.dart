import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawrtal/models/comments/comment_model.dart';
import 'package:pawrtal/models/notifications/notification_model.dart';
import 'package:pawrtal/models/portals/portal_model.dart';
import 'package:pawrtal/models/user/user_model.dart';
import 'package:uuid/uuid.dart';

class PostModel {
  static final _db = FirebaseFirestore.instance;

  final String uid;
  late PortalModel _portal;
  late UserModel _poster;
  late String _caption;
  late String _description;
  late List<String> _images;
  late List<DocumentReference> _likes;
  late int _likeCount;
  late int _commentCount;
  late List<DocumentReference> _bookmarks;

  static final Map<String, PostModel> _cache = {};

  PortalModel get portal => _portal;
  UserModel get poster => _poster;
  String get caption => _caption;
  String get description => _description;
  List<String> get images => _images;
  int get likeCount => _likeCount;
  int get commentCount => _commentCount;

  // TODO: Implement Likes and Bookmarks
  PostModel._internal(this.uid);

  factory PostModel(String uid) {
    return _cache.putIfAbsent(uid, () => PostModel._internal(uid));
  }

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
    _bookmarks = List.from(postData['bookmarks'] ?? const Iterable.empty());

    return this;
  }

  bool isLikedBy(UserModel user) {
    return _likes.contains(user.dbRef);
  }

  Future<void> addUserToLikes(UserModel user) async {
    // only add to likes if not already liked
    if (!isLikedBy(user)) { 
      _likes.add(user.dbRef);
      _likeCount = _likeCount + 1;
      await dbRef.update({ 'likes': FieldValue.arrayUnion([user.dbRef]), 'likeCount': _likeCount })
        .then((_) { 
          if (user != _poster) { // dont send a notification for self likes
            NotificationModel.sendNotification(
              receiver: _poster,
              data: { 
                'type': NotificationType.likePost.name,
                'liker': user.dbRef,
                'post': dbRef,
                'timestamp': FieldValue.serverTimestamp(),
              }
            );
          }
        }
      );
    }
  }

  Future<void> removeUserFromLikes(UserModel user) async {
    // only remove from likes if already liked
    if (isLikedBy(user)) {
      _likes.remove(user.dbRef);
      _likeCount = _likeCount - 1;
      await dbRef.update({ 'likes': FieldValue.arrayRemove([user.dbRef]), 'likeCount': _likeCount })
        .then((_) => NotificationModel.retractIfExists(
          receiver: _poster,
          type: NotificationType.likePost,
          query: { 
            'liker': user.dbRef,
            'post': dbRef,
          }
        )
      );
    }
  }

  bool hasBookmark(UserModel user) {
    return _bookmarks.contains(user.dbRef);
  }

  Future<void> removeBookmark(UserModel user) async {
    if (hasBookmark(user)) {
      _bookmarks.remove(user.dbRef);
      await dbRef.update({ 'bookmarks': FieldValue.arrayRemove([user.dbRef]) });
    }
  }

  Future<void> addBookmark(UserModel user) async {
    if (!hasBookmark(user)) {
      _bookmarks.add(user.dbRef);
      await dbRef.update(( {'bookmarks': FieldValue.arrayUnion([user.dbRef]) }));
    }
  }

  Future<void> uploadComment({required String message, required UserModel commenter}) async {
    final newUuid = const Uuid().v4();
    final commenterRef = commenter.dbRef;

    final timestamp = FieldValue.serverTimestamp();
    final commentRef = dbRef.collection('comments').doc(newUuid);

    final commentUpload = {
      'commenter': commenterRef,
      'message': message,
      'timestamp': timestamp,
    };

    // upload process
    commentRef.set(commentUpload) // first upload to db
      .then((_) { // then only when completed increment comment count
        _commentCount = _commentCount + 1;
        _db.collection('posts').doc(uid)
          .update({ 'commentCount': _commentCount })
          .then((_) { // send out notification
            if (commenter != _poster) {
              NotificationModel.sendNotification( 
                receiver: _poster,
                data: { 
                  'type': NotificationType.commentPost.name,
                  'comment': commentRef,
                  'timestamp': timestamp,
                }
              );
            }
          }
        );
      }
    );
  }

  static Future<PostModel> postFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) async {
    final postData = snapshot.data()!;
    final portal = await PortalModel(postData['portal'].id).updated;
    final poster = await UserModel(postData['poster'].id).updated;
    log('post from snapshot: ${snapshot.id}, ${postData['caption']}, ${portal.name}, ${poster.username}');
    final post = PostModel(snapshot.id);
    post._portal = portal;
    post._poster = poster;
    post._caption = postData['caption'];
    post._description = postData['description'];
    post._images = List.from(postData['images'] ?? const Iterable.empty());
    post._likeCount = postData['likeCount'];
    post._likes = List.from(postData['likes'] ?? const Iterable.empty());
    post._commentCount = postData['commentCount'];
    post._bookmarks = List.from(postData['bookmarks'] ?? const Iterable.empty());

    log('post: $post');
    return post;
  }
}