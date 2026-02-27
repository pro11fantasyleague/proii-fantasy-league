// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'draft_pick.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DraftPick _$DraftPickFromJson(Map<String, dynamic> json) {
  return _DraftPick.fromJson(json);
}

/// @nodoc
mixin _$DraftPick {
  String get id => throw _privateConstructorUsedError;
  String get leagueId => throw _privateConstructorUsedError;
  String get managerId => throw _privateConstructorUsedError;
  String? get teamId => throw _privateConstructorUsedError;
  String get playerId => throw _privateConstructorUsedError;
  int get pickNumber => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Serializes this DraftPick to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DraftPick
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DraftPickCopyWith<DraftPick> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DraftPickCopyWith<$Res> {
  factory $DraftPickCopyWith(DraftPick value, $Res Function(DraftPick) then) =
      _$DraftPickCopyWithImpl<$Res, DraftPick>;
  @useResult
  $Res call({
    String id,
    String leagueId,
    String managerId,
    String? teamId,
    String playerId,
    int pickNumber,
    DateTime timestamp,
  });
}

/// @nodoc
class _$DraftPickCopyWithImpl<$Res, $Val extends DraftPick>
    implements $DraftPickCopyWith<$Res> {
  _$DraftPickCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DraftPick
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? leagueId = null,
    Object? managerId = null,
    Object? teamId = freezed,
    Object? playerId = null,
    Object? pickNumber = null,
    Object? timestamp = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            leagueId: null == leagueId
                ? _value.leagueId
                : leagueId // ignore: cast_nullable_to_non_nullable
                      as String,
            managerId: null == managerId
                ? _value.managerId
                : managerId // ignore: cast_nullable_to_non_nullable
                      as String,
            teamId: freezed == teamId
                ? _value.teamId
                : teamId // ignore: cast_nullable_to_non_nullable
                      as String?,
            playerId: null == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String,
            pickNumber: null == pickNumber
                ? _value.pickNumber
                : pickNumber // ignore: cast_nullable_to_non_nullable
                      as int,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DraftPickImplCopyWith<$Res>
    implements $DraftPickCopyWith<$Res> {
  factory _$$DraftPickImplCopyWith(
    _$DraftPickImpl value,
    $Res Function(_$DraftPickImpl) then,
  ) = __$$DraftPickImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String leagueId,
    String managerId,
    String? teamId,
    String playerId,
    int pickNumber,
    DateTime timestamp,
  });
}

/// @nodoc
class __$$DraftPickImplCopyWithImpl<$Res>
    extends _$DraftPickCopyWithImpl<$Res, _$DraftPickImpl>
    implements _$$DraftPickImplCopyWith<$Res> {
  __$$DraftPickImplCopyWithImpl(
    _$DraftPickImpl _value,
    $Res Function(_$DraftPickImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DraftPick
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? leagueId = null,
    Object? managerId = null,
    Object? teamId = freezed,
    Object? playerId = null,
    Object? pickNumber = null,
    Object? timestamp = null,
  }) {
    return _then(
      _$DraftPickImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        leagueId: null == leagueId
            ? _value.leagueId
            : leagueId // ignore: cast_nullable_to_non_nullable
                  as String,
        managerId: null == managerId
            ? _value.managerId
            : managerId // ignore: cast_nullable_to_non_nullable
                  as String,
        teamId: freezed == teamId
            ? _value.teamId
            : teamId // ignore: cast_nullable_to_non_nullable
                  as String?,
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        pickNumber: null == pickNumber
            ? _value.pickNumber
            : pickNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DraftPickImpl implements _DraftPick {
  const _$DraftPickImpl({
    required this.id,
    required this.leagueId,
    required this.managerId,
    this.teamId,
    required this.playerId,
    required this.pickNumber,
    required this.timestamp,
  });

  factory _$DraftPickImpl.fromJson(Map<String, dynamic> json) =>
      _$$DraftPickImplFromJson(json);

  @override
  final String id;
  @override
  final String leagueId;
  @override
  final String managerId;
  @override
  final String? teamId;
  @override
  final String playerId;
  @override
  final int pickNumber;
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'DraftPick(id: $id, leagueId: $leagueId, managerId: $managerId, teamId: $teamId, playerId: $playerId, pickNumber: $pickNumber, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DraftPickImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.leagueId, leagueId) ||
                other.leagueId == leagueId) &&
            (identical(other.managerId, managerId) ||
                other.managerId == managerId) &&
            (identical(other.teamId, teamId) || other.teamId == teamId) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.pickNumber, pickNumber) ||
                other.pickNumber == pickNumber) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    leagueId,
    managerId,
    teamId,
    playerId,
    pickNumber,
    timestamp,
  );

  /// Create a copy of DraftPick
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DraftPickImplCopyWith<_$DraftPickImpl> get copyWith =>
      __$$DraftPickImplCopyWithImpl<_$DraftPickImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DraftPickImplToJson(this);
  }
}

abstract class _DraftPick implements DraftPick {
  const factory _DraftPick({
    required final String id,
    required final String leagueId,
    required final String managerId,
    final String? teamId,
    required final String playerId,
    required final int pickNumber,
    required final DateTime timestamp,
  }) = _$DraftPickImpl;

  factory _DraftPick.fromJson(Map<String, dynamic> json) =
      _$DraftPickImpl.fromJson;

  @override
  String get id;
  @override
  String get leagueId;
  @override
  String get managerId;
  @override
  String? get teamId;
  @override
  String get playerId;
  @override
  int get pickNumber;
  @override
  DateTime get timestamp;

  /// Create a copy of DraftPick
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DraftPickImplCopyWith<_$DraftPickImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
