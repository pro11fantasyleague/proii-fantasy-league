import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/presentation/login_screen.dart'; // GridPainter

class ScoresScreen extends ConsumerWidget {
  const ScoresScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Placeholder data for UI demonstration
    final liveMatches = [
      {'home': 'Paris SG', 'away': 'Marseille', 'score_home': 2, 'score_away': 1, 'time': '72\''},
      {'home': 'Lyon', 'away': 'Monaco', 'score_home': 0, 'score_away': 0, 'time': 'MT'},
    ];

    final upcomingMatches = [
      {'home': 'Lille', 'away': 'Lens', 'date': 'Demain, 21:00'},
      {'home': 'Rennes', 'away': 'Nantes', 'date': 'Dimanche, 15:00'},
      {'home': 'Nice', 'away': 'Reims', 'date': 'Dimanche, 17:00'},
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: GridPainter()),
          ),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                _buildHeader(theme),
                _buildSectionTitle(theme, 'EN DIRECT', isLive: true),
                _buildLiveGames(liveMatches, theme),
                
                _buildSectionTitle(theme, 'À VENIR'),
                _buildUpcomingGames(upcomingMatches, theme),
                
                const SliverToBoxAdapter(child: SizedBox(height: 100)), // Bottom nav padding
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'MATCH CENTER',
              style: theme.textTheme.labelMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            RichText(
              text: TextSpan(
                style: theme.textTheme.displayLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                  height: 1.0,
                  fontSize: 36,
                ),
                children: const [
                  TextSpan(text: 'LIVE '),
                  TextSpan(
                    text: 'SCORES',
                    style: TextStyle(color: AppColors.secondary), 
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title, {bool isLive = false}) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        child: Row(
          children: [
            if (isLive) ...[
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              title,
              style: theme.textTheme.labelLarge?.copyWith(
                color: isLive ? theme.textTheme.displayLarge?.color : AppColors.muted,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveGames(List<Map<String, dynamic>> matches, ThemeData theme) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final match = matches[index];
          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.error.withValues(alpha: 0.1),
                    blurRadius: 10,
                    spreadRadius: -2,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Text('LIGUE 1', style: theme.textTheme.labelSmall?.copyWith(color: AppColors.muted)),
                       Container(
                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                         decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                         child: Text(match['time'], style: theme.textTheme.labelSmall?.copyWith(color: AppColors.error, fontWeight: FontWeight.bold)),
                       ),
                    ],
                   ),
                   const SizedBox(height: 16),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Home
                      Expanded(
                        child: Column(
                          children: [
                            CircleAvatar(backgroundColor: AppColors.muted.withValues(alpha: 0.1), radius: 24, child: Icon(Icons.shield, color: AppColors.muted.withValues(alpha: 0.3))),
                            const SizedBox(height: 8),
                            Text(match['home'], style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
                          ]
                        ),
                      ),
                      
                      // Score
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.muted.withValues(alpha: 0.1)),
                        ),
                        child: Text(
                          '${match['score_home']} - ${match['score_away']}',
                          style: theme.textTheme.displayMedium?.copyWith(fontSize: 24, color: AppColors.secondary),
                        ),
                      ),

                      // Away
                      Expanded(
                        child: Column(
                          children: [
                            CircleAvatar(backgroundColor: AppColors.muted.withValues(alpha: 0.1), radius: 24, child: Icon(Icons.shield, color: AppColors.muted.withValues(alpha: 0.3))),
                            const SizedBox(height: 8),
                            Text(match['away'], style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
                          ]
                        ),
                      ),
                    ],
                   ),
                ],
              ),
            ),
          );
        },
        childCount: matches.length,
      ),
    );
  }

  Widget _buildUpcomingGames(List<Map<String, dynamic>> matches, ThemeData theme) {
     return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final match = matches[index];
          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.muted.withValues(alpha: 0.1)),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(match['home'], style: theme.textTheme.bodyMedium, textAlign: TextAlign.right),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 70,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('VS', style: theme.textTheme.labelMedium?.copyWith(color: AppColors.muted), textAlign: TextAlign.center),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: Text(match['away'], style: theme.textTheme.bodyMedium, textAlign: TextAlign.left),
                  ),
                ],
              ),
            ),
          );
        },
        childCount: matches.length,
      ),
    );
  }
}
