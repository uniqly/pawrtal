import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawrtal/services/auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_model.g.dart';

class UserModel {
  static final _db = FirebaseFirestore.instance;

  final String uid;
  String? _displayName;
  String? _username;
  String? _pfp;
  String? _banner;
  String? _location;
  String? _bio;
  int? _followerCount;
  int? _followingCount;
  
  static final Map<String, UserModel> _cache = {};

  String? get displayName => _displayName;
  String? get username => _username;
  String? get pfp => _pfp;
  String? get banner => _banner;
  String? get location => _location;
  String? get bio => _bio;
  int? get followerCount => _followerCount;
  int? get followingCount => _followingCount;

  UserModel._internal(this.uid);

  factory UserModel(String uid) {
    return _cache.putIfAbsent(uid, () => UserModel._internal(uid));
  }

  static Future<UserModel> fromSnapshot({required String uid, required DocumentSnapshot<Map<String, dynamic>> snapshot}) async {
    final user = UserModel(uid);
    user._username = snapshot['username'] ?? '<NULL>';
    user._displayName = snapshot['displayName'] ?? '<NO NAME>';
    user._location = snapshot['location'] ?? '';
    user._bio = snapshot['bio'] ?? '';
    user._followerCount = snapshot['followers'] ?? 0;
    user._followingCount = snapshot['following'] ?? 0;
    user._pfp = snapshot['pfp'] ?? '';
    user._banner = snapshot['banner'] ?? '';
    return user;
  }

  DocumentReference get dbRef {
    return _db.collection('users').doc(uid);
  }

  Future<UserModel> get updated async {
    final dataSnapshot = await _db.collection('users').doc(uid).get();
    if (dataSnapshot.data() != null) {
      final data = dataSnapshot.data()!;
      
      _displayName = data['displayName'];
      _username = data['username'];
      _pfp = data['pfp'];
      _banner = data['banner'];
      _location = data['location'];
      _bio = data['bio'];
      _followerCount = data['followers'];
      _followingCount = data['following'];
    }

    return this;
  }

  @override
  String toString() {
    return 'user: $uid, $_displayName, $_username, $_bio, $_location, $_banner, $_followerCount, $_followingCount';
  }
}

@riverpod
Stream<UserModel?> appUser(AppUserRef ref) async* { 
  final auth = ref.watch(authUserProvider);
  final user = auth.value;
  if (user != null) {
    yield* FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots().asyncMap((snapshot) { 
      if (snapshot.exists) {
        return UserModel.fromSnapshot(uid: user.uid, snapshot: snapshot);
      } else {
        return null;
      }
    });
  } else {
   yield null;
  }
}

@riverpod
class UserNotifier extends _$UserNotifier {
  @override
  Future<UserModel> build({required String uid}) async {
    return UserModel(uid).updated;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async { 
      return await state.value!.updated;
    });
  }

  Future<void> pushSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async { 
      return UserModel.fromSnapshot(uid: snapshot.id, snapshot: snapshot);
    });
  }
}