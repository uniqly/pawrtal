// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profileViewModelHash() => r'3aede0e082a4b29389f8299be6adf26ad5245ac1';

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

abstract class _$ProfileViewModel
    extends BuildlessAutoDisposeAsyncNotifier<UserModel> {
  late final String uid;

  FutureOr<UserModel> build({
    required String uid,
  });
}

/// See also [ProfileViewModel].
@ProviderFor(ProfileViewModel)
const profileViewModelProvider = ProfileViewModelFamily();

/// See also [ProfileViewModel].
class ProfileViewModelFamily extends Family<AsyncValue<UserModel>> {
  /// See also [ProfileViewModel].
  const ProfileViewModelFamily();

  /// See also [ProfileViewModel].
  ProfileViewModelProvider call({
    required String uid,
  }) {
    return ProfileViewModelProvider(
      uid: uid,
    );
  }

  @override
  ProfileViewModelProvider getProviderOverride(
    covariant ProfileViewModelProvider provider,
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
  String? get name => r'profileViewModelProvider';
}

/// See also [ProfileViewModel].
class ProfileViewModelProvider
    extends AutoDisposeAsyncNotifierProviderImpl<ProfileViewModel, UserModel> {
  /// See also [ProfileViewModel].
  ProfileViewModelProvider({
    required String uid,
  }) : this._internal(
          () => ProfileViewModel()..uid = uid,
          from: profileViewModelProvider,
          name: r'profileViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$profileViewModelHash,
          dependencies: ProfileViewModelFamily._dependencies,
          allTransitiveDependencies:
              ProfileViewModelFamily._allTransitiveDependencies,
          uid: uid,
        );

  ProfileViewModelProvider._internal(
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
    covariant ProfileViewModel notifier,
  ) {
    return notifier.build(
      uid: uid,
    );
  }

  @override
  Override overrideWith(ProfileViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProfileViewModelProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<ProfileViewModel, UserModel>
      createElement() {
    return _ProfileViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProfileViewModelProvider && other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ProfileViewModelRef on AutoDisposeAsyncNotifierProviderRef<UserModel> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _ProfileViewModelProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ProfileViewModel, UserModel>
    with ProfileViewModelRef {
  _ProfileViewModelProviderElement(super.provider);

  @override
  String get uid => (origin as ProfileViewModelProvider).uid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
