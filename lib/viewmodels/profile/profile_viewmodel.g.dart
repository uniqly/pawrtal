// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profileViewModelNotifierHash() =>
    r'7e9a8246d739015c744954fb59a706a57aee2232';

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

abstract class _$ProfileViewModelNotifier
    extends BuildlessAutoDisposeAsyncNotifier<ProfileViewModel> {
  late final String uid;

  FutureOr<ProfileViewModel> build({
    required String uid,
  });
}

/// See also [ProfileViewModelNotifier].
@ProviderFor(ProfileViewModelNotifier)
const profileViewModelNotifierProvider = ProfileViewModelNotifierFamily();

/// See also [ProfileViewModelNotifier].
class ProfileViewModelNotifierFamily
    extends Family<AsyncValue<ProfileViewModel>> {
  /// See also [ProfileViewModelNotifier].
  const ProfileViewModelNotifierFamily();

  /// See also [ProfileViewModelNotifier].
  ProfileViewModelNotifierProvider call({
    required String uid,
  }) {
    return ProfileViewModelNotifierProvider(
      uid: uid,
    );
  }

  @override
  ProfileViewModelNotifierProvider getProviderOverride(
    covariant ProfileViewModelNotifierProvider provider,
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
  String? get name => r'profileViewModelNotifierProvider';
}

/// See also [ProfileViewModelNotifier].
class ProfileViewModelNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<ProfileViewModelNotifier,
        ProfileViewModel> {
  /// See also [ProfileViewModelNotifier].
  ProfileViewModelNotifierProvider({
    required String uid,
  }) : this._internal(
          () => ProfileViewModelNotifier()..uid = uid,
          from: profileViewModelNotifierProvider,
          name: r'profileViewModelNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$profileViewModelNotifierHash,
          dependencies: ProfileViewModelNotifierFamily._dependencies,
          allTransitiveDependencies:
              ProfileViewModelNotifierFamily._allTransitiveDependencies,
          uid: uid,
        );

  ProfileViewModelNotifierProvider._internal(
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
  FutureOr<ProfileViewModel> runNotifierBuild(
    covariant ProfileViewModelNotifier notifier,
  ) {
    return notifier.build(
      uid: uid,
    );
  }

  @override
  Override overrideWith(ProfileViewModelNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProfileViewModelNotifierProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<ProfileViewModelNotifier,
      ProfileViewModel> createElement() {
    return _ProfileViewModelNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProfileViewModelNotifierProvider && other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ProfileViewModelNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<ProfileViewModel> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _ProfileViewModelNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ProfileViewModelNotifier,
        ProfileViewModel> with ProfileViewModelNotifierRef {
  _ProfileViewModelNotifierProviderElement(super.provider);

  @override
  String get uid => (origin as ProfileViewModelNotifierProvider).uid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
