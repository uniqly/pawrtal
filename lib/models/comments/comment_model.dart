import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawrtal/models/user/user_model.dart';

class CommentModel {
  final String uid;
  late UserModel _poster;
  late String _message;
  late Timestamp _timestamp;

  static final Map<String, CommentModel> _cache = {};

  CommentModel._internal(this.uid);

  factory CommentModel(String uid) {
    return _cache.putIfAbsent(uid, () => CommentModel._internal(uid));
  }

  UserModel get poster => _poster;
  String get message => _message;
  DateTime get postedDate => _timestamp.toDate();

  @override
  String toString() {
    return 'comment: {$_poster}, $_message, $postedDate';
  }

  static Future<CommentModel> commentFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) async {
    log('${snapshot['commenter'].id}');
    final poster = await UserModel(snapshot['commenter'].id).updated;
    log('$poster');
    final commentData = snapshot.data()!;
    final comment = CommentModel(snapshot.id);
    comment._poster = poster;
    comment._message = commentData['message'];
    comment._timestamp = commentData['timestamp'] as Timestamp;

    log(comment.toString());

    return comment;
  }
}