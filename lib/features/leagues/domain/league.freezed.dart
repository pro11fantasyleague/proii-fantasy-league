// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'league.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

League _$LeagueFromJson(Map<String, dynamic> json) {
  return _League.fromJson(json);
}

/// @nodoc
mixin _$League {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'invite_code')
  String? get inviteCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'admin_id')
  String get adminId => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // standard, keeper, dynasty
  @JsonKey(name: 'total_teams')
  int get totalTeams => throw _privateConstructorUsedError;
  @JsonKey(name: 'draft_date')
  DateTime get draftDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'config_leagues')
  List<String> get configLeagues => throw _privateConstructorUsedError;
  @JsonKey(name: 'config_scoring')
  List<String> get configScoring => throw _privateConstructorUsedError;
  @JsonKey(name: 'config_roster')
  Map<String, int> get configRoster => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_draft_started')
  bool get isDraftStarted => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_draft_ended')
  bool get isDraftEnded => throw _privateConstructorUsedError;

  /// Serializes this League to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of League
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LeagueCopyWith<League> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeagueCopyWith<$Res> {
  factory $LeagueCopyWith(League value, $Res Function(League) then) =
      _$LeagueCopyWithImpl<$Res, League>;
  @useResult
  $Res call({
    String id,
    String name,
    @JsonKey(name: 'invite_code') String? inviteCode,
    @JsonKey(name: 'admin_id') String adminId,
    String type,
    @JsonKey(name: 'total_teams') int totalTeams,
    @JsonKey(name: 'draft_date') DateTime draftDate,
    @JsonKey(name: 'config_leagues') List<String> configLeagues,
    @JsonKey(name: 'config_scoring') List<String> configScoring,
    @JsonKey(name: 'config_roster') Map<String, int> configRoster,
    @JsonKey(name: 'is_draft_started') bool isDraftStarted,
    @JsonKey(name: 'is_draft_ended') bool isDraftEnded,
  });
}

/// @nodoc
class _$LeagueCopyWithImpl<$Res, $Val extends League>
    implements $LeagueCopyWith<$Res> {
  _$LeagueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of League
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? inviteCode = freezed,
    Object? adminId = null,
    Object? type = null,
    Object? totalTeams = null,
    Object? draftDate = null,
    Object? configLeagues = null,
    Object? configScoring = null,
    Object? configRoster = null,
    Object? isDraftStarted = null,
    Object? isDraftEnded = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            inviteCode: freezed == inviteCode
                ? _value.inviteCode
                : inviteCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            adminId: null == adminId
                ? _value.adminId
                : adminId // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            totalTeams: null == totalTeams
                ? _value.totalTeams
                : totalTeams // ignore: cast_nullable_to_non_nullable
                      as int,
            draftDate: null == draftDate
                ? _value.draftDate
                : draftDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            configLeagues: null == configLeagues
                ? _value.configLeagues
                : configLeagues // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            configScoring: null == configScoring
                ? _value.configScoring
                : configScoring // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            configRoster: null == configRoster
                ? _value.configRoster
                : configRoster // ignore: cast_nullable_to_non_nullable
                      as Map<String, int>,
            isDraftStarted: null == isDraftStarted
                ? _value.isDraftStarted
                : isDraftStarted // ignore: cast_nullable_to_non_nullable
                      as bool,
            isDraftEnded: null == isDraftEnded
                ? _value.isDraftEnded
                : isDraftEnded // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LeagueImplCopyWith<$Res> implements $LeagueCopyWith<$Res> {
  factory _$$LeagueImplCopyWith(
    _$LeagueImpl value,
    $Res Function(_$LeagueImpl) then,
  ) = __$$LeagueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    @JsonKey(name: 'invite_code') String? inviteCode,
    @JsonKey(name: 'admin_id') String adminId,
    String type,
    @JsonKey(name: 'total_teams') int totalTeams,
    @JsonKey(name: 'draft_date') DateTime draftDate,
    @JsonKey(name: 'config_leagues') List<String> configLeagues,
    @JsonKey(name: 'config_scoring') List<String> configScoring,
    @JsonKey(name: 'config_roster') Map<String, int> configRoster,
    @JsonKey(name: 'is_draft_started') bool isDraftStarted,
    @JsonKey(name: 'is_draft_ended') bool isDraftEnded,
  });
}

