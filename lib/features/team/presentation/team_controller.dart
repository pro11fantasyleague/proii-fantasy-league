import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/player.dart';
import '../../../../core/providers/repository_providers.dart'; // Import Provider
import '../domain/team_repository.dart'; // Import Interface

part 'team_controller.g.dart';

// État de la sélection pour le swap
@riverpod
class SelectedPlayer extends _$SelectedPlayer {
  @override
  String? build() => null; // ID du joueur sélectionné (null = aucun)

  void select(String playerId) {
    if (state == playerId) {
      state = null; // Désélectionner si on reclique
    } else {
      state = playerId;
    }
  }

  void clear() => state = null;
}

// Controller principal qui gère l'équipe
@riverpod
class TeamController extends _$TeamController {
  @override
  Future<List<Player>> build(String leagueId) async {
    final repository = ref.watch(teamRepositoryProvider);
    
    // 1. Get My Team ID
    final teamResult = await repository.getMyTeam(leagueId);
    final team = teamResult.fold((l) => null, (r) => r);
    
    if (team == null) return []; // Or throw error / empty state

    // 2. Get Roster
    final result = await repository.getTeamRoster(team.id);
    return result.fold(
      (failure) => [], 
      (players) => players
    );
  }

  // Action : Intervertir deux joueurs
  Future<void> swapPlayers(String player1Id, String player2Id) async {
    final currentRoster = state.value ?? [];
    
    // 1. Vérifications (Lock)
    final p1 = currentRoster.firstWhere((p) => p.id == player1Id);
    final p2 = currentRoster.firstWhere((p) => p.id == player2Id);
    
    // Lock check
    if (p1.isLocked || p2.isLocked) {
      // In a real app we might show a toast, here we just return or throw
      // throw Exception("Joueur verrouillé");
      return; 
    }

    // Positions validation check (Simplified for now - assumes UI prevents invalid swaps or backend rejects)
    // E.g. Can't put a DEF in a ATT slot.
    // For now, we assume the UI (ManageTeamScreen) only allows valid drops or we just swap slots.
    
    // 2. Optimistic Update (Swap Slots & Starter Status)
    final p1Slot = p1.rosterSlot;
    final p1Starter = p1.isStarter;
    
    final p2Slot = p2.rosterSlot;
    final p2Starter = p2.isStarter;
    
    final updatedP1 = p1.copyWith(rosterSlot: p2Slot, isStarter: p2Starter);
    final updatedP2 = p2.copyWith(rosterSlot: p1Slot, isStarter: p1Starter);
    
    final newRoster = currentRoster.map((p) {
      if (p.id == player1Id) return updatedP1;
      if (p.id == player2Id) return updatedP2;
      return p;
    }).toList();
    
    state = AsyncData(newRoster);
    
    // 3. Appel API (Repository)
    try {
      final updates = [
        {
          'player_id': player1Id,
          'position_slot': p2Slot,
          'is_starter': p2Starter,
        },
        {
          'player_id': player2Id,
          'position_slot': p1Slot,
          'is_starter': p1Starter,
        }
      ];
      
      await ref.read(teamRepositoryProvider).updateRosterPositions(updates);
    } catch (e) {
      // Rollback on error
      state = AsyncData(currentRoster);
      rethrow;
    }
    
    // 4. Reset sélection
    ref.read(selectedPlayerProvider.notifier).clear();
  }
}
