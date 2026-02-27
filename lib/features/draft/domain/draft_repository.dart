import 'package:fpdart/fpdart.dart';
import '../../../core/exceptions/failure.dart';
import 'draft_pick.dart';

abstract class DraftRepository {
  Stream<List<DraftPick>> watchDraftPicks(String leagueId);
  Future<Either<Failure, void>> makePick({required String leagueId, required String playerId, required int pickNumber});
}
