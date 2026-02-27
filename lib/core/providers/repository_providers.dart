import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/app_config.dart';
import '../storage/hive_service.dart';

// Repositories
import '../../features/auth/domain/auth_repository.dart';
import '../../features/auth/data/mock_auth_repository.dart';
import '../../features/auth/data/supabase_auth_repository.dart';

import '../../features/leagues/domain/league_repository.dart';
import '../../features/leagues/data/league_repository_impl.dart';

import '../../features/draft/domain/draft_repository.dart';
import '../../features/draft/data/draft_repository_impl.dart';

import '../../features/team/domain/team_repository.dart';
import '../../features/team/data/team_repository_impl.dart';

// --- DATA SOURCES ---

// Client Supabase (Singleton)
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// --- REPOSITORIES ---

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final config = AppConfig.instance;

  if (config.environment == Environment.dev) {
    return MockAuthRepository();
  } else {
    final supabase = ref.watch(supabaseClientProvider);
    return SupabaseAuthRepository(supabase);
  }
});

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

final leagueRepositoryProvider = Provider<LeagueRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  final hive = ref.watch(hiveServiceProvider);
  return LeagueRepositoryImpl(supabase, hive);
});

final draftRepositoryProvider = Provider<DraftRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return DraftRepositoryImpl(supabase);
});

final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  final hive = ref.watch(hiveServiceProvider);
  return TeamRepositoryImpl(supabase, hive);
});
