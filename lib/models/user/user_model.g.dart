// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appUserHash() => r'da4fe31c454f6d9a4beea81ef44743cfe5801d2a';

/// See also [appUser].
@ProviderFor(appUser)
final appUserProvider = AutoDisposeStreamProvider<UserModel?>.internal(
  appUser,
  name: r'appUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AppUserRef = AutoDisposeStreamProviderRef<UserModel?>;
String _$userNotifierHash() => r'2f08b4882bd5cf46a733f9664856aaa06e5c7834';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$UserNotifier
    extends BuildlessAutoDisposeAsyncNotifier<UserModel> {
  late final String uid;

  FutureOr<UserModel> build({
    required String uid,
  });
}

/// See also [UserNotifier].
@ProviderFor(UserNotifier)
const userNotifierProvider = UserNotifierFamily();

/// See also [UserNotifier].
class UserNotifierFamily extends Family<AsyncValue<UserModel>> {
  /// See also [UserNotifier].
  const UserNotifierFamily();

  /// See also [UserNotifier].
  UserNotifierProvider call({
    required String uid,
  }) {
    return UserNotifierProvider(
      uid: uid,
    );
  }

  @override
  UserNotifierProvider getProviderOverride(
    covariant UserNotifierProvider provider,
  ) {
    return call(
      uid: provider.uid,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userNotifierProvider';
}

/// See also [UserNotifier].
class UserNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<UserNotifier, UserModel> {
  /// See also [UserNotifier].
  UserNotifierProvider({
    required String uid,
  }) : this._internal(
          () => UserNotifier()..uid = uid,
          from: userNotifierProvider,
          name: r'userNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userNotifierHash,
          dependencies: UserNotifierFamily._dependencies,
          allTransitiveDependencies:
              UserNotifierFamily._allTransitiveDependencies,
          uid: uid,
        );

  UserNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
  }) : super.internal();

  final String uid;

  @override
  FutureOr<UserModel> runNotifierBuild(
    covariant UserNotifier notifier,
  ) {
    return notifier.build(
      uid: uid,
    );
  }

  @override
  Override overrideWith(UserNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: UserNotifierProvider._internal(
        () => create()..uid = uid,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<UserNotifier, UserModel>
      createElement() {
    return _UserNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserNotifierProvider && other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UserNotifierRef on AutoDisposeAsyncNotifierProviderRef<UserModel> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _UserNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<UserNotifier, UserModel>
    with UserNotifierRef {
  _UserNotifierProviderElement(super.provider);

  @override
  String get uid => (origin as UserNotifierProvider).uid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
