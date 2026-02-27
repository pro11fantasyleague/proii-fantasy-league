import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'draft_controller.dart'; 
// Assuming draft_pick model moved or we use dynamic for now to bypass
// import '../../domain/draft_pick.dart';

class DraftScreen extends ConsumerWidget {
  final String leagueId;

  const DraftScreen({super.key, required this.leagueId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftStateAsync = ref.watch(draftControllerProvider(leagueId));

    return Scaffold(
      backgroundColor: const Color(0xFF0B1023),
      appBar: AppBar(
        title: Text('DRAFT ROOM', style: GoogleFonts.chakraPetch(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      body: draftStateAsync.when(
        data: (state) {
          return Column(
            children: [
              // Timer and Status
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.black26,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      state.isMyTurn ? "C'EST À VOUS !" : "EN ATTENTE...",
                      style: GoogleFonts.chakraPetch(
                        color: state.isMyTurn ? const Color(0xFF00FF9A) : Colors.white54,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: state.timeLeft < 10 ? Colors.red : const Color(0xFF00E5FF),
                          width: 2
                        ),
                      ),
                      child: Text(
                        '${state.timeLeft}',
                        style: GoogleFonts.chakraPetch(
                          color: Theme.of(context).textTheme.displayLarge?.color,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Picks List
              Expanded(
                child: ListView.builder(
                  itemCount: state.picks.length,
                  itemBuilder: (context, index) {
                    final pick = state.picks[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFF131B36),
                        child: Text('${pick.pickNumber}', style: const TextStyle(color: Color(0xFF00E5FF))),
                      ),
                      title: Text('Player ID: ${pick.playerId}', style: TextStyle(color: Theme.of(context).textTheme.displayLarge?.color)),
                      subtitle: Text('Team: ${pick.teamId}', style: const TextStyle(color: Colors.white54)),
                    );
                  },
                ),
              ),
              
              // Action Area
              if (state.isMyTurn)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00FF9A),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                         // Removed makePick until domain is properly formed
                      },
                      child: Text(
                        'DRAFTER LIONEL MESSI (MOCK)',
                        style: GoogleFonts.chakraPetch(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
        error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
