// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_stats_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserStatsData _$UserStatsDataFromJson(Map<String, dynamic> json) {
  return _UserStatsData.fromJson(json);
}

/// @nodoc
mixin _$UserStatsData {
  int get seasonsPlayed => throw _privateConstructorUsedError;
  int get champions => throw _privateConstructorUsedError;
  int get podiums => throw _privateConstructorUsedError;
  int get mvps => throw _privateConstructorUsedError;

  /// Serializes this UserStatsData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserStatsData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserStatsDataCopyWith<UserStatsData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserStatsDataCopyWith<$Res> {
  factory $UserStatsDataCopyWith(
    UserStatsData value,
    $Res Function(UserStatsData) then,
  ) = _$UserStatsDataCopyWithImpl<$Res, UserStatsData>;
  @useResult
  $Res call({int seasonsPlayed, int champions, int podiums, int mvps});
}

/// @nodoc
class _$UserStatsDataCopyWithImpl<$Res, $Val extends UserStatsData>
    implements $UserStatsDataCopyWith<$Res> {
  _$UserStatsDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserStatsData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? seasonsPlayed = null,
    Object? champions = null,
    Object? podiums = null,
    Object? mvps = null,
  }) {
    return _then(
      _value.copyWith(
            seasonsPlayed: null == seasonsPlayed
                ? _value.seasonsPlayed
                : seasonsPlayed // ignore: cast_nullable_to_non_nullable
                      as int,
            champions: null == champions
                ? _value.champions
                : champions // ignore: cast_nullable_to_non_nullable
                      as int,
            podiums: null == podiums
                ? _value.podiums
                : podiums // ignore: cast_nullable_to_non_nullable
                      as int,
            mvps: null == mvps
                ? _value.mvps
                : mvps // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserStatsDataImplCopyWith<$Res>
    implements $UserStatsDataCopyWith<$Res> {
  factory _$$UserStatsDataImplCopyWith(
    _$UserStatsDataImpl value,
    $Res Function(_$UserStatsDataImpl) then,
  ) = __$$UserStatsDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int seasonsPlayed, int champions, int podiums, int mvps});
}

/// @nodoc
class __$$UserStatsDataImplCopyWithImpl<$Res>
    extends _$UserStatsDataCopyWithImpl<$Res, _$UserStatsDataImpl>
    implements _$$UserStatsDataImplCopyWith<$Res> {
  __$$UserStatsDataImplCopyWithImpl(
    _$UserStatsDataImpl _value,
    $Res Function(_$UserStatsDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserStatsData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? seasonsPlayed = null,
    Object? champions = null,
    Object? podiums = null,
    Object? mvps = null,
  }) {
    return _then(
      _$UserStatsDataImpl(
        seasonsPlayed: null == seasonsPlayed
            ? _value.seasonsPlayed
            : seasonsPlayed // ignore: cast_nullable_to_non_nullable
                  as int,
        champions: null == champions
            ? _value.champions
            : champions // ignore: cast_nullable_to_non_nullable
                  as int,
        podiums: null == podiums
            ? _value.podiums
            : podiums // ignore: cast_nullable_to_non_nullable
                  as int,
        mvps: null == mvps
            ? _value.mvps
            : mvps // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserStatsDataImpl implements _UserStatsData {
  const _$UserStatsDataImpl({
    this.seasonsPlayed = 0,
    this.champions = 0,
    this.podiums = 0,
    this.mvps = 0,
  });

  factory _$UserStatsDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserStatsDataImplFromJson(json);

  @override
  @JsonKey()
  final int seasonsPlayed;
  @override
  @JsonKey()
  final int champions;
  @override
  @JsonKey()
  final int podiums;
  @override
  @JsonKey()
  final int mvps;

  @override
  String toString() {
    return 'UserStatsData(seasonsPlayed: $seasonsPlayed, champions: $champions, podiums: $podiums, mvps: $mvps)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserStatsDataImpl &&
            (identical(other.seasonsPlayed, seasonsPlayed) ||
                other.seasonsPlayed == seasonsPlayed) &&
            (identical(other.champions, champions) ||
                other.champions == champions) &&
            (identical(other.podiums, podiums) || other.podiums == podiums) &&
            (identical(other.mvps, mvps) || other.mvps == mvps));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, seasonsPlayed, champions, podiums, mvps);

  /// Create a copy of UserStatsData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserStatsDataImplCopyWith<_$UserStatsDataImpl> get copyWith =>
      __$$UserStatsDataImplCopyWithImpl<_$UserStatsDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserStatsDataImplToJson(this);
  }
}

abstract class _UserStatsData implements UserStatsData {
  const factory _UserStatsData({
    final int seasonsPlayed,
    final int champions,
    final int podiums,
    final int mvps,
  }) = _$UserStatsDataImpl;

  factory _UserStatsData.fromJson(Map<String, dynamic> json) =
      _$UserStatsDataImpl.fromJson;

  @override
  int get seasonsPlayed;
  @override
  int get champions;
  @override
  int get podiums;
  @override
  int get mvps;

  /// Create a copy of UserStatsData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserStatsDataImplCopyWith<_$UserStatsDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
