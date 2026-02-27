import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_theme.dart';
import 'team_controller.dart';

class ManageTeamScreen extends ConsumerWidget {
  final String leagueId;

  const ManageTeamScreen({super.key, required this.leagueId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Pass leagueId to the controller
    final rosterAsync = ref.watch(teamControllerProvider(leagueId));
    final selectedId = ref.watch(selectedPlayerProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text('MON ÉQUIPE', style: Theme.of(context).textTheme.displaySmall),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.refreshCw, color: AppColors.secondary),
            onPressed: () {
               // Action : Activer les joueurs du jour
               ref.invalidate(teamControllerProvider(leagueId));
            },
          ),
        ],
      ),
      body: rosterAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erreur: $err', style: const TextStyle(color: Colors.red))),
        data: (roster) {
          if (roster.isEmpty) {
             return Center(child: Text('Aucune équipe trouvée.', style: TextStyle(color: Theme.of(context).textTheme.displayLarge?.color)));
          }

          return ListView.builder(
            itemCount: roster.length,
            itemBuilder: (context, index) {
              final player = roster[index];
              final isSelected = selectedId == player.id;
              final isLocked = player.isLocked;

              return InkWell(
                onTap: () {
                  if (isLocked) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Joueur verrouillé !"), backgroundColor: Colors.red),
                    );
                    return;
                  }
                  
                  if (selectedId != null && selectedId != player.id) {
                    // Si un autre joueur est déjà sélectionné -> SWAP
                    ref.read(teamControllerProvider(leagueId).notifier).swapPlayers(selectedId, player.id);
                  } else {
                    // Sinon -> Sélectionner
                    ref.read(selectedPlayerProvider.notifier).select(player.id);
                  }
                },
                child: Container(
                  color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Row(
                      children: [
                        // Position Badge
                        Container(
                          width: 32, height: 32,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isLocked ? Colors.grey : Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: isSelected ? AppColors.primary : Colors.transparent),
                          ),
                          child: Text(player.position, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 12),
                        // Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                player.name,
                                style: TextStyle(
                                  color: isSelected ? AppColors.primary : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    isLocked ? LucideIcons.lock : LucideIcons.unlock,
                                    size: 12,
                                    color: isLocked ? AppColors.error : AppColors.secondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    isLocked ? 'LIVE' : 'SAM 15:00',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isLocked ? AppColors.error : AppColors.muted,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Action Icon (Swap)
                        if (selectedId != null && !isSelected && !isLocked)
                          const Icon(LucideIcons.arrowRightLeft, color: AppColors.primary, size: 20),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
