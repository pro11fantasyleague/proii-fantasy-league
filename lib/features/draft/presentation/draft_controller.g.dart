// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draft_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$draftControllerHash() => r'd7534c4e0854c8b51631804e1280cbb800bcbc61';

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

abstract class _$DraftController
    extends BuildlessAutoDisposeStreamNotifier<DraftState> {
  late final String leagueId;

  Stream<DraftState> build(String leagueId);
}

/// See also [DraftController].
@ProviderFor(DraftController)
const draftControllerProvider = DraftControllerFamily();

/// See also [DraftController].
class DraftControllerFamily extends Family<AsyncValue<DraftState>> {
  /// See also [DraftController].
  const DraftControllerFamily();

  /// See also [DraftController].
  DraftControllerProvider call(String leagueId) {
    return DraftControllerProvider(leagueId);
  }

  @override
  DraftControllerProvider getProviderOverride(
    covariant DraftControllerProvider provider,
  ) {
    return call(provider.leagueId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'draftControllerProvider';
}

/// See also [DraftController].
class DraftControllerProvider
    extends AutoDisposeStreamNotifierProviderImpl<DraftController, DraftState> {
  /// See also [DraftController].
  DraftControllerProvider(String leagueId)
    : this._internal(
        () => DraftController()..leagueId = leagueId,
        from: draftControllerProvider,
        name: r'draftControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$draftControllerHash,
        dependencies: DraftControllerFamily._dependencies,
        allTransitiveDependencies:
            DraftControllerFamily._allTransitiveDependencies,
        leagueId: leagueId,
      );

  DraftControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.leagueId,
  }) : super.internal();

  final String leagueId;

  @override
  Stream<DraftState> runNotifierBuild(covariant DraftController notifier) {
    return notifier.build(leagueId);
  }

  @override
  Override overrideWith(DraftController Function() create) {
    return ProviderOverride(
      origin: this,
      override: DraftControllerProvider._internal(
        () => create()..leagueId = leagueId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        leagueId: leagueId,
      ),
    );
  }

  @override
  AutoDisposeStreamNotifierProviderElement<DraftController, DraftState>
  createElement() {
    return _DraftControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DraftControllerProvider && other.leagueId == leagueId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, leagueId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DraftControllerRef on AutoDisposeStreamNotifierProviderRef<DraftState> {
  /// The parameter `leagueId` of this provider.
  String get leagueId;
}

class _DraftControllerProviderElement
    extends
        AutoDisposeStreamNotifierProviderElement<DraftController, DraftState>
    with DraftControllerRef {
  _DraftControllerProviderElement(super.provider);

  @override
  String get leagueId => (origin as DraftControllerProvider).leagueId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
