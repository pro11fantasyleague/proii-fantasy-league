import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proii_fantasy_league/features/draft/domain/draft_pick.dart';

class DraftBoardWidget extends StatelessWidget {
  final List<DraftPick> picks;
  final int totalTeams;
  final int totalRounds;
  final String? currentPickTeamId;

  const DraftBoardWidget({
    super.key,
    required this.picks,
    this.totalTeams = 8, // Default or passed from parent
    this.totalRounds = 15,
    this.currentPickTeamId,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            // Header Row (Teams)
            Row(
              children: List.generate(totalTeams, (index) {
                return Container(
                  width: 120,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF131B36),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Text(
                    'Team ${index + 1}',
                    style: GoogleFonts.chakraPetch(
                      color: const Color(0xFF00E5FF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }),
            ),
            // Grid
            ...List.generate(totalRounds, (roundIndex) {
              return Row(
                children: List.generate(totalTeams, (teamIndex) {
                  // Calculate overall pick number based on Snake Draft logic if needed
                  // For now, simple grid mapping:
                  // Pick # = (roundIndex * totalTeams) + teamIndex + 1
                  // Snake logic would enable reversing order on even rounds.
                  
                  final isEvenRound = roundIndex % 2 != 0;
                  final actualTeamIndex = isEvenRound ? (totalTeams - 1 - teamIndex) : teamIndex;
                  final pickNumber = (roundIndex * totalTeams) + teamIndex + 1;
                  
                  final pick = picks.firstWhere(
                    (p) => p.pickNumber == pickNumber, 
                    orElse: () => DraftPick(
                      id: '',
                      leagueId: '',
                      playerId: '',
                      managerId: '', // Added dummy managerId
                      teamId: '',
                      pickNumber: -1,
                      timestamp: DateTime.now()
                    )
                  );
                  
                  final isPicked = pick.pickNumber != -1;
                  final isCurrentPick = !isPicked && pickNumber == picks.length + 1;

                  return Container(
                    width: 120,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isCurrentPick 
                          ? const Color(0xFF00FF9A).withOpacity(0.2) 
                          : const Color(0xFF0B1023),
                      border: Border.all(
                        color: isCurrentPick ? const Color(0xFF00FF9A) : Colors.white12,
                        width: isCurrentPick ? 2 : 1,
                      ),
                    ),
                    child: isPicked
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                pick.playerId, // Placeholder for Player Name
                                style: GoogleFonts.inter(
                                  color: Theme.of(context).textTheme.displayLarge?.color,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Pick $pickNumber',
                                style: GoogleFonts.inter(
                                  color: Colors.white54,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          )
                        : Center(
                            child: Text(
                              '$pickNumber',
                              style: GoogleFonts.chakraPetch(
                                color: Colors.white12,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  );
                }),
              );
            }),
          ],
        ),
      ),
    );
  }
}
