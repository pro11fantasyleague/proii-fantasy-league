// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Player _$PlayerFromJson(Map<String, dynamic> json) => Player(
  id: json['id'] as String,
  name: json['name'] as String,
  team: json['team'] as String,
  position: json['position'] as String,
  price: (json['price'] as num).toDouble(),
  adp: (json['adp'] as num).toDouble(),
  rosteredPct: (json['rosteredPct'] as num).toDouble(),
  imageUrl: json['imageUrl'] as String?,
  lastSeasonStats: PlayerStats.fromJson(
    json['lastSeasonStats'] as Map<String, dynamic>,
  ),
  statsHistory: PlayerStatsHistory.fromJson(
    json['statsHistory'] as Map<String, dynamic>,
  ),
  gameLog:
      (json['gameLog'] as List<dynamic>?)
          ?.map((e) => GameLog.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  isLocked: json['isLocked'] as bool? ?? false,
  matchStatus: json['matchStatus'] as String?,
  matchTime: json['matchTime'] as String?,
  rosterSlot: json['rosterSlot'] as String?,
  isStarter: json['isStarter'] as bool? ?? false,
);

Map<String, dynamic> _$PlayerToJson(Player instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'team': instance.team,
  'position': instance.position,
  'price': instance.price,
  'adp': instance.adp,
  'rosteredPct': instance.rosteredPct,
  'imageUrl': instance.imageUrl,
  'lastSeasonStats': instance.lastSeasonStats,
  'statsHistory': instance.statsHistory,
  'gameLog': instance.gameLog,
  'isLocked': instance.isLocked,
  'matchStatus': instance.matchStatus,
  'matchTime': instance.matchTime,
  'rosterSlot': instance.rosterSlot,
  'isStarter': instance.isStarter,
};

PlayerStats _$PlayerStatsFromJson(Map<String, dynamic> json) => PlayerStats(
  goals: (json['goals'] as num?)?.toInt() ?? 0,
  assists: (json['assists'] as num?)?.toInt() ?? 0,
  shots: (json['shots'] as num?)?.toInt() ?? 0,
  shotsOnTarget: (json['shotsOnTarget'] as num?)?.toInt() ?? 0,
  passes: (json['passes'] as num?)?.toInt() ?? 0,
  tackles: (json['tackles'] as num?)?.toInt() ?? 0,
  interceptions: (json['interceptions'] as num?)?.toInt() ?? 0,
  minutes: (json['minutes'] as num?)?.toInt() ?? 0,
  rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
  cleanSheets: (json['cleanSheets'] as num?)?.toInt() ?? 0,
  saves: (json['saves'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$PlayerStatsToJson(PlayerStats instance) =>
    <String, dynamic>{
      'goals': instance.goals,
      'assists': instance.assists,
      'shots': instance.shots,
      'shotsOnTarget': instance.shotsOnTarget,
      'passes': instance.passes,
      'tackles': instance.tackles,
      'interceptions': instance.interceptions,
      'minutes': instance.minutes,
      'rating': instance.rating,
      'cleanSheets': instance.cleanSheets,
      'saves': instance.saves,
    };

PlayerStatsHistory _$PlayerStatsHistoryFromJson(Map<String, dynamic> json) =>
    PlayerStatsHistory(
      lastMonth: json['lastMonth'] == null
          ? null
          : PlayerStats.fromJson(json['lastMonth'] as Map<String, dynamic>),
      currentSeason: json['currentSeason'] == null
          ? null
          : PlayerStats.fromJson(json['currentSeason'] as Map<String, dynamic>),
      prevSeason: json['prevSeason'] == null
          ? null
          : PlayerStats.fromJson(json['prevSeason'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PlayerStatsHistoryToJson(PlayerStatsHistory instance) =>
    <String, dynamic>{
      'lastMonth': instance.lastMonth,
      'currentSeason': instance.currentSeason,
      'prevSeason': instance.prevSeason,
    };

GameLog _$GameLogFromJson(Map<String, dynamic> json) => GameLog(
  date: json['date'] as String,
  opponent: json['opponent'] as String,
  result: json['result'] as String,
  score: (json['score'] as num).toDouble(),
  statsSummary: json['statsSummary'] as String,
);

Map<String, dynamic> _$GameLogToJson(GameLog instance) => <String, dynamic>{
  'date': instance.date,
  'opponent': instance.opponent,
  'result': instance.result,
  'score': instance.score,
  'statsSummary': instance.statsSummary,
};
