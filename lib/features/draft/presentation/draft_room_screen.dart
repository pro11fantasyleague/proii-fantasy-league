import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/neon_button.dart';
import 'package:proii_fantasy_league/features/draft/domain/draft_pick.dart';
import 'package:proii_fantasy_league/features/draft/presentation/draft_controller.dart';
import 'package:proii_fantasy_league/features/draft/presentation/widgets/draft_board.dart';

// État local pour la vue (Liste vs Board)
final draftViewModeProvider = StateProvider<String>((ref) => 'list');

class DraftRoomScreen extends ConsumerStatefulWidget {
  final String leagueId;

  const DraftRoomScreen({super.key, required this.leagueId});

  @override
  ConsumerState<DraftRoomScreen> createState() => _DraftRoomScreenState();
}

class _DraftRoomScreenState extends ConsumerState<DraftRoomScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Mock Players List (Ideally should come from a Repository)
  final List<String> _allPlayers = [
    'Lionel Messi', 'Cristiano Ronaldo', 'Kylian Mbappé', 'Erling Haaland', 
    'Kevin De Bruyne', 'Vinicius Jr', 'Jude Bellingham', 'Harry Kane',
    'Mohamed Salah', 'Rodri', 'Lamine Yamal', 'Bukayo Saka',
    'Florian Wirtz', 'Jamal Musiala', 'Phil Foden', 'Cole Palmer'
  ];

  @override
  Widget build(BuildContext context) {
    final draftStateAsync = ref.watch(draftControllerProvider(widget.leagueId));
    final viewMode = ref.watch(draftViewModeProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: draftStateAsync.when(
        data: (state) {
          return Column(
            children: [
              // 1. STICKY HEADER (Timer & Status)
              _buildDraftHeader(context, state),

              // 2. CONTENU PRINCIPAL
              Expanded(
                child: viewMode == 'list'
                    ? _DraftPlayerList(
                        allPlayers: _allPlayers,
                        takenPlayers: state.picks.map((p) => p.playerId).toSet(),
                        query: _searchController.text,
                        isMyTurn: state.isMyTurn,
                        onDraft: (playerId) {
                          ref.read(draftControllerProvider(widget.leagueId).notifier).pickPlayer(playerId);
                        },
                      )
                    : _DraftBoardView(picks: state.picks),
              ),

              // 3. FOOTER (Mon Roster)
              _buildRosterFooter(context),
            ],
          );
        },
        error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildDraftHeader(BuildContext context, dynamic state) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1))),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Current Picker Info
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        '${state.picks.length + 1}',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.displayLarge?.color),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PICK ${state.picks.length + 1} • ROUND 1', // Mock round logic
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.muted,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: "C'est à ", style: TextStyle(color: Theme.of(context).textTheme.displayLarge?.color)),
                            TextSpan(
                              text: state.isMyTurn ? "VOUS" : "L'ADVERSAIRE",
                              style: TextStyle(
                                color: state.isMyTurn ? AppColors.secondary : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Timer
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${state.timeLeft}s',
                    style: GoogleFonts.chakraPetch(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: state.timeLeft < 10 ? AppColors.error : Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Toggle View & Search
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() {}),
                  style: TextStyle(color: Theme.of(context).textTheme.displayLarge?.color),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(LucideIcons.search, color: AppColors.muted),
                    hintText: 'Rechercher...',
                    hintStyle: const TextStyle(color: AppColors.muted),
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Toggle Buttons
              Consumer(builder: (context, ref, _) {
                final mode = ref.watch(draftViewModeProvider);
                return Row(
                  children: [
                    _buildToggleBtn(context, ref, 'list', LucideIcons.list, mode == 'list'),
                    const SizedBox(width: 4),
                    _buildToggleBtn(context, ref, 'board', LucideIcons.layoutGrid, mode == 'board'),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggleBtn(BuildContext context, WidgetRef ref, String mode, IconData icon, bool isActive) {
    return InkWell(
      onTap: () => ref.read(draftViewModeProvider.notifier).state = mode,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive ? Theme.of(context).colorScheme.surface : Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isActive ? AppColors.primary : Colors.transparent),
        ),
        child: Icon(icon, size: 20, color: isActive ? AppColors.primary : AppColors.muted),
      ),
    );
  }
  
  Widget _buildRosterFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 12, 
        left: 16, 
        right: 16, 
        bottom: MediaQuery.of(context).padding.bottom + 12
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: const Border(top: BorderSide(color: AppColors.primary, width: 2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.shield, color: AppColors.secondary, size: 20),
              const SizedBox(width: 8),
              Text("Mon Roster", style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.displayLarge?.color)),
            ],
          ),
          const Icon(LucideIcons.chevronUp, color: AppColors.muted),
        ],
      ),
    );
  }
}

class _DraftPlayerList extends StatelessWidget {
  final List<String> allPlayers;
  final Set<String> takenPlayers;
  final String query;
  final bool isMyTurn;
  final Function(String) onDraft;

  const _DraftPlayerList({
    required this.allPlayers,
    required this.takenPlayers,
    required this.query,
    required this.isMyTurn,
    required this.onDraft,
  });

  @override
  Widget build(BuildContext context) {
    final displayPlayers = allPlayers
        .where((p) => !takenPlayers.contains(p) && p.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: displayPlayers.length,
      separatorBuilder: (_, __) => Divider(color: Colors.white.withOpacity(0.05), height: 1),
      itemBuilder: (context, index) {
        final player = displayPlayers[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          tileColor: index % 2 == 0 ? Theme.of(context).scaffoldBackgroundColor : Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
          leading: Container(
            width: 40,
            alignment: Alignment.center,
            child: Text(
              '${index + 1}', // ADP placeholder
              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontFamily: 'Chakra Petch'),
            ),
          ),
          title: Text(player, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.displayLarge?.color)),
          subtitle: Text('Forward • Manchester City', style: TextStyle(color: AppColors.muted, fontSize: 12)),
          trailing: isMyTurn 
            ? InkWell(
                onTap: () => onDraft(player),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle),
                  child: Icon(LucideIcons.plus, color: Theme.of(context).scaffoldBackgroundColor, size: 20),
                ),
              )
            : const Icon(LucideIcons.lock, color: Colors.white24, size: 20),
        );
      },
    );
  }
}

class _DraftBoardView extends StatelessWidget {
  final List<DraftPick> picks;

  const _DraftBoardView({super.key, required this.picks});

  @override
  Widget build(BuildContext context) {
    return DraftBoardWidget(picks: picks);
  }
}
