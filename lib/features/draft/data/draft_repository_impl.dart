import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:fpdart/fpdart.dart';
import '../../../core/exceptions/failure.dart';
import '../domain/draft_repository.dart';
import '../domain/draft_pick.dart';

class DraftRepositoryImpl implements DraftRepository {
  final supabase.SupabaseClient _supabase;

  DraftRepositoryImpl(this._supabase);

  @override
  Stream<List<DraftPick>> watchDraftPicks(String leagueId) {
    return _supabase
        .from('draft_picks')
        .stream(primaryKey: ['id'])
        .eq('league_id', leagueId)
        .order('pick_number', ascending: true)
        .map((maps) => maps.map((map) => DraftPick.fromJson(map)).toList());
  }

  @override
  Future<Either<Failure, void>> makePick({required String leagueId, required String playerId, required int pickNumber}) async {
    try {
      final userId = _supabase.auth.currentUser!.id;
      
      // Call Secure RPC
      await _supabase.rpc('make_pick', params: {
        'p_league_id': leagueId,
        'p_player_id': playerId,
        'p_manager_id': userId,
      });

      return right(null);
    } catch (e) {
      if (e is supabase.PostgrestException) {
           return left(NetworkFailure(e.message));
      }
      return left(NetworkFailure('Failed to make pick: $e'));
    }
  }
}


