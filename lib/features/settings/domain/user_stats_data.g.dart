// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stats_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserStatsDataImpl _$$UserStatsDataImplFromJson(Map<String, dynamic> json) =>
    _$UserStatsDataImpl(
      seasonsPlayed: (json['seasonsPlayed'] as num?)?.toInt() ?? 0,
      champions: (json['champions'] as num?)?.toInt() ?? 0,
      podiums: (json['podiums'] as num?)?.toInt() ?? 0,
      mvps: (json['mvps'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$UserStatsDataImplToJson(_$UserStatsDataImpl instance) =>
    <String, dynamic>{
      'seasonsPlayed': instance.seasonsPlayed,
      'champions': instance.champions,
      'podiums': instance.podiums,
      'mvps': instance.mvps,
    };