/// @nodoc
class __$$LeagueImplCopyWithImpl<$Res>
    extends _$LeagueCopyWithImpl<$Res, _$LeagueImpl>
    implements _$$LeagueImplCopyWith<$Res> {
  __$$LeagueImplCopyWithImpl(
    _$LeagueImpl _value,
    $Res Function(_$LeagueImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of League
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? inviteCode = freezed,
    Object? adminId = null,
    Object? type = null,
    Object? totalTeams = null,
    Object? draftDate = null,
    Object? configLeagues = null,
    Object? configScoring = null,
    Object? configRoster = null,
    Object? isDraftStarted = null,
    Object? isDraftEnded = null,
  }) {
    return _then(
      _$LeagueImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        inviteCode: freezed == inviteCode
            ? _value.inviteCode
            : inviteCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        adminId: null == adminId
            ? _value.adminId
            : adminId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        totalTeams: null == totalTeams
            ? _value.totalTeams
            : totalTeams // ignore: cast_nullable_to_non_nullable
                  as int,
        draftDate: null == draftDate
            ? _value.draftDate
            : draftDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        configLeagues: null == configLeagues
            ? _value._configLeagues
            : configLeagues // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        configScoring: null == configScoring
            ? _value._configScoring
            : configScoring // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        configRoster: null == configRoster
            ? _value._configRoster
            : configRoster // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
        isDraftStarted: null == isDraftStarted
            ? _value.isDraftStarted
            : isDraftStarted // ignore: cast_nullable_to_non_nullable
                  as bool,
        isDraftEnded: null == isDraftEnded
            ? _value.isDraftEnded
            : isDraftEnded // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LeagueImpl extends _League {
  const _$LeagueImpl({
    required this.id,
    required this.name,
    @JsonKey(name: 'invite_code') this.inviteCode,
    @JsonKey(name: 'admin_id') required this.adminId,
    required this.type,
    @JsonKey(name: 'total_teams') required this.totalTeams,
    @JsonKey(name: 'draft_date') required this.draftDate,
    @JsonKey(name: 'config_leagues')
    final List<String> configLeagues = const [],
    @JsonKey(name: 'config_scoring')
    final List<String> configScoring = const [],
    @JsonKey(name: 'config_roster')
    final Map<String, int> configRoster = const {},
    @JsonKey(name: 'is_draft_started') this.isDraftStarted = false,
    @JsonKey(name: 'is_draft_ended') this.isDraftEnded = false,
  }) : _configLeagues = configLeagues,
       _configScoring = configScoring,
       _configRoster = configRoster,
       super._();

  factory _$LeagueImpl.fromJson(Map<String, dynamic> json) =>
      _$$LeagueImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey(name: 'invite_code')
  final String? inviteCode;
  @override
  @JsonKey(name: 'admin_id')
  final String adminId;
  @override
  final String type;
  // standard, keeper, dynasty
  @override
  @JsonKey(name: 'total_teams')
  final int totalTeams;
  @override
  @JsonKey(name: 'draft_date')
  final DateTime draftDate;
  final List<String> _configLeagues;
  @override
  @JsonKey(name: 'config_leagues')
  List<String> get configLeagues {
    if (_configLeagues is EqualUnmodifiableListView) return _configLeagues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_configLeagues);
  }

  final List<String> _configScoring;
  @override
  @JsonKey(name: 'config_scoring')
  List<String> get configScoring {
    if (_configScoring is EqualUnmodifiableListView) return _configScoring;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_configScoring);
  }

  final Map<String, int> _configRoster;
  @override
  @JsonKey(name: 'config_roster')
  Map<String, int> get configRoster {
    if (_configRoster is EqualUnmodifiableMapView) return _configRoster;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_configRoster);
  }

  @override
  @JsonKey(name: 'is_draft_started')
  final bool isDraftStarted;
  @override
  @JsonKey(name: 'is_draft_ended')
  final bool isDraftEnded;

  @override
  String toString() {
    return 'League(id: $id, name: $name, inviteCode: $inviteCode, adminId: $adminId, type: $type, totalTeams: $totalTeams, draftDate: $draftDate, configLeagues: $configLeagues, configScoring: $configScoring, configRoster: $configRoster, isDraftStarted: $isDraftStarted, isDraftEnded: $isDraftEnded)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeagueImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.inviteCode, inviteCode) ||
                other.inviteCode == inviteCode) &&
            (identical(other.adminId, adminId) || other.adminId == adminId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.totalTeams, totalTeams) ||
                other.totalTeams == totalTeams) &&
            (identical(other.draftDate, draftDate) ||
                other.draftDate == draftDate) &&
            const DeepCollectionEquality().equals(
              other._configLeagues,
              _configLeagues,
            ) &&
            const DeepCollectionEquality().equals(
              other._configScoring,
              _configScoring,
            ) &&
            const DeepCollectionEquality().equals(
              other._configRoster,
              _configRoster,
            ) &&
            (identical(other.isDraftStarted, isDraftStarted) ||
                other.isDraftStarted == isDraftStarted) &&
            (identical(other.isDraftEnded, isDraftEnded) ||
                other.isDraftEnded == isDraftEnded));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    inviteCode,
    adminId,
    type,
    totalTeams,
    draftDate,
    const DeepCollectionEquality().hash(_configLeagues),
    const DeepCollectionEquality().hash(_configScoring),
    const DeepCollectionEquality().hash(_configRoster),
    isDraftStarted,
    isDraftEnded,
  );

  /// Create a copy of League
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LeagueImplCopyWith<_$LeagueImpl> get copyWith =>
      __$$LeagueImplCopyWithImpl<_$LeagueImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LeagueImplToJson(this);
  }
}

