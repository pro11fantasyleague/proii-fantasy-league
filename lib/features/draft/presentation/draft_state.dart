import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:proii_fantasy_league/features/draft/domain/draft_pick.dart';

part 'draft_state.freezed.dart';

@freezed
class DraftState with _$DraftState {
  const factory DraftState({
    @Default([]) List<DraftPick> picks,
    @Default(60) int timeLeft,
    String? currentTeamId,
    @Default(false) bool isMyTurn,
    @Default(1) int currentPickNumber,
    @Default(DraftStatus.scheduled) DraftStatus status,
  }) = _DraftState;
}

enum DraftStatus { scheduled, live, paused, finished }
