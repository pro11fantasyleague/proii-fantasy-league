// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draft_pick.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DraftPickImpl _$$DraftPickImplFromJson(Map<String, dynamic> json) =>
    _$DraftPickImpl(
      id: json['id'] as String,
      leagueId: json['leagueId'] as String,
      managerId: json['managerId'] as String,
      teamId: json['teamId'] as String?,
      playerId: json['playerId'] as String,
      pickNumber: (json['pickNumber'] as num).toInt(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$DraftPickImplToJson(_$DraftPickImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'leagueId': instance.leagueId,
      'managerId': instance.managerId,
      'teamId': instance.teamId,
      'playerId': instance.playerId,
      'pickNumber': instance.pickNumber,
      'timestamp': instance.timestamp.toIso8601String(),
    };
