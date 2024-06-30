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
  List<DocumentReference>? _followers;
  List<DocumentReference>? _following;
  
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
    user._followerCount = snapshot['followerCount'] ?? 0;
    user._followingCount = snapshot['followingCount'] ?? 0;
    user._followers = List.from(snapshot['followers'] ?? const Iterable.empty());
    user._following = List.from(snapshot['following'] ?? const Iterable.empty());
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
      _followerCount = data['followerCount'];
      _followingCount = data['followingCount'];
      _followers = List.from(data['followers'] ?? const Iterable.empty());
      _following = List.from(data['following'] ?? const Iterable.empty());
    }

    return this;
  }

  bool hasFollower(UserModel user) { 
    return _followers!.contains(user.dbRef);
  }

  Future<void> addFollower(UserModel user) async {
    if (!hasFollower(user)) {
      _followers!.add(user.dbRef);
      _followerCount = _followerCount! + 1;
      await dbRef.update({ 'followers': FieldValue.arrayUnion([user.dbRef]), 'followerCount': _followerCount });
    }
  }

  Future<void> removeFollower(UserModel user) async {
    if (hasFollower(user)) {
      _followers!.remove(user.dbRef);
      _followerCount = _followerCount! - 1;
      await dbRef.update({ 'followers': FieldValue.arrayRemove([user.dbRef]), 'followerCount': _followerCount });
    }
  }

  bool isFollowing(UserModel user) { 
    return _following!.contains(user.dbRef);
  }

  Future<void> follow(UserModel user) async {
    if (!isFollowing(user)) {
      _following!.add(user.dbRef);
      _followingCount = _followingCount! + 1;
      await dbRef.update({ 'following': FieldValue.arrayUnion([user.dbRef]), 'followingCount': _followingCount });
    }
  }

  Future<void> unfollow(UserModel user) async {
    if (isFollowing(user)) {
      _following!.remove(user.dbRef);
      _followingCount = _followingCount! - 1;
      await dbRef.update({ 'following': FieldValue.arrayRemove([user.dbRef]), 'followingCount': _followingCount });
    }
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