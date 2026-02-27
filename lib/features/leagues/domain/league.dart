import 'package:freezed_annotation/freezed_annotation.dart';

part 'league.freezed.dart';
part 'league.g.dart';

@freezed
class League with _$League {
  const factory League({
    required String id,
    required String name,
    @JsonKey(name: 'invite_code') String? inviteCode,
    @JsonKey(name: 'admin_id') required String adminId,
    required String type, // standard, keeper, dynasty
    @JsonKey(name: 'total_teams') required int totalTeams,
    @JsonKey(name: 'draft_date') required DateTime draftDate,
    @JsonKey(name: 'config_leagues') @Default([]) List<String> configLeagues,
    @JsonKey(name: 'config_scoring') @Default([]) List<String> configScoring,
    @JsonKey(name: 'config_roster') @Default({}) Map<String, int> configRoster,
    @JsonKey(name: 'is_draft_started') @Default(false) bool isDraftStarted,
    @JsonKey(name: 'is_draft_ended') @Default(false) bool isDraftEnded,
  }) = _League;

  const League._();

  factory League.fromJson(Map<String, dynamic> json) => _$LeagueFromJson(json);

  LeagueStatus get status {
    if (isDraftEnded) return LeagueStatus.active; // Assumes active after draft
    if (isDraftStarted) return LeagueStatus.drafting;
    return LeagueStatus.pending;
  }
}

enum LeagueStatus {
  pending,
  drafting,
  active,
  finished
}
