import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawrtal/models/comments/comment_model.dart';
import 'package:pawrtal/models/portals/portal_model.dart';
import 'package:pawrtal/models/posts/post_model.dart';
import 'package:pawrtal/models/user/user_model.dart';
import 'package:timeago_flutter/timeago_flutter.dart' as timeago;
import 'package:uuid/uuid.dart';

enum NotificationType { 
  likePost,
  commentPost,
  followUser,
  followUpload,
}

abstract class NotificationModel {
  final String uid;
  late Timestamp _timestamp;
  
  static late UserModel user; // uid of the user
  static final Map<String, NotificationModel> _cache = {};

  static final _db = FirebaseFirestore.instance;

  NotificationModel._internal(this.uid);

  String? get image => null;
  String? get title => null;
  String? get message => null;

  DateTime get notifiedTime => _timestamp.toDate();
  String get formatedTimeAgo => timeago.format(notifiedTime, locale: 'en_short');

  DocumentReference get dbRef {
    return _db.collection('users').doc(user.uid).collection('notifications').doc(uid);
  }

  static Stream<List<NotificationModel>> get getNotifications { 
    return user.dbRef
      .collection('notifications')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .asyncMap((querySnapshot) async { 
        final notifications = <NotificationModel>[];
        for (var docSnapshot in querySnapshot.docs) {
          notifications.add(await notificationFromSnapshot(docSnapshot));
        }
        return notifications;
      }).handleError((error) {
        log('Error in retrieving notifications, $error');
        return [];
      });
  }

  static Future<NotificationModel> notificationFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) async {
    final data = snapshot.data()!;   
    log(data.toString());
    final type = NotificationType.values.firstWhere((e) => e.name == data['type']); // gets enum type from string name
    final uid = snapshot.id;

    switch (type) {
      case NotificationType.likePost:
        final notif = _LikeNotification(uid);
        notif._post = await PostModel(data['post'].id).updated;
        notif._liker = await UserModel(data['liker'].id).updated;
        notif._timestamp = data['timestamp'];
        return notif;
      case NotificationType.commentPost:
        final notif = _CommentNotification(uid);
        notif._post = await PostModel(data['comment'].parent.parent.id).updated;
        notif._comment = await CommentModel.commentFromSnapshot(await data['comment'].get());
        notif._timestamp = data['timestamp'];
        return notif;
      case NotificationType.followUser:
        final notif = _FollowNotification(uid);
        notif._follower = await UserModel(data['follower'].id).updated;
        notif._timestamp = data['timestamp'];
        return notif;
      case NotificationType.followUpload: 
        final notif = _FollowedUserPostNotification(uid);
        notif._post = await PostModel(data['post'].id).updated;
        notif._timestamp = data['timestamp'];
        return notif;
      default:
        throw UnsupportedError('Encounted notification with type \'$type\'');
    }
  }

  static Future<void> sendNotification({required UserModel receiver, required Map<String, dynamic> data}) async {
    final uid = const Uuid().v4();
    final newNotifRef = receiver.dbRef.collection('notifications').doc(uid);
    return newNotifRef.set(data).then((_) => receiver.receiveNotification());  
  }

  static Future<void> retractIfExists({required UserModel receiver, required NotificationType type,
      required Map<String, dynamic> query}) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot;
      switch (type) {
        case NotificationType.likePost:
          snapshot = await receiver.dbRef.collection('notifications')
            .where('type', isEqualTo: type.name)
            .where('liker', isEqualTo: query['liker'])
            .where('post', isEqualTo: query['post'])
            .limit(1)
            .get();
        case NotificationType.followUser:
          snapshot = await receiver.dbRef.collection('notifications')
            .where('type', isEqualTo: type.name)
            .where('follower', isEqualTo: query['follower'])
            .limit(1)
            .get();
        default:
          throw UnsupportedError('Retraction unsupported for notfication type "${type.name}"');
      }
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.reference.delete().then((_) => receiver.clearNotification());
      } else {
        log('No "${type.name}" notification in "users/${receiver.uid}/notifications" to retract');
      }

    } catch (e) {
      log('Encountered error whilst retracting "${type.name}" notification in "users/${receiver.uid}/notifications": $e');
    }
  }

  Future<void> clear() async {
    // deletes notification from firebase and delinks instance from cache
    try {
      await dbRef.delete() 
        .then((_) { 
          user.clearNotification();
          _cache.remove(uid); 
        });
    } catch (e) {
      log('Error in trying to clear notification "${dbRef.path}"');
    }
  }
}

class _LikeNotification extends NotificationModel {
  late PostModel _post;
  late UserModel _liker;

  _LikeNotification._interal(super.uid) : super._internal();

  factory _LikeNotification(String uid) {
    return NotificationModel._cache.putIfAbsent(uid, () => _LikeNotification._interal(uid)) as _LikeNotification;
  }

  @override
  String? get image => _liker.pfp;

  @override
  String? get title => '${_liker.displayName} (@${_liker.username}) liked your post "${_post.caption}" on p/${_post.portal.name}';
}

class _CommentNotification extends NotificationModel {
  late CommentModel _comment;
  late PostModel _post;
  _CommentNotification._interal(super.uid) : super._internal();

  factory _CommentNotification(String uid) {
    return NotificationModel._cache.putIfAbsent(uid, () => _CommentNotification._interal(uid)) as _CommentNotification;
  }

  UserModel get _commenter => _comment.poster;

  @override
  String? get image => _commenter.pfp;

  @override
  String? get title => '${_commenter.displayName} (@${_commenter.username}) commented your post "${_post.caption}" on p/${_post.portal.name}';

  @override
  String? get message => '"${_comment.message}"';
}

class _FollowNotification extends NotificationModel {
  late UserModel _follower;
  _FollowNotification._interal(super.uid) : super._internal();

  factory _FollowNotification(String uid) {
    return NotificationModel._cache.putIfAbsent(uid, () => _FollowNotification._interal(uid)) as _FollowNotification;
  }

  @override
  String? get image => _follower.pfp;

  @override
  String? get title => '${_follower.displayName} (@${_follower.username}) is now following you';
}

class _FollowedUserPostNotification extends NotificationModel {
  late PostModel _post;
  _FollowedUserPostNotification._interal(super.uid) : super._internal();

  factory _FollowedUserPostNotification(String uid) {
    return NotificationModel._cache.putIfAbsent(uid, () => _FollowedUserPostNotification._interal(uid)) as _FollowedUserPostNotification;
  }

  UserModel get _poster => _post.poster;
  PortalModel get _portal => _post.portal;

  @override
  String? get image => _poster.pfp;

  @override
  String? get title => '${_poster.displayName} (@${_poster.username}) created new post on p/${_portal.name}';

  @override
  String? get message => '"${_post.caption}"';
}