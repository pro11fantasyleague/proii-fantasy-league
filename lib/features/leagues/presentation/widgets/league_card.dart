import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/league.dart';

class LeagueCard extends StatelessWidget {
  final League league;
  final VoidCallback onTap;

  const LeagueCard({
    super.key,
    required this.league,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Determine status. For UI demonstration, we'll map standard statuses,
    // but you can inject mock points/ranks here as the backend isn't fully wired for them yet.
    switch (league.status) {
      case LeagueStatus.pending:
      case LeagueStatus.drafting:
        return _PendingLeagueCard(league: league, onTap: onTap);
      case LeagueStatus.active:
        return _ActiveLeagueCard(league: league, onTap: onTap);
      case LeagueStatus.finished:
        return _FinishedLeagueCard(league: league, onTap: onTap);
    }
  }
}

// ============================================================================
// 1. CARTE "EN ATTENTE" (Lobby Ouvert / Complet)
// ============================================================================
class _PendingLeagueCard extends StatelessWidget {
  final League league;
  final VoidCallback onTap;

  const _PendingLeagueCard({required this.league, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Mocks for UI testing
    const int currentPlayers = 3; 
    final int maxPlayers = league.totalTeams > 0 ? league.totalTeams : 8;
    final bool isFull = currentPlayers >= maxPlayers;
    
    // Formatting date (ex: 12/04 21:00)
    final d = league.draftDate;
    final dateStr = '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')} à ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

    final bool isDraftReady = DateTime.now().isAfter(d) || DateTime.now().isAtSameMomentAs(d);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
        width: 320,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER: Badge + Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black.withOpacity(0.4) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.cyan.withOpacity(isDark ? 0.3 : 0.6)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8, height: 8,
                          decoration: BoxDecoration(
                            color: isFull ? AppColors.error : Colors.cyan,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isFull ? 'LOBBY COMPLET' : 'LOBBY OUVERT',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isFull ? AppColors.error : Colors.cyan,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(LucideIcons.info, color: Colors.grey, size: 20),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // TITLE
                Text(
                  league.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.chakraPetch(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.displayLarge?.color,
                  ),
                ),
              const SizedBox(height: 8),
              
              // DRAFT DATE
              Row(
                children: [
                  const Icon(LucideIcons.calendarClock, size: 14, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    'Draft : $dateStr',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              
              const Spacer(),
              
              // RECRUITMENT PROGRESS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(LucideIcons.users, size: 14, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        'RECRUTEMENT',
                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.0),
                      ),
                    ],
                  ),
                  Text(
                    '$currentPlayers/$maxPlayers',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // PROGRESS BARS
              Row(
                children: List.generate(maxPlayers, (index) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: EdgeInsets.only(right: index < maxPlayers - 1 ? 4 : 0),
                      decoration: BoxDecoration(
                        color: index < currentPlayers ? Colors.cyan : Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: index < currentPlayers ? [BoxShadow(color: Colors.cyan.withOpacity(0.5), blurRadius: 4)] : [],
                      ),
                    ),
                  );
                }),
              ),
              
              const SizedBox(height: 20),
              
              // INVITE BUTTON OR ENTER BUTTON
              if (isDraftReady)
                InkWell(
                  onTap: onTap,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.secondary),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(LucideIcons.logIn, size: 16, color: AppColors.secondary),
                        const SizedBox(width: 8),
                        Text(
                          'ENTRER',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                InkWell(
                  onTap: () => _showInviteModal(context, league.inviteCode ?? 'HORS-LIGNE', league.name),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isFull ? Colors.white.withOpacity(0.05) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isFull ? Colors.transparent : Colors.cyan.withOpacity(0.5)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.share2, size: 16, color: isFull ? Colors.grey : Colors.cyan),
                        const SizedBox(width: 8),
                        Text(
                          'INVITER DES AMIS',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isFull ? Colors.grey : Colors.cyan,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
  }
}

// ============================================================================
// 2. CARTE "LIGUE ACTIVE" (En cours)
// ============================================================================
class _ActiveLeagueCard extends StatelessWidget {
  final League league;
  final VoidCallback onTap;

