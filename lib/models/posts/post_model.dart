import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pawrtal/models/portals/portal_model.dart';
import 'package:pawrtal/models/user/user_model.dart';

class PostModel {
  final String uid;
  final PortalModel portal;
  final UserModel poster;
  final String? caption;
  final String? description;
  final int? images;
  final int? likeCount;
  final int? commentCount;

  // TODO: Implement Likes and Bookmarks

  PostModel({required this.uid, required this.portal, required this.poster, this.caption, 
      this.description, this.images, this.likeCount, this.commentCount});

  Future<List<String>?> get postImages async {
    final storage = FirebaseStorage.instance.ref();
    return (images ?? 0) == 0 ? null : [
      for (var i = 1; i <= images!; i++)
        await storage.child('images/posts/$uid-$i.png').getDownloadURL()
    ];
  }

  static Future<PostModel> postFromFirebase(String uid) async {
    final db = FirebaseFirestore.instance;
    final postSnapshot = await db.collection('posts').doc(uid).get();
    final postData = postSnapshot.data()!;
    final portal = await PortalModel.portalFromFirebase(postData['portal'].id);
    final poster = await UserModel.userFromFirebase(postData['poster'].id);
    return PostModel( 
      uid: uid,
      portal: portal,
      poster: poster,
      caption: postData['caption'],
      images: postData['images'],
      likeCount: postData['likes'],
      commentCount: postData['comments'],
    );
  }
}