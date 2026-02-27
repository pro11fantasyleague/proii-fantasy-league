// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'draft_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DraftState {
  List<DraftPick> get picks => throw _privateConstructorUsedError;
  int get timeLeft => throw _privateConstructorUsedError;
  String? get currentTeamId => throw _privateConstructorUsedError;
  bool get isMyTurn => throw _privateConstructorUsedError;
  int get currentPickNumber => throw _privateConstructorUsedError;
  DraftStatus get status => throw _privateConstructorUsedError;

  /// Create a copy of DraftState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DraftStateCopyWith<DraftState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DraftStateCopyWith<$Res> {
  factory $DraftStateCopyWith(
    DraftState value,
    $Res Function(DraftState) then,
  ) = _$DraftStateCopyWithImpl<$Res, DraftState>;
  @useResult
  $Res call({
    List<DraftPick> picks,
    int timeLeft,
    String? currentTeamId,
    bool isMyTurn,
    int currentPickNumber,
    DraftStatus status,
  });
}

/// @nodoc
class _$DraftStateCopyWithImpl<$Res, $Val extends DraftState>
    implements $DraftStateCopyWith<$Res> {
  _$DraftStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DraftState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? picks = null,
    Object? timeLeft = null,
    Object? currentTeamId = freezed,
    Object? isMyTurn = null,
    Object? currentPickNumber = null,
    Object? status = null,
  }) {
    return _then(
      _value.copyWith(
            picks: null == picks
                ? _value.picks
                : picks // ignore: cast_nullable_to_non_nullable
                      as List<DraftPick>,
            timeLeft: null == timeLeft
                ? _value.timeLeft
                : timeLeft // ignore: cast_nullable_to_non_nullable
                      as int,
            currentTeamId: freezed == currentTeamId
                ? _value.currentTeamId
                : currentTeamId // ignore: cast_nullable_to_non_nullable
                      as String?,
            isMyTurn: null == isMyTurn
                ? _value.isMyTurn
                : isMyTurn // ignore: cast_nullable_to_non_nullable
                      as bool,
            currentPickNumber: null == currentPickNumber
                ? _value.currentPickNumber
                : currentPickNumber // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as DraftStatus,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DraftStateImplCopyWith<$Res>
    implements $DraftStateCopyWith<$Res> {
  factory _$$DraftStateImplCopyWith(
    _$DraftStateImpl value,
    $Res Function(_$DraftStateImpl) then,
  ) = __$$DraftStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<DraftPick> picks,
    int timeLeft,
    String? currentTeamId,
    bool isMyTurn,
    int currentPickNumber,
    DraftStatus status,
  });
}

/// @nodoc
class __$$DraftStateImplCopyWithImpl<$Res>
    extends _$DraftStateCopyWithImpl<$Res, _$DraftStateImpl>
    implements _$$DraftStateImplCopyWith<$Res> {
  __$$DraftStateImplCopyWithImpl(
    _$DraftStateImpl _value,
    $Res Function(_$DraftStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DraftState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? picks = null,
    Object? timeLeft = null,
    Object? currentTeamId = freezed,
    Object? isMyTurn = null,
    Object? currentPickNumber = null,
    Object? status = null,
  }) {
    return _then(
      _$DraftStateImpl(
        picks: null == picks
            ? _value._picks
            : picks // ignore: cast_nullable_to_non_nullable
                  as List<DraftPick>,
        timeLeft: null == timeLeft
            ? _value.timeLeft
            : timeLeft // ignore: cast_nullable_to_non_nullable
                  as int,
        currentTeamId: freezed == currentTeamId
            ? _value.currentTeamId
            : currentTeamId // ignore: cast_nullable_to_non_nullable
                  as String?,
        isMyTurn: null == isMyTurn
            ? _value.isMyTurn
            : isMyTurn // ignore: cast_nullable_to_non_nullable
                  as bool,
        currentPickNumber: null == currentPickNumber
            ? _value.currentPickNumber
            : currentPickNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as DraftStatus,
      ),
    );
  }
}

/// @nodoc

class _$DraftStateImpl implements _DraftState {
  const _$DraftStateImpl({
    final List<DraftPick> picks = const [],
    this.timeLeft = 60,
    this.currentTeamId,
    this.isMyTurn = false,
    this.currentPickNumber = 1,
    this.status = DraftStatus.scheduled,
  }) : _picks = picks;

  final List<DraftPick> _picks;
  @override
  @JsonKey()
  List<DraftPick> get picks {
    if (_picks is EqualUnmodifiableListView) return _picks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_picks);
  }

  @override
  @JsonKey()
  final int timeLeft;
  @override
  final String? currentTeamId;
  @override
  @JsonKey()
  final bool isMyTurn;
  @override
  @JsonKey()
  final int currentPickNumber;
  @override
  @JsonKey()
  final DraftStatus status;

  @override
  String toString() {
    return 'DraftState(picks: $picks, timeLeft: $timeLeft, currentTeamId: $currentTeamId, isMyTurn: $isMyTurn, currentPickNumber: $currentPickNumber, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DraftStateImpl &&
            const DeepCollectionEquality().equals(other._picks, _picks) &&
            (identical(other.timeLeft, timeLeft) ||
                other.timeLeft == timeLeft) &&
            (identical(other.currentTeamId, currentTeamId) ||
                other.currentTeamId == currentTeamId) &&
            (identical(other.isMyTurn, isMyTurn) ||
                other.isMyTurn == isMyTurn) &&
            (identical(other.currentPickNumber, currentPickNumber) ||
                other.currentPickNumber == currentPickNumber) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_picks),
    timeLeft,
    currentTeamId,
    isMyTurn,
    currentPickNumber,
    status,
  );

  /// Create a copy of DraftState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DraftStateImplCopyWith<_$DraftStateImpl> get copyWith =>
      __$$DraftStateImplCopyWithImpl<_$DraftStateImpl>(this, _$identity);
}

abstract class _DraftState implements DraftState {
  const factory _DraftState({
    final List<DraftPick> picks,
    final int timeLeft,
    final String? currentTeamId,
    final bool isMyTurn,
    final int currentPickNumber,
    final DraftStatus status,
  }) = _$DraftStateImpl;

  @override
  List<DraftPick> get picks;
  @override
  int get timeLeft;
  @override
  String? get currentTeamId;
  @override
  bool get isMyTurn;
  @override
  int get currentPickNumber;
  @override
  DraftStatus get status;

  /// Create a copy of DraftState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DraftStateImplCopyWith<_$DraftStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
