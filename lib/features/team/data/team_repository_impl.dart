import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/exceptions/failure.dart';
import '../../../core/storage/hive_service.dart';
import '../domain/team_repository.dart';
import '../domain/team.dart';
import '../domain/player.dart';

class TeamRepositoryImpl implements TeamRepository {
  final SupabaseClient _supabase;
  final HiveService _hive;

  TeamRepositoryImpl(this._supabase, this._hive);

  @override
  Future<Either<Failure, Team?>> getMyTeam(String leagueId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return left(const AuthFailure('User not logged in'));

      final response = await _supabase
          .from('teams')
          .select()
          .eq('owner_id', userId)
          .eq('league_id', leagueId)
          .maybeSingle();

      if (response == null) return right(null);
      return right(Team.fromJson(response));
    } catch (e) {
      if (e is PostgrestException) {
         return left(NetworkFailure(e.message));
      }
      return left(NetworkFailure('Failed to fetch team: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> createTeam(String leagueId, String name) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return left(const AuthFailure('User not logged in'));

      await _supabase.from('teams').insert({
        'name': name,
        'owner_id': userId,
        'league_id': leagueId,
        'budget': 100, // Default budget
      });
      return right(null);
    } catch (e) {
      return left(NetworkFailure('Failed to create team: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> addPlayer(String teamId, String playerId) async {
     try {
       await _supabase.rpc('add_player_to_team', params: {
         'p_team_id': teamId, 
         'p_player_id': playerId
       }); 
       return right(null);
     } catch(e) {
       return left(NetworkFailure('Failed to add player: $e'));
     }
  }
  
  @override
  Future<Either<Failure, void>> removePlayer(String teamId, String playerId) async {
     try {
       await _supabase.rpc('remove_player_from_team', params: {
         'p_team_id': teamId, 
         'p_player_id': playerId
       });
       return right(null);
     } catch(e) {
       return left(NetworkFailure('Failed to remove player: $e'));
     }
  }

  @override
  Future<Either<Failure, List<Player>>> getTeamRoster(String teamId) async {
    // Basic implementation for viewing other teams
    try {
      final response = await _supabase
          .from('team_roster')
          .select('*, players(*)')
          .eq('team_id', teamId);
          
      final players = (response as List).map((data) {
          return Player.fromRosterJson(data); 
      }).toList();
      
      return right(players);
    } catch (e) {
      return left(NetworkFailure('Failed to get roster: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Player>>> getMyRoster(String leagueId) async {
    try {
      final userId = _supabase.auth.currentUser!.id;
      
      // Récupération des joueurs de mon équipe
      final response = await _supabase
          .from('team_roster')
          .select('*, players(*)') // Jointure pour avoir les détails du joueur
          .eq('league_id', leagueId)
          .eq('owner_id', userId);

      // Mapping...
      final players = (response as List).map((data) {
          // Fusionner les données de roster (position slot) avec les données joueur
          return Player.fromRosterJson(data); 
      }).toList();

      // Cache
      await _hive.saveList(HiveService.boxTeam, 'roster_$leagueId', response);

      return right(players);
    } catch (e) {
      // Fallback Cache
      if (_hive.hasData(HiveService.boxTeam, 'roster_$leagueId')) {
         final cached = _hive.getList(HiveService.boxTeam, 'roster_$leagueId');
         if (cached != null) {
            final players = cached.map((data) {
                return Player.fromRosterJson(data); 
            }).toList();
            return right(players);
         }
      }
      return left(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<void> updateRosterPositions(List<Map<String, dynamic>> updates) async {
    // Call Secure RPC
    await _supabase.rpc('update_lineup', params: {
      'p_updates': updates,
    });
  }
}