abstract class _League extends League {
  const factory _League({
    required final String id,
    required final String name,
    @JsonKey(name: 'invite_code') final String? inviteCode,
    @JsonKey(name: 'admin_id') required final String adminId,
    required final String type,
    @JsonKey(name: 'total_teams') required final int totalTeams,
    @JsonKey(name: 'draft_date') required final DateTime draftDate,
    @JsonKey(name: 'config_leagues') final List<String> configLeagues,
    @JsonKey(name: 'config_scoring') final List<String> configScoring,
    @JsonKey(name: 'config_roster') final Map<String, int> configRoster,
    @JsonKey(name: 'is_draft_started') final bool isDraftStarted,
    @JsonKey(name: 'is_draft_ended') final bool isDraftEnded,
  }) = _$LeagueImpl;
  const _League._() : super._();

  factory _League.fromJson(Map<String, dynamic> json) = _$LeagueImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'invite_code')
  String? get inviteCode;
  @override
  @JsonKey(name: 'admin_id')
  String get adminId;
  @override
  String get type; // standard, keeper, dynasty
  @override
  @JsonKey(name: 'total_teams')
  int get totalTeams;
  @override
  @JsonKey(name: 'draft_date')
  DateTime get draftDate;
  @override
  @JsonKey(name: 'config_leagues')
  List<String> get configLeagues;
  @override
  @JsonKey(name: 'config_scoring')
  List<String> get configScoring;
  @override
  @JsonKey(name: 'config_roster')
  Map<String, int> get configRoster;
  @override
  @JsonKey(name: 'is_draft_started')
  bool get isDraftStarted;
  @override
  @JsonKey(name: 'is_draft_ended')
  bool get isDraftEnded;

  /// Create a copy of League
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LeagueImplCopyWith<_$LeagueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
