import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PortalModel {
  static final _db = FirebaseFirestore.instance;
  static final _storage = FirebaseStorage.instance.ref();

  final String uid;
  final String? name;
  final String? banner;
  final String? picture;
  final int? memberCount;

  PortalModel({required this.uid, this.name, this.banner, this.picture, this.memberCount});

  static Future<PortalModel> portalFromFirebase(String uid) async {
    try {
      final dataSnapshot = await _db.collection('portals').doc(uid).get();
      if (!dataSnapshot.exists) {
        throw Exception('Document does not exist');
      }
      final data = dataSnapshot.data()!;
      return PortalModel(
        uid: uid,
        name: data['name'] as String?,
        banner: await _fetchImageURL('images/portals/$uid-banner.png'),
        picture: await _fetchImageURL('images/portals/$uid-picture.png'),
        memberCount: data['memberCount'] as int?,
      );
    } catch (e, s) {
      log('Error fetching portal data: $e', stackTrace: s);
      return PortalModel(uid: uid);
    }
  }

  static Future<PortalModel> portalFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) async {
    try {
      log('portalId: ${snapshot.id}');
      final portalData = snapshot.data()!;
      return PortalModel(
        uid: snapshot.id,
        name: portalData['name'] as String?,
        banner: await _fetchImageURL('images/portals/${snapshot.id}-banner.png'),
        picture: await _fetchImageURL('images/portals/${snapshot.id}-picture.png'),
        memberCount: portalData['memberCount'] as int?,
      );
    } catch (e, s) {
      log('Error processing snapshot: $e', stackTrace: s);
      return PortalModel(uid: snapshot.id);
    }
  }

  static Future<String> _fetchImageURL(String path) async {
    try {
      return await _storage.child(path).getDownloadURL();
    } catch (e) {
      return '';
    }
  }
}
