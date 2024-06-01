import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PortalModel {
  final String uid;
  final String? name;
  final String? banner;
  final String? picture;

  PortalModel({required this.uid, this.name, this.banner, this.picture});

  static Future<PortalModel> portalFromFirebase(String uid) async { 
    final storage = FirebaseStorage.instance.ref();
    final db = FirebaseFirestore.instance;
    final dataSnapshot = await db.collection('portals').doc(uid).get();
    final data = dataSnapshot.data()!;
    return PortalModel( 
      uid: uid,
      name: data['name'],
      banner: await storage.child('images/portals/$uid-banner.png').getDownloadURL(),
      picture: await storage.child('images/portals/$uid-picture.png').getDownloadURL(),
    );
  }
}
