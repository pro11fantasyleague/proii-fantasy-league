import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:proii_fantasy_league/features/draft/domain/draft_pick.dart';
import 'package:proii_fantasy_league/core/providers/repository_providers.dart';
import 'draft_state.dart';

part 'draft_controller.g.dart';

@riverpod
class DraftController extends _$DraftController {
  
  Timer? _timer;

  @override
  Stream<DraftState> build(String leagueId) async* {
    final repository = ref.watch(draftRepositoryProvider);
    
    // Initial state
    yield const DraftState(status: DraftStatus.scheduled);

    await for (final picks in repository.watchDraftPicks(leagueId)) {
      _timer?.cancel();
      // For a real app, calculate remaining time based on server timestamp
      // remaining = deadline - now
      // For now, we reset to 30s for demo
      int remaining = 30; 
      
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        remaining--;
        if (remaining <= 0) {
          timer.cancel();
          // Trigger Auto-Pick via Edge Function
           ref.read(supabaseClientProvider).functions.invoke('process-draft', body: {'league_id': leagueId});
        }
        // Emitting state from a timer inside a Stream generator is tricky
        // This is a simplified approach; usually we'd use a StateNotifier or StreamController
      });

      yield DraftState(
        picks: picks,
        currentPickNumber: picks.length + 1,
        timeLeft: remaining, 
        status: DraftStatus.live,
        isMyTurn: true, // Logic to determine turn
      );
    }
  }

  Future<void> pickPlayer(String playerId) async {
    final currentState = state.value;
    if (currentState == null) return;

    // Use leagueId from the provider family argument
    await ref.read(draftRepositoryProvider).makePick(
      leagueId: leagueId,
      playerId: playerId,
      pickNumber: currentState.currentPickNumber,
    );
  }
}
