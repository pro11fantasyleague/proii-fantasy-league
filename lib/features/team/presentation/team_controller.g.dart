// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedPlayerHash() => r'3bd328812ddfec325517a58741a10b47f7780b2e';

/// See also [SelectedPlayer].
@ProviderFor(SelectedPlayer)
final selectedPlayerProvider =
    AutoDisposeNotifierProvider<SelectedPlayer, String?>.internal(
      SelectedPlayer.new,
      name: r'selectedPlayerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedPlayerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedPlayer = AutoDisposeNotifier<String?>;
String _$teamControllerHash() => r'08ed05665ce5bc5316b9e1a7da5392331d9c76c5';

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

abstract class _$TeamController
    extends BuildlessAutoDisposeAsyncNotifier<List<Player>> {
  late final String leagueId;

  FutureOr<List<Player>> build(String leagueId);
}

/// See also [TeamController].
@ProviderFor(TeamController)
const teamControllerProvider = TeamControllerFamily();

/// See also [TeamController].
class TeamControllerFamily extends Family<AsyncValue<List<Player>>> {
  /// See also [TeamController].
  const TeamControllerFamily();

  /// See also [TeamController].
  TeamControllerProvider call(String leagueId) {
    return TeamControllerProvider(leagueId);
  }

  @override
  TeamControllerProvider getProviderOverride(
    covariant TeamControllerProvider provider,
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
  String? get name => r'teamControllerProvider';
}

/// See also [TeamController].
class TeamControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<TeamController, List<Player>> {
  /// See also [TeamController].
  TeamControllerProvider(String leagueId)
    : this._internal(
        () => TeamController()..leagueId = leagueId,
        from: teamControllerProvider,
        name: r'teamControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$teamControllerHash,
        dependencies: TeamControllerFamily._dependencies,
        allTransitiveDependencies:
            TeamControllerFamily._allTransitiveDependencies,
        leagueId: leagueId,
      );

  TeamControllerProvider._internal(
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
  FutureOr<List<Player>> runNotifierBuild(covariant TeamController notifier) {
    return notifier.build(leagueId);
  }

  @override
  Override overrideWith(TeamController Function() create) {
    return ProviderOverride(
      origin: this,
      override: TeamControllerProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<TeamController, List<Player>>
  createElement() {
    return _TeamControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TeamControllerProvider && other.leagueId == leagueId;
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
mixin TeamControllerRef on AutoDisposeAsyncNotifierProviderRef<List<Player>> {
  /// The parameter `leagueId` of this provider.
  String get leagueId;
}

class _TeamControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<TeamController, List<Player>>
    with TeamControllerRef {
  _TeamControllerProviderElement(super.provider);

  @override
  String get leagueId => (origin as TeamControllerProvider).leagueId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
