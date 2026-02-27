import 'package:fpdart/fpdart.dart';
import '../../../core/exceptions/failure.dart';
import 'team.dart';
import 'player.dart';

abstract class TeamRepository {
  Future<Either<Failure, Team?>> getMyTeam(String leagueId);
  Future<Either<Failure, void>> createTeam(String leagueId, String name);
  Future<Either<Failure, void>> addPlayer(String teamId, String playerId);
  Future<Either<Failure, void>> removePlayer(String teamId, String playerId);
  Future<Either<Failure, List<Player>>> getTeamRoster(String teamId);
  Future<Either<Failure, List<Player>>> getMyRoster(String leagueId);
  Future<void> updateRosterPositions(List<Map<String, dynamic>> updates);
}
