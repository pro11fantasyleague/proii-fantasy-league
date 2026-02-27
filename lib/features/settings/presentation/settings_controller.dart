import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../../core/providers/repository_providers.dart';
import '../domain/user_stats_data.dart';

part 'settings_controller.g.dart';

@riverpod
class SettingsController extends _$SettingsController {
  @override
  FutureOr<UserStatsData> build() async {
    final user = ref.watch(authControllerProvider).value;
    if (user == null) return const UserStatsData();

    final supabase = ref.watch(supabaseClientProvider);
    
    // Attempt to invoke the RPC if we added it manually to the database
    // Even if it fails, fallback to Dart calculation.
    try {
      final response = await supabase.rpc('get_user_career_stats', params: {'p_user_id': user.id});
      return UserStatsData.fromJson(response);
    } catch (e) {
      // Fallback: Calculate manually via postgrest queries
      try {
         // Count seasons (Leagues where user is member and draft_ended = true)
         final seasonsRes = await supabase.from('league_members')
           .select('league_id, leagues!inner(is_draft_ended)')
           .eq('user_id', user.id)
           .eq('leagues.is_draft_ended', true);
         
         final int seasonsPlayed = (seasonsRes as List).length;

         // Champions (Rank 1)
         final champRes = await supabase.from('league_members')
           .select('id')
           .eq('user_id', user.id)
           .eq('final_rank', 1);
         final champions = (champRes as List).length;

         // Podiums (Rank 1, 2, 3)
         final podiumsRes = await supabase.from('league_members')
           .select('id')
           .eq('user_id', user.id)
           .inFilter('final_rank', [1, 2, 3]);
         final podiums = (podiumsRes as List).length;

         // MVP logic might be highly complex to run entirely client side without RPC.
         // We will default to 0 for MVP if RPC fails.
         
         return UserStatsData(
           seasonsPlayed: seasonsPlayed,
           champions: champions,
           podiums: podiums,
           mvps: 0,
         );

      } catch (fallbackErr) {
        print("Fallback calculation failed: $fallbackErr");
        // Safe default
        return const UserStatsData(seasonsPlayed: 0, champions: 0, podiums: 0, mvps: 0);
      }
    }
  }
}
