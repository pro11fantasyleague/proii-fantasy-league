import 'package:json_annotation/json_annotation.dart';

part 'player.g.dart';

@JsonSerializable()
class Player {
  final String id;
  final String name;
  final String team;
  final String position; // 'GK', 'DEF', 'MID', 'ATT'
  final double price;
  final double adp; // Average Draft Position
  final double rosteredPct;
  final String? imageUrl;
  final PlayerStats lastSeasonStats;
  final PlayerStatsHistory statsHistory;
  final List<GameLog> gameLog;
  final bool isLocked; // Pour le status de match (Live/Fini)
  final String? matchStatus; // 'scheduled', 'live', 'finished'
  final String? matchTime; // 'Sat 15:00', '34''
  
  // Roster specific fields (Not in 'players' table, but from 'team_roster' join)
  final String? rosterSlot; // 'GK', 'DEF', 'BENCH'
  final bool isStarter;

  const Player({
    required this.id,
    required this.name,
    required this.team,
    required this.position,
    required this.price,
    required this.adp,
    required this.rosteredPct,
    this.imageUrl,
    required this.lastSeasonStats,
    required this.statsHistory,
    this.gameLog = const [],
    this.isLocked = false,
    this.matchStatus,
    this.matchTime,
    this.rosterSlot,
    this.isStarter = false,
  });

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);
  
  factory Player.fromRosterJson(Map<String, dynamic> json) {
    final playerJson = json['players'] as Map<String, dynamic>;
    final player = Player.fromJson(playerJson);
    
    // Enrich with Roster Data
    return player.copyWith(
      rosterSlot: json['position_slot'] as String?,
      isStarter: json['is_starter'] as bool? ?? false,
    );
  }
  
  // Helper copyWith for local state updates
  Player copyWith({
    String? rosterSlot,
    bool? isStarter,
    bool? isLocked,
  }) {
    return Player(
      id: id,
      name: name,
      team: team,
      position: position,
      price: price,
      adp: adp,
      rosteredPct: rosteredPct,
      imageUrl: imageUrl,
      lastSeasonStats: lastSeasonStats,
      statsHistory: statsHistory,
      gameLog: gameLog,
      isLocked: isLocked ?? this.isLocked,
      matchStatus: matchStatus,
      matchTime: matchTime,
      rosterSlot: rosterSlot ?? this.rosterSlot,
      isStarter: isStarter ?? this.isStarter,
    );
  }

  Map<String, dynamic> toJson() => _$PlayerToJson(this);
}

@JsonSerializable()
class PlayerStats {
  final int goals;
  final int assists;
  final int shots;
  final int shotsOnTarget;
  final int passes;
  final int tackles;
  final int interceptions;
  final int minutes;
  final double rating;
  final int cleanSheets;
  final int saves;

  const PlayerStats({
    this.goals = 0,
    this.assists = 0,
    this.shots = 0,
    this.shotsOnTarget = 0,
    this.passes = 0,
    this.tackles = 0,
    this.interceptions = 0,
    this.minutes = 0,
    this.rating = 0.0,
    this.cleanSheets = 0,
    this.saves = 0,
  });

  factory PlayerStats.fromJson(Map<String, dynamic> json) => _$PlayerStatsFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerStatsToJson(this);
}

@JsonSerializable()
class PlayerStatsHistory {
  final PlayerStats? lastMonth;
  final PlayerStats? currentSeason;
  final PlayerStats? prevSeason;

  const PlayerStatsHistory({
    this.lastMonth,
    this.currentSeason,
    this.prevSeason,
  });

  factory PlayerStatsHistory.fromJson(Map<String, dynamic> json) => _$PlayerStatsHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerStatsHistoryToJson(this);
}

@JsonSerializable()
class GameLog {
  final String date;
  final String opponent;
  final String result; // "W 2-1"
  final double score;
  final String statsSummary; // "1 But"

  const GameLog({
    required this.date,
    required this.opponent,
    required this.result,
    required this.score,
    required this.statsSummary,
  });

  factory GameLog.fromJson(Map<String, dynamic> json) => _$GameLogFromJson(json);
  Map<String, dynamic> toJson() => _$GameLogToJson(this);
}
