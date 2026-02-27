import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_stats_data.freezed.dart';
part 'user_stats_data.g.dart';

@freezed
class UserStatsData with _$UserStatsData {
  const factory UserStatsData({
    @Default(0) int seasonsPlayed,
    @Default(0) int champions,
    @Default(0) int podiums,
    @Default(0) int mvps,
  }) = _UserStatsData;

  factory UserStatsData.fromJson(Map<String, dynamic> json) => _$UserStatsDataFromJson(json);
}

// Extension to determine Manager Title and Badge Color
extension ManagerBadge on UserStatsData {
  String get title {
    if (seasonsPlayed >= 10) return "LÉGENDE";
    if (seasonsPlayed >= 5) return "MANAGER VÉTÉRAN";
    if (seasonsPlayed >= 2) return "MANAGER CONFIRMÉ";
    return "MANAGER ROOKIE";
  }

  int get badgeColorHex {
    if (seasonsPlayed >= 10) return 0xFFFFD700; // Gold
    if (seasonsPlayed >= 5) return 0xFFA855F7;  // Purple
    if (seasonsPlayed >= 2) return 0xFF00FF9A;  // Neon Green
    return 0xFF00E0FF;  // Cyan (Rookie)
  }
}
