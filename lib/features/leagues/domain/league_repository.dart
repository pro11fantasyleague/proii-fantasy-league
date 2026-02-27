import 'package:fpdart/fpdart.dart';
import '../../../core/exceptions/failure.dart';
import 'league.dart';

abstract class LeagueRepository {
  Future<Either<Failure, List<League>>> getMyLeagues();
  Future<Either<Failure, String>> createLeague(String name, String mode, int teams, DateTime draftDate);
  Future<Either<Failure, void>> updateLeagueConfig({
    required String leagueId,
    required List<String> leagues,
    required List<String> scoring,
    required Map<String, int> roster,
  });
  Future<Either<Failure, League?>> getLeague(String id);
  Future<Either<Failure, void>> joinLeague(String code);
}
