import 'package:freezed_annotation/freezed_annotation.dart';

part 'draft_pick.freezed.dart';
part 'draft_pick.g.dart';

@freezed
class DraftPick with _$DraftPick {
  const factory DraftPick({
    required String id,
    required String leagueId,
    required String managerId,
    String? teamId,
    required String playerId,
    required int pickNumber,
    required DateTime timestamp,
  }) = _DraftPick;

  factory DraftPick.fromJson(Map<String, dynamic> json) => _$DraftPickFromJson(json);
}