  const _ActiveLeagueCard({required this.league, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Mocks for UI testing
    const int rank = 2;
    final int maxPlayers = league.totalTeams > 0 ? league.totalTeams : 10;
    const int points = 1450;
    const String rivalName = 'FC Rival';

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 320,
      margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondary.withOpacity(isDark ? 0.1 : 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Top Right Glow
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 120, height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondary.withOpacity(0.15),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.black.withOpacity(0.4) : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.secondary.withOpacity(isDark ? 0.3 : 0.6)),
                        ),
                        child: Row(
                          children: [
                            const Icon(LucideIcons.activity, size: 12, color: AppColors.secondary),
                            const SizedBox(width: 8),
                            Text(
                              'EN COURS',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[300],
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(LucideIcons.chevronRight, color: Colors.grey, size: 20),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // TITLE
                  Text(
                    league.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.chakraPetch(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.displayLarge?.color,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // MATCHUP STATUS (Live)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.secondary.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6, height: 6,
                          decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'vs $rivalName (Live)',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // FOOTER (Stats)
                  Container(
                    padding: const EdgeInsets.only(top: 16),
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // RANG
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'MON RANG',
                              style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey[500], letterSpacing: 1.5),
                            ),
                            const SizedBox(height: 4),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '$rank',
                                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, color: Colors.white),
                                  ),
                                  TextSpan(
                                    text: '/$maxPlayers',
                                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        // POINTS
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'POINTS',
                              style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey[500], letterSpacing: 1.5),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$points',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'monospace',
                                color: AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }
}

// ============================================================================
// 3. CARTE "LIGUE TERMINÉE" (Archivée)
// ============================================================================
class _FinishedLeagueCard extends StatelessWidget {
  final League league;
  final VoidCallback onTap;

  const _FinishedLeagueCard({required this.league, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Mocks for UI testing
    const int rank = 1;
    final int maxPlayers = league.totalTeams > 0 ? league.totalTeams : 10;
    const int points = 2150;
    final isChampion = rank == 1;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
        width: 320,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withOpacity(0.4) : Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Top Right Glow (Gold if champion)
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 120, height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isChampion ? AppColors.gold.withOpacity(0.1) : Colors.white.withOpacity(0.02),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDark ? (Colors.grey[800]?.withOpacity(0.8)) : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(LucideIcons.trophy, size: 12, color: isChampion ? AppColors.gold : (isDark ? Colors.grey[400] : Colors.grey[600])),
                            const SizedBox(width: 8),
                            Text(
                              'TERMINÉE',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.grey[300] : Colors.grey[700],
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(LucideIcons.chevronRight, color: Colors.grey, size: 20),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // TITLE
                  Text(
                    league.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.chakraPetch(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.displayLarge?.color,
                    ),
                  ),
                  
                  const SizedBox(height: 6),
                  
                  const Text(
                    'Saison archivée',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // FOOTER (Stats)
                  Container(
                    padding: const EdgeInsets.only(top: 16),
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // RANG
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CLASSEMENT FINAL',
                              style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey[500], letterSpacing: 1.5),
                            ),
                            const SizedBox(height: 4),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '$rank',
                                    style: TextStyle(
                                      fontSize: 24, 
                                      fontWeight: FontWeight.w900, 
                                      fontStyle: FontStyle.italic, 
                                      color: isChampion ? AppColors.gold : Colors.white,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '/$maxPlayers',
                                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        // POINTS
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'POINTS',
                              style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey[500], letterSpacing: 1.5),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$points',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'monospace',
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }
}

// ============================================================================
// MODALE D'INVITATION
// ============================================================================
void _showInviteModal(BuildContext context, String inviteCode, String leagueName) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        title: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.share2, color: AppColors.primary, size: 32),
              ),
              const SizedBox(height: 16),
              Text(
                'INVITER DES MANAGERS',
                style: GoogleFonts.chakraPetch(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Partagez ce code pour recruter des joueurs dans "$leagueName".',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 12, color: AppColors.muted),
              ),
            ],
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    inviteCode,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      letterSpacing: 2.0,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.copy, color: AppColors.muted),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: inviteCode));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Code copié !', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(LucideIcons.share, size: 16, color: Colors.black),
              label: const Text('PARTAGER LE LIEN', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                // Feature Share bonus - fallback au copy
                Clipboard.setData(ClipboardData(text: 'Rejoins ma ligue PRO11 Fantasy avec le code : $inviteCode !'));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Texte de l\'invitation copié !', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
                );
              },
            ),
          ],
        ),
      );
    },
  );
}
