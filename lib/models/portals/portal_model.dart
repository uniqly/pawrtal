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
    final dataSnapshot = await _db.collection('portals').doc(uid).get();
    final data = dataSnapshot.data()!;
    return PortalModel( 
      uid: uid,
      name: data['name'],
      banner: await _storage.child('images/portals/$uid-banner.png').getDownloadURL().onError((e, s) => ''),
      picture: await _storage.child('images/portals/$uid-picture.png').getDownloadURL().onError((e, s) => ''),
      memberCount: data['memberCount'],
    );
  }

  static Future<PortalModel> portalFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) async {
    log('portalId: $snapshot.id');
    final portalData = snapshot.data()!;
    return PortalModel( 
      uid: snapshot.id,
      name: portalData['name'],
      banner: await _storage.child('images/portals/${snapshot.id}-banner.png').getDownloadURL().onError((e, s) => ''),
      picture: await _storage.child('images/portals/${snapshot.id}-picture.png').getDownloadURL().onError((e, s) => ''),
      memberCount: portalData['memberCount'],
    );
  }
}
