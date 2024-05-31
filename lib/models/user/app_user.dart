
class AppUser {
  final String uid;
  
  // TODO: Integrate firebase with users
  AppUser(this.uid);

  String get pfp => '';
  String get banner => '';
  Stream<AppUser?> get following async* { 
    yield null;
  }
  String get displayName => '';
  String get handle => '';
  String? get location => '';
  int get followerCount => 0;
  int get followsCount => 0;
  String get bio => '';
}