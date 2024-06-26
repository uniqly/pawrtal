import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawrtal/models/posts/post_model.dart';
import 'package:pawrtal/models/user/user_model.dart';

class PortalModel {
  static final _db = FirebaseFirestore.instance;

  final String uid;
  String? _name;
  String? _banner;
  String? _picture;
  int? _memberCount;
  List<DocumentReference>? _members;

  PortalModel(this.uid);
  
  String? get name => _name;
  String? get banner => _banner;
  String? get picture => _picture;
  int? get memberCount => _memberCount;

  DocumentReference get dbRef { 
    return _db.collection('portals').doc(uid);
  }

  Stream<List<PostModel>> get posts { 
    return _db.collection('posts')
      .where('portal', isEqualTo: dbRef)
      .orderBy('timestamp', descending: true)
      .snapshots()
      .asyncMap((querySnapshot) async {
        final posts = <PostModel>[];
        for (var docSnapshot in querySnapshot.docs) {
          log(docSnapshot.id);
          posts.add(await PostModel.postFromSnapshot(docSnapshot));
        }

        log('posts: $posts');

        return posts;
      });
  }

  @override
  String toString() {
    return 'portal: $_name, $_memberCount, ${_members?.map((m) => m.id)}';
  }

  bool hasUser(UserModel user) { 
    return _members!.contains(user.dbRef);
  }

  Future<void> addUser(UserModel user) async {
    if (!hasUser(user)) {
      _members!.add(user.dbRef);
      _memberCount = _memberCount! + 1;
      await dbRef.update({ 'members': FieldValue.arrayUnion([user.dbRef]), 'memberCount': _memberCount });
    }
  }

  Future<void> removeUser(UserModel user) async {
    if (hasUser(user)) {
      _members!.remove(user.dbRef);
      _memberCount = _memberCount! - 1;
      await dbRef.update({ 'members': FieldValue.arrayRemove([user.dbRef]), 'memberCount': _memberCount});
    }
  }

  Future<PortalModel> get updated async {
    final dataSnapshot = await _db.collection('portals').doc(uid).get();
    final data = dataSnapshot.data()!;
    _name = data['name'];
    _banner = data['banner'];
    _picture = data['picture'];
    _memberCount = data['memberCount'];
    _members = List.from(data['members'] ?? const Iterable.empty());

    return this;
  }

  static Future<PortalModel> portalFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) async {
    log('portalId: $snapshot.id');
    final portal = PortalModel(snapshot.id);
    final portalData = snapshot.data()!;
    portal._name = portalData['name'];
    portal._banner = portalData['banner'];
    portal._picture = portalData['picture'];
    portal._memberCount = portalData['memberCount'];
    portal._members = List.from(portalData['members'] ?? const Iterable.empty());

    return portal;
  }
}
