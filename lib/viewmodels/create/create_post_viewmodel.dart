import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawrtal/models/portals/portal_model.dart';
import 'package:pawrtal/models/user/user_model.dart';
import 'package:pawrtal/test/test_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'create_post_viewmodel.g.dart';

class CreatePostViewModel { 
  final UserModel _poster;
  String _caption = '';
  String _description = '';
  int _imageCount = 0;
  String? _portalId;

  CreatePostViewModel(this._poster);

  void updateForm({String? caption, String? description, String? portalId}) {
    _caption = caption ?? _caption;
    _description = description ?? _description;
    _portalId = portalId;
  }

  @override
  String toString() {
    return '$_caption, $_description, $_portalId';
  }

  // query for the list of subpawrtals whose name (not id) starts with the query string
  Stream<List<PortalModel>> portalQuery(String query) async* { 
    final db = FirebaseFirestore.instance;
    Query<Map<String, dynamic>> ref = db.collection('portals');
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
    await ref.get()
      .then((querySnapshot) async { 
        for (var docSnapshot in querySnapshot.docs) {
          log('portal: $docSnapshot');
          await PortalModel.portalFromSnapshot(docSnapshot).then((portal) => portals.add(portal));
        }
      });
    yield portals;
  }

  Future<void> createPost() async { 
    final db = FirebaseFirestore.instance;
    final newUuid = const Uuid().v4();
    final upload = { 
      'poster': db.doc('users/${_poster.uid}'),
      'portal': db.doc('portals/$_portalId'),
      'caption': _caption,
      'description': _description,
      'comments': 0,
      'likes': 0,
      'images': _imageCount,
      'timestamp': FieldValue.serverTimestamp(),
    };
    db.collection('posts').doc(newUuid).set(upload, SetOptions(merge: true));
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



