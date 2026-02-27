import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui' as ui;

import '../../../core/theme/app_theme.dart';
import 'hub_controller.dart'; 
import 'league_controller.dart';
import 'widgets/league_card.dart'; 
import 'news_screen.dart';
import 'scores_screen.dart';

class HubScreen extends ConsumerStatefulWidget {
  const HubScreen({super.key});

  @override
  ConsumerState<HubScreen> createState() => _HubScreenState();
}

class _HubScreenState extends ConsumerState<HubScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // 1. FOND : Grille Cyberpunk dessinée au trait
          Positioned.fill(
            child: CustomPaint(
              painter: HubGridPainter(
                color: AppColors.primary.withValues(alpha: 0.03),
                spacing: 30.0,
              ),
            ),
          ),
          SafeArea(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                _buildHubContent(ref),
                const ScoresScreen(),
                const NewsScreen(),
                Center(child: Text('Social (En construction)', style: TextStyle(color: Theme.of(context).textTheme.displayLarge?.color))),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 1)),
          color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.95),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.muted,
          currentIndex: _currentIndex,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(LucideIcons.trophy), label: 'Hub'),
            BottomNavigationBarItem(icon: Icon(LucideIcons.activity), label: 'Live'),
            BottomNavigationBarItem(icon: Icon(LucideIcons.newspaper), label: 'News'),
            BottomNavigationBarItem(icon: Icon(LucideIcons.messageSquare), label: 'Social'),
          ],
        ),
      ),
    );
  }

  Widget _buildHubContent(WidgetRef ref) {
    // Écoute de l'état des ligues depuis le contrôleur
    final leaguesAsync = ref.watch(hubControllerProvider);

    return Column(
      children: [
        // --- HEADER ---
        _buildHeader(context),
        const SizedBox(height: 24),

        // --- CONTENU (Vide ou Liste) ---
        Expanded(
          child: leaguesAsync.when(
            data: (leagues) {
              if (leagues.isEmpty) {
                return const _HubEmptyState(); // Affichage de notre nouveau composant !
              }
              
              // Affichage normal si des ligues existent (Carousel)
              return _buildLeaguesList(context, leagues); 
            },
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
            error: (err, stack) => Center(
              child: Text('Erreur: $err', style: const TextStyle(color: AppColors.error)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ESPACE MANAGER',
                style: GoogleFonts.inter(
                  color: AppColors.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.chakraPetch(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    height: 1.1,
                    color: Theme.of(context).textTheme.displayLarge?.color,
                  ),
                  children: [
                    TextSpan(text: 'MES ', style: TextStyle(color: Theme.of(context).textTheme.displayLarge?.color)),
                    TextSpan(
                      text: 'LIGUES',
                      style: TextStyle(color: AppColors.secondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // Avatar Bouton
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: 15,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: () => context.push('/settings'),
                child: const Icon(LucideIcons.user, color: AppColors.primary, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // L'affichage classique du carousel si l'utilisateur a des ligues
  Widget _buildLeaguesList(BuildContext context, List leagues) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 280,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              scrollDirection: Axis.horizontal,
              itemCount: leagues.length,
              itemBuilder: (context, index) {
                return LeagueCard(
                  league: leagues[index],
                  onTap: () => context.push('/draft/${leagues[index].id}'),
                );
              },
            ),
          ),
          // Expanded Spacing for Hub Layout readability
          const SizedBox(height: 32),
          const ActionFooter(),
        ],
      ),
    );
  }
}

// ============================================================================
// NOUVEAU COMPOSANT : LE "EMPTY STATE" IMMERSIF
// ============================================================================

class _HubEmptyState extends StatelessWidget {
  const _HubEmptyState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              // 1. RADAR HOLOGRAPHIQUE (Icône animée)
              _buildHoloRadar(context),
              
              const SizedBox(height: 32),

              // 2. TEXTES ET BADGES
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Petit point clignotant
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ).animate(onPlay: (controller) => controller.repeat())
                     .fade(duration: const Duration(seconds: 1), curve: Curves.easeInOut),
                    const SizedBox(width: 8),
                    Text(
                      'SYSTÈME EN ATTENTE',
                      style: GoogleFonts.chakraPetch(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              Text(
                'LE TERRAIN EST VIDE',
                style: GoogleFonts.chakraPetch(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.displayLarge?.color ?? Colors.white,
                ),
              ),
              
              const SizedBox(height: 8),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "Il est temps d'entrer sur le terrain et de bâtir votre légende, Coach.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.muted,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // 3. INDICATEUR REBONDISSANT
              Column(
                children: [
                  Text(
                    'INITIALISER',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary.withValues(alpha: 0.6),
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Icon(
                    LucideIcons.chevronsDown,
                    color: AppColors.primary.withValues(alpha: 0.6),
                    size: 20,
                  ),
                ],
              ).animate(onPlay: (controller) => controller.repeat(reverse: true))
               .moveY(begin: -5, end: 5, duration: const Duration(seconds: 1), curve: Curves.easeInOut),
            ],
          ),
        ),
      ),
    ),

    // 4. FOOTER ACTIONS
    const ActionFooter(),
      ],
    );
  }

  Widget _buildHoloRadar(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Effet "Radar Ping" (Onde qui s'étend)
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
          ).animate(onPlay: (c) => c.repeat())
           .scaleXY(begin: 1.0, end: 1.6, duration: const Duration(seconds: 2), curve: Curves.easeOutCubic)
           .fade(begin: 0.8, end: 0.0, duration: const Duration(seconds: 2)),

          // Anneau extérieur pointillé (Rotation lente)
          CustomPaint(
            size: const Size(160, 160),
            painter: DashedCirclePainter(color: AppColors.primary.withValues(alpha: 0.3)),
          ).animate(onPlay: (c) => c.repeat())
           .rotate(duration: const Duration(seconds: 10), curve: Curves.linear),

          // Anneau intérieur continu (Rotation inverse)
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 1.5),
            ),
          ).animate(onPlay: (c) => c.repeat())
           .rotate(begin: 1.0, end: 0.0, duration: const Duration(seconds: 15), curve: Curves.linear),

          // Centre Glassmorphism + BALLON WIREFRAME
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                  boxShadow: [
                    BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 30)
                  ]
                ),
                child: Center(
                  // Le nouveau ballon dessiné sur mesure
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: CustomPaint(
                      painter: WireframeBallPainter(color: AppColors.primary),
                    ),
                  ).animate(onPlay: (c) => c.repeat(reverse: true))
                   .fade(begin: 0.7, end: 1.0, duration: const Duration(milliseconds: 1500))
                   // Léger effet de lueur pulsante
                   .custom(
                     duration: const Duration(milliseconds: 1500),
                     builder: (context, value, child) {
                       return Container(
                         decoration: BoxDecoration(
                           shape: BoxShape.circle,
                           boxShadow: [
                             BoxShadow(
                               color: AppColors.primary.withValues(alpha: 0.4 * value),
                               blurRadius: 15 * value,
                               spreadRadius: 2 * value,
                             )
                           ]
                         ),
                         child: child,
                       );
                     },
                   ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// WIDGET D'ACTIONS RÉUTILISABLE
// ============================================================================

class ActionFooter extends ConsumerWidget {
  const ActionFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.zap, size: 16, color: AppColors.secondary),
              const SizedBox(width: 8),
              Text(
                'NOUVELLE SAISON',
                style: GoogleFonts.inter(
                  color: Theme.of(context).textTheme.displayLarge?.color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),

          // Bouton "Créer une Ligue"
          AnimatedActionCard(
            onTap: () => context.push('/create-league'),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF008F58), Color(0xFF004D2F)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(color: AppColors.secondary.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 4)),
                ],
              ),
              child: Stack(
                children: [
                  // Watermark (Filigrane)
                  Positioned(
                    right: -20,
                    bottom: -30,
                    child: Opacity(
                      opacity: 0.1,
                      child: Icon(LucideIcons.dribbble, size: 140, color: Colors.black),
                    ),
                  ),
                  
                  // Contenu du bouton
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(color: AppColors.secondary.withValues(alpha: 0.4), blurRadius: 15),
                            ],
                          ),
                          child: const Icon(LucideIcons.plus, color: Color(0xFF080C17), size: 28),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CRÉER UNE LIGUE',
                              style: GoogleFonts.chakraPetch(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: Theme.of(context).textTheme.displayLarge?.color,
                                letterSpacing: 1.0,
                              ),
                            ),
                            Text(
                              'Devenez Commissaire & Invitez vos amis',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: Colors.green[100]?.withValues(alpha: 0.8),
                                fontWeight: FontWeight.w500,
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
          ),
          
          const SizedBox(height: 16),

          // Bouton "Rejoindre une Ligue"
          AnimatedActionCard(
            onTap: () {
              _showJoinLeagueDialog(context, ref);
            },
            child: Container(
              height: 72,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: const Icon(LucideIcons.arrowRightToLine, color: AppColors.primary, size: 16),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'REJOINDRE UNE LIGUE',
                          style: GoogleFonts.chakraPetch(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Theme.of(context).textTheme.displayLarge?.color,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          "Via code d'invitation",
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(LucideIcons.chevronRight, color: AppColors.muted, size: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _showJoinLeagueDialog(BuildContext context, WidgetRef ref) async {
  final TextEditingController codeController = TextEditingController();
  bool isLoading = false;

  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
            ),
            title: Text(
              'REJOINDRE UNE LIGUE',
              style: GoogleFonts.chakraPetch(
                color: Theme.of(context).textTheme.displayLarge?.color,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Saisissez le code d\'invitation (ex: PROII-XXXXXX)',
                  style: GoogleFonts.inter(color: AppColors.muted, fontSize: 13),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: codeController,
                  textCapitalization: TextCapitalization.characters,
                  style: TextStyle(color: Theme.of(context).textTheme.displayLarge?.color),
                  decoration: InputDecoration(
                    hintText: 'PROII-',
                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
                    filled: true,
                    fillColor: Colors.black.withValues(alpha: 0.2),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () => Navigator.pop(context),
                child: const Text('Annuler', style: TextStyle(color: AppColors.muted)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: isLoading
                    ? null
                    : () async {
                        final code = codeController.text.trim().toUpperCase();
                        if (code.isEmpty) return;

                        setState(() => isLoading = true);

                        final success = await ref.read(leagueControllerProvider.notifier).joinLeague(code);
                        if (!context.mounted) return;
                        
                        setState(() => isLoading = false);

                        if (success) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Succès ! Vous avez rejoint la ligue.', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
                          );
                          ref.invalidate(hubControllerProvider);
                        } else {
                          final errorMessage = ref.read(leagueControllerProvider).error?.toString() ?? 'Code invalide ou ligue complète.';
                          // Strip string 'Exception: ' if present
                          final msg = errorMessage.replaceAll('Exception: ', '');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(msg, style: const TextStyle(color: Colors.white)), backgroundColor: AppColors.error),
                          );
                        }
                      },
                child: isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                    : const Text('REJOINDRE', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      );
    },
  );
}

// ============================================================================
// UTILITAIRES DE DESSIN (Custom Painters)
// ============================================================================

// Peintre pour le Ballon Wireframe (NOUVEAU)
class WireframeBallPainter extends CustomPainter {
  final Color color;

  WireframeBallPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Calcul de l'échelle par rapport à la viewBox SVG originale (0 0 24 24)
    final double scaleX = size.width / 24.0;
    final double scaleY = size.height / 24.0;

    final strokePaint = Paint()
      ..color = color
      ..strokeWidth = 1.5 * scaleX
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.25)
      ..style = PaintingStyle.fill;

    // 1. Cercle principal (cx="12" cy="12" r="10")
    canvas.drawCircle(Offset(12 * scaleX, 12 * scaleY), 10 * scaleX, strokePaint);

    // 2. Pentagone central transparent
    final Path pentagon = Path()
      ..moveTo(12 * scaleX, 8 * scaleY)
      ..lineTo(15.8 * scaleX, 10.8 * scaleY)
      ..lineTo(14.4 * scaleX, 15.2 * scaleY)
      ..lineTo(9.6 * scaleX, 15.2 * scaleY)
      ..lineTo(8.2 * scaleX, 10.8 * scaleY)
      ..close();
    
    canvas.drawPath(pentagon, fillPaint);
    canvas.drawPath(pentagon, strokePaint);

    // 3. Lignes de structure
    canvas.drawLine(Offset(12 * scaleX, 8 * scaleY), Offset(12 * scaleX, 2 * scaleY), strokePaint);
    canvas.drawLine(Offset(15.8 * scaleX, 10.8 * scaleY), Offset(21.5 * scaleX, 8.9 * scaleY), strokePaint);
    canvas.drawLine(Offset(14.4 * scaleX, 15.2 * scaleY), Offset(17.9 * scaleX, 20.1 * scaleY), strokePaint);
    canvas.drawLine(Offset(9.6 * scaleX, 15.2 * scaleY), Offset(6.1 * scaleX, 20.1 * scaleY), strokePaint);
    canvas.drawLine(Offset(8.2 * scaleX, 10.8 * scaleY), Offset(2.5 * scaleX, 8.9 * scaleY), strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Peintre pour dessiner la grille d'arrière-plan proprement
class HubGridPainter extends CustomPainter {
  final Color color;
  final double spacing;

  HubGridPainter({required this.color, required this.spacing});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Peintre pour l'anneau pointillé du radar
class DashedCirclePainter extends CustomPainter {
  final Color color;

  DashedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.0 // Plus épais selon la nouvelle maquette
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const dashWidth = 8.0;
    const dashSpace = 8.0;
    double circumference = 2 * 3.14159 * radius;
    int dashCount = (circumference / (dashWidth + dashSpace)).floor();

    for (int i = 0; i < dashCount; i++) {
      double startAngle = (i * (dashWidth + dashSpace)) / radius;
      double sweepAngle = dashWidth / radius;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Wrapper Interactif pour ajouter un retour haptique visuel (Scale down on tap)
class AnimatedActionCard extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;

  const AnimatedActionCard({super.key, required this.onTap, required this.child});

  @override
  State<AnimatedActionCard> createState() => _AnimatedActionCardState();
}

class _AnimatedActionCardState extends State<AnimatedActionCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: AnimatedOpacity(
          opacity: _isPressed ? 0.8 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: widget.child,
        ),
      ),
    );
  }
}
