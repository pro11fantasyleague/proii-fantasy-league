import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/providers/repository_providers.dart';
import '../domain/league.dart';

part 'hub_controller.g.dart';

@riverpod
class HubController extends _$HubController {
  @override
  Future<List<League>> build() async {
    // Récupération des ligues via le repository (qui gère Supabase/Mock/Cache)
    final repository = ref.read(leagueRepositoryProvider);
    final result = await repository.getMyLeagues();
    
    // Gestion fonctionnelle de l'erreur (fpdart)
    return result.fold(
      (failure) => throw Exception(failure.message),
      (leagues) => leagues,
    );
  }
  
  // Méthode pour rafraîchir manuellement (Pull-to-refresh)
  Future<void> refresh() async {
    state = const AsyncLoading();
    ref.invalidateSelf(); // Relance le build()
  }
  // Méthode pour rejoindre une ligue via code
  Future<void> joinLeague(String code) async {
    final repository = ref.read(leagueRepositoryProvider);
    final result = await repository.joinLeague(code);
    
    result.fold(
      (failure) => throw Exception(failure.message),
      (_) => ref.invalidateSelf(), // Rafraîchir la liste
    );
  }
}
