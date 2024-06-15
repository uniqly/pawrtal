import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pawrtal/models/portals/portal_model.dart';
import 'package:pawrtal/models/user/user_model.dart';
import 'package:pawrtal/test/test_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'create_post_viewmodel.g.dart';

class CreatePostViewModel { 
  static final _storage = FirebaseStorage.instance.ref();
  static final _db = FirebaseFirestore.instance;

  final UserModel _poster;
  String _caption = '';
  String _description = '';
  List<File> _images = [];
  String? _portalId;

  CreatePostViewModel(this._poster);

  void updateForm({String? caption, String? description, String? portalId, List<File>? images}) {
    _caption = caption ?? _caption;
    _description = description ?? _description;
    _portalId = portalId;
    _images = images ?? _images;
  }

  @override
  String toString() {
    final img = _images.fold('', (s, f) => '$s${f.uri.pathSegments.last}, ');
    return '$_caption, $_description, $_portalId, [ $img]';
  }

  // query for the list of subpawrtals whose name (not id) starts with the query string
  Stream<List<PortalModel>> portalQuery(String query) async* { 
    Query<Map<String, dynamic>> ref = _db.collection('portals');
    var portals = <PortalModel>[];
    // non empty query => find doucments with name gte name and lt name + 1 unicode char
    if (query.isNotEmpty) { 
      final prefix = query.substring(0, query.length - 1);
      final lastCharCode = query.codeUnitAt(query.length - 1);
      final endQuery = '$prefix${String.fromCharCode(lastCharCode + 1)}';
      ref = ref.where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThan: endQuery);
      log('query: ($query, $endQuery)');
    }
    await ref.orderBy('memberCount', descending: true).get()
      .then((querySnapshot) async { 
        for (var docSnapshot in querySnapshot.docs) {
          log('portal: $docSnapshot');
          await PortalModel.portalFromSnapshot(docSnapshot).then((portal) => portals.add(portal));
        }
      });
    yield portals;
  }

  Future<void> createPost() async { 
    final newUuid = const Uuid().v4();
    
    // upload post to firestore
    final upload = { 
      'poster': _db.doc('users/${_poster.uid}'),
      'portal': _db.doc('portals/$_portalId'),
      'caption': _caption,
      'description': _description,
      'comments': 0,
      'likes': 0,
      'images': _images.length,
      'timestamp': FieldValue.serverTimestamp(),
    };
    _db.collection('posts').doc(newUuid).set(upload, SetOptions(merge: true));

    // upload images to cloud
    for (int i = 0; i < _images.length; i++) {
      var file = _images[i];
      _storage.child('images/posts/$newUuid-${i+1}.png').putFile(file);
    }
  }

}

@riverpod
class CreatePostViewModelNotifier extends _$CreatePostViewModelNotifier {
  @override
  Future<CreatePostViewModel> build() async {
    final mainUser = await ref.watch(mainUserProvider.future);
    return CreatePostViewModel(mainUser);
  }
}



