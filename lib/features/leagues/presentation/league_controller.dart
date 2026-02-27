import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/providers/repository_providers.dart';

part 'league_controller.g.dart';

@riverpod
class LeagueController extends _$LeagueController {
  @override
  FutureOr<void> build() {
    // Rien à initialiser
  }

  // Méthode appelée par l'écran "Étape 1"
  Future<String?> createLeague(String name, String mode, int teams, DateTime draftDate) async {
    state = const AsyncLoading();
    
    final repository = ref.read(leagueRepositoryProvider);
    final result = await repository.createLeague(name, mode, teams, draftDate);

    return result.fold(
      (failure) {
        state = AsyncError(failure.message, StackTrace.current);
        return null;
      },
      (leagueId) {
        state = const AsyncData(null);
        return leagueId; // On renvoie l'ID pour la navigation
      },
    );
  }

  // Méthode appelée par l'écran "Étape 2" (Config)
  Future<bool> saveConfiguration({
    required String leagueId,
    required List<String> selectedLeagues,
    required List<String> selectedStats,
    required Map<String, int> rosterConfig,
  }) async {
    state = const AsyncLoading();

    final repository = ref.read(leagueRepositoryProvider);
    final result = await repository.updateLeagueConfig(
      leagueId: leagueId,
      leagues: selectedLeagues,
      scoring: selectedStats,
      roster: rosterConfig,
    );

    return result.fold(
      (failure) {
        state = AsyncError(failure.message, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncData(null);
        return true; // Succès
      },
    );
  }

  // Rejoindre une ligue via code
  Future<bool> joinLeague(String code) async {
    state = const AsyncLoading();
    final repository = ref.read(leagueRepositoryProvider);
    final result = await repository.joinLeague(code);

    return result.fold(
      (failure) {
        state = AsyncError(failure.message, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncData(null);
        return true;
      },
    );
  }
}
