import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_theme.dart';

// ============================================================================
// MODALE : PASS LIGUE
// ============================================================================
class PassLigueModal extends StatelessWidget {
  const PassLigueModal({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Détails du Pass Ligue', style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.0)),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(LucideIcons.x, color: theme.textTheme.bodyMedium?.color, size: 20),
              )
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
              boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 20)],
            ),
            child: const Icon(LucideIcons.ticket, color: AppColors.primary, size: 40),
          ),
          const SizedBox(height: 16),
          Text('PASS LIGUE', style: GoogleFonts.chakraPetch(fontSize: 24, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: theme.colorScheme.onSurface)),
          RichText(
            text: TextSpan(
              style: const TextStyle(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.bold),
              children: [
                const TextSpan(text: '8,99€ '),
                TextSpan(text: '/ saison', style: TextStyle(fontSize: 12, color: theme.textTheme.bodyMedium?.color, fontWeight: FontWeight.normal)),
              ]
            )
          ),
          const SizedBox(height: 24),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.05)),
            ),
            child: Column(
              children: [
                _buildModalRow(LucideIcons.check, AppColors.primary, 'Débloque le mode Keeper/Dynasty pour cette ligue uniquement.', theme),
                const SizedBox(height: 12),
                _buildModalRow(LucideIcons.x, AppColors.error, 'N\'inclut pas les autres avantages de l\'abonnement PRO+', theme, isMuted: true),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          InkWell(
            onTap: () => Navigator.pop(context, 'Pass Ligue (8,99€)'),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 15)],
              ),
              child: const Text('PROCÉDER AU PAIEMENT', textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildModalRow(IconData icon, Color color, String text, ThemeData theme, {bool isMuted = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: isMuted ? theme.textTheme.bodyMedium?.color : theme.colorScheme.onSurface, fontSize: 12, height: 1.4),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// MODALE : ABONNEMENT PRO+
// ============================================================================
class ProPlusModal extends StatefulWidget {
  const ProPlusModal({super.key});

  @override
  State<ProPlusModal> createState() => _ProPlusModalState();
}

class _ProPlusModalState extends State<ProPlusModal> {
  String _billingCycle = 'annual';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.bg : const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.gold, width: 2),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Détails de l\'offre', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.0)),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(LucideIcons.x, color: Colors.grey, size: 20),
              )
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.gold, width: 2),
              boxShadow: [BoxShadow(color: AppColors.gold.withOpacity(0.3), blurRadius: 20)],
            ),
            child: const Icon(LucideIcons.crown, color: AppColors.gold, size: 40),
          ),
          const SizedBox(height: 16),
          Text('ABONNEMENT PRO+', style: GoogleFonts.chakraPetch(fontSize: 24, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: AppColors.gold)),
          const Text('L\'expérience Fantasy Ultime.', style: TextStyle(color: AppColors.muted, fontSize: 12)),
          
          const SizedBox(height: 24),
          
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _billingCycle = 'monthly'),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _billingCycle == 'monthly' ? AppColors.gold.withOpacity(0.1) : AppColors.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _billingCycle == 'monthly' ? AppColors.gold : Colors.white.withOpacity(0.1)),
                    ),
                    child: Column(
                      children: [
                        const Text('MENSUEL', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                        const SizedBox(height: 4),
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(color: AppColors.gold, fontSize: 18, fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(text: '3,33€'),
                              TextSpan(text: '/mois', style: TextStyle(fontSize: 10, color: AppColors.muted, fontWeight: FontWeight.normal)),
                            ]
                          )
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _billingCycle = 'annual'),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _billingCycle == 'annual' ? AppColors.gold.withOpacity(0.1) : AppColors.card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _billingCycle == 'annual' ? AppColors.gold : Colors.white.withOpacity(0.1)),
                        ),
                        child: Column(
                          children: [
                            const Text('ANNUEL', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                            const SizedBox(height: 4),
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(color: AppColors.gold, fontSize: 18, fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(text: '39,99€'),
                                  TextSpan(text: '/an', style: TextStyle(fontSize: 10, color: AppColors.muted, fontWeight: FontWeight.normal)),
                                ]
                              )
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: -8, right: -4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.gold,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.bg),
                          ),
                          child: const Text('2 MOIS OFFERTS', style: TextStyle(color: Colors.black, fontSize: 8, fontWeight: FontWeight.bold)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.gold.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                _buildModalRow(LucideIcons.globe, AppColors.gold, 'Déblocage de l\'ensemble des championnats de football réels.'),
                const SizedBox(height: 12),
                _buildModalRow(LucideIcons.infinity, AppColors.gold, 'Création illimitée de ligues Keeper et Dynasty.'),
                const SizedBox(height: 12),
                _buildModalRow(LucideIcons.trendingUp, AppColors.gold, 'Accès aux Diamond Trends (Marché des transferts).'),
                const SizedBox(height: 12),
                _buildModalRow(LucideIcons.activity, AppColors.gold, 'Toutes les stats avancées pour le scoring (xG, passes clés...).'),
                const SizedBox(height: 12),
                _buildModalRow(LucideIcons.shieldOff, AppColors.gold, 'Expérience 100% Zéro Pub.'),
              ],
            ),
          ),
          const SizedBox(height: 32),
          InkWell(
            onTap: () => Navigator.pop(context, 'PRO+ ${_billingCycle == 'annual' ? 'Annuel (39,99€)' : 'Mensuel (3,33€)'}'),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.gold, Color(0xFFF59E0B)]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: AppColors.gold.withOpacity(0.3), blurRadius: 15)],
              ),
              child: const Text('DEVENIR PRO+', textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildModalRow(IconData icon, Color color, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey[300], fontSize: 12, height: 1.4),
          ),
        ),
      ],
    );
  }
}

// --- UTILITAIRE : FOND GRILLE ---
class GridPainter extends CustomPainter {
  final Color color;
  final double spacing;

  GridPainter({required this.color, required this.spacing});

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
