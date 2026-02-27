import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/exceptions/failure.dart';
import '../../../core/storage/hive_service.dart';
import '../domain/league_repository.dart';
import '../domain/league.dart';

class LeagueRepositoryImpl implements LeagueRepository {
  final SupabaseClient _supabase;
  final HiveService _hive;

  LeagueRepositoryImpl(this._supabase, this._hive);

  @override
  Future<Either<Failure, List<League>>> getMyLeagues() async {
    try {
      // 1. Tenter l'appel réseau
      final userId = _supabase.auth.currentUser!.id;
      final response = await _supabase
          .from('league_members')
          .select('leagues(*)') // Jointure pour avoir les infos de la ligue
          .eq('user_id', userId);

      final List<dynamic> data = response.map((e) => e['leagues']).where((e) => e != null).toList();
      
      // 2. Transformer en Models
      final leagues = data.map((json) {
        print('PARSING LEAGUE JSON: $json');
        final Map<String, dynamic> safeJson = Map<String, dynamic>.from(json);
        if (safeJson['admin_id'] == null) safeJson['admin_id'] = '';
        if (safeJson['type'] == null) safeJson['type'] = 'standard';
        return League.fromJson(safeJson);
      }).toList();

      // 3. Sauvegarder dans le cache local (Hive)
      await _hive.saveList(HiveService.boxLeagues, 'my_leagues', data);

      return right(leagues);

    } catch (e) {
      print('ERROR IN getMyLeagues: $e');
      // 4. En cas d'erreur (ex: Pas d'internet), tenter le cache
      if (_hive.hasData(HiveService.boxLeagues, 'my_leagues')) {
        final cachedData = _hive.getList(HiveService.boxLeagues, 'my_leagues');
        if (cachedData != null) {
          final leagues = cachedData.map((json) => League.fromJson(json)).toList();
          return right(leagues); // Succès (Mode dégradé/Offline)
        }
      }
      
      // 5. Si pas de cache, échec total
      return left(NetworkFailure('Pas de connexion et aucun cache disponible.'));
    }
  }

  @override
  Future<Either<Failure, String>> createLeague(String name, String mode, int teams, DateTime draftDate) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return left(const AuthFailure('User not logged in'));

      // 1. Create League
      try {
         final leagueResponse = await _supabase.from('leagues').insert({
          'name': name,
          'admin_id': userId,
          'type': mode,
          'total_teams': teams,
          'draft_date': draftDate.toIso8601String(),
          'config_leagues': [], // Defaults
          'config_scoring': [], 
          'config_roster': {},
        }).select().single();
        
        final leagueId = leagueResponse['id'] as String;

        // 2. Add Creator as Admin Member
        await _supabase.from('league_members').insert({
          'league_id': leagueId,
          'user_id': userId,
          'role': 'admin',
          'team_name': 'Team $name', // Default team name
        });

        return right(leagueId);
      } catch (dbError) {
        // More specific error handling could be added here
        return left(NetworkFailure('Database Error: $dbError'));
      }
    } catch (e) {
      return left(NetworkFailure('Failed to create league: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateLeagueConfig({
    required String leagueId,
    required List<String> leagues,
    required List<String> scoring,
    required Map<String, int> roster,
  }) async {
    try {
      await _supabase.from('leagues').update({
        'config_leagues': leagues,
        'config_scoring': scoring,
        'config_roster': roster,
      }).eq('id', leagueId);

      return right(null);
    } catch (e) {
      return left(NetworkFailure('Failed to update config: $e'));
    }
  }
  
  @override
  Future<Either<Failure, League?>> getLeague(String id) async {
    try {
       final response = await _supabase
          .from('leagues')
          .select()
          .eq('id', id)
          .maybeSingle();
       
       if (response == null) return right(null);
       return right(League.fromJson(response));
    } catch (e) {
      return left(NetworkFailure('Failed to get league: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> joinLeague(String code) async {
    try {
      final response = await _supabase.rpc('join_league_by_code', params: {
        'p_code': code,
      });

      if (response['success'] == true) {
        // Invalidate Cache to force refresh
        await _hive.delete(HiveService.boxLeagues, 'my_leagues');
        return right(null);
      } else {
        return left(NetworkFailure(response['error'] ?? 'Erreur inconnue'));
      }
    } catch (e) {
      if (e is PostgrestException) {
          return left(NetworkFailure(e.message));
      }
      return left(NetworkFailure('Failed to join league: $e'));
    }
  }
}


