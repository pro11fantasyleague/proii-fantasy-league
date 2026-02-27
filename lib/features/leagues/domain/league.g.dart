// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'league.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeagueImpl _$$LeagueImplFromJson(Map<String, dynamic> json) => _$LeagueImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  inviteCode: json['invite_code'] as String?,
  adminId: json['admin_id'] as String,
  type: json['type'] as String,
  totalTeams: (json['total_teams'] as num).toInt(),
  draftDate: DateTime.parse(json['draft_date'] as String),
  configLeagues:
      (json['config_leagues'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  configScoring:
      (json['config_scoring'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  configRoster:
      (json['config_roster'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ) ??
      const {},
  isDraftStarted: json['is_draft_started'] as bool? ?? false,
  isDraftEnded: json['is_draft_ended'] as bool? ?? false,
);

Map<String, dynamic> _$$LeagueImplToJson(_$LeagueImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'invite_code': instance.inviteCode,
      'admin_id': instance.adminId,
      'type': instance.type,
      'total_teams': instance.totalTeams,
      'draft_date': instance.draftDate.toIso8601String(),
      'config_leagues': instance.configLeagues,
      'config_scoring': instance.configScoring,
      'config_roster': instance.configRoster,
      'is_draft_started': instance.isDraftStarted,
      'is_draft_ended': instance.isDraftEnded,
    };
