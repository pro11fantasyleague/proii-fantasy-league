import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/presentation/login_screen.dart'; // GridPainter

class NewsScreen extends ConsumerWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Placeholder data
    final newsArticles = [
      {
        'title': 'Analyse: Les meilleurs milieux de terrain pour la Journée 12',
        'category': 'FANTASY',
        'time': 'Il y a 2h',
        'image': 'https://placehold.co/400x200/00E5FF/0B1023?text=FANTASY+TIPS',
      },
      {
        'title': 'Blessure de Mbappé: Quel impact sur votre équipe ?',
        'category': 'BREAKING',
        'time': 'Il y a 5h',
        'image': 'https://placehold.co/400x200/FF2A2A/0B1023?text=INJURY+UPDATE',
      },
      {
        'title': 'Les pépites cachées à moins de 5M€',
        'category': 'SCOUTING',
        'time': 'Il y a 1j',
        'image': 'https://placehold.co/400x200/003320/00E5FF?text=SCOUTING',
      }
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
                _buildNewsList(newsArticles, theme),
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
              'ACTUALITÉS',
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
                  TextSpan(text: 'PROII '),
                  TextSpan(
                    text: 'NEWS',
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

  Widget _buildNewsList(List<Map<String, String>> articles, ThemeData theme) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final article = articles[index];
          final isBreaking = article['category'] == 'BREAKING';
          
          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isBreaking ? AppColors.error.withValues(alpha: 0.5) : AppColors.muted.withValues(alpha: 0.1)),
                boxShadow: isBreaking ? [
                  BoxShadow(
                    color: AppColors.error.withValues(alpha: 0.1),
                    blurRadius: 10,
                    spreadRadius: -2,
                  ),
                ] : [],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   // Image Box (Fallback for Web)
                   Container(
                     height: 140,
                     width: double.infinity,
                     color: isBreaking ? AppColors.error.withValues(alpha: 0.1) : AppColors.primary.withValues(alpha: 0.1),
                     child: Center(
                        child: Icon(
                          isBreaking ? LucideIcons.alertTriangle : LucideIcons.newspaper, 
                          size: 40, 
                          color: isBreaking ? AppColors.error : AppColors.primary
                        )
                     ),
                   ),
                   
                   // Content
                   Padding(
                     padding: const EdgeInsets.all(16),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Container(
                               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                               decoration: BoxDecoration(
                                 color: isBreaking ? AppColors.error : AppColors.primary.withValues(alpha: 0.2),
                                 borderRadius: BorderRadius.circular(4),
                               ),
                               child: Text(
                                 article['category']!,
                                 style: theme.textTheme.labelSmall?.copyWith(
                                   color: isBreaking ? Colors.white : AppColors.primary,
                                   fontWeight: FontWeight.bold,
                                 ),
                               ),
                             ),
                             Text(
                               article['time']!,
                               style: theme.textTheme.bodyMedium?.copyWith(fontSize: 10, color: AppColors.muted),
                             ),
                           ],
                         ),
                         const SizedBox(height: 12),
                         Text(
                           article['title']!,
                           style: theme.textTheme.titleMedium?.copyWith(
                             fontWeight: FontWeight.bold,
                             height: 1.2,
                           ),
                         ),
                         const SizedBox(height: 16),
                         Row(
                           children: [
                             Text(
                               'LIRE L\'ARTICLE',
                               style: theme.textTheme.labelMedium?.copyWith(
                                 color: AppColors.muted,
                                 fontWeight: FontWeight.bold,
                               ),
                             ),
                             const SizedBox(width: 4),
                             const Icon(LucideIcons.arrowRight, size: 14, color: AppColors.muted),
                           ],
                         ),
                       ],
                     ),
                   ),
                ],
              ),
            ),
          );
        },
        childCount: articles.length,
      ),
    );
  }
}
