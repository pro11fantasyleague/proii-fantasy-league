import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_theme.dart';

void showProPlusModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const ProPlusModal(),
  );
}

void showPassLigueModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const PassLigueModal(),
  );
}

class ProPlusModal extends StatelessWidget {
  const ProPlusModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          color: const Color(0xFF131B36),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(color: const Color(0xFFFFD700).withOpacity(0.03)),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFD700),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8)),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(-2, 2))]
                  ),
                  child: Text(
                    "RECOMMANDÉ",
                    style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.black, letterSpacing: 1.0),
                  ),
                ),
              ),
              
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD700),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: const Color(0xFFFFD700).withOpacity(0.4), blurRadius: 15)],
                          ),
                          child: const Center(child: Icon(LucideIcons.crown, color: Colors.black, size: 24)),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, color: Colors.white, height: 1.0),
                                children: const [
                                  TextSpan(text: 'DÉTAILS '),
                                  TextSpan(text: 'PRO+', style: TextStyle(color: Color(0xFFFFD700))),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(LucideIcons.x, color: Colors.grey),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    _buildFeatureRow("👑", "Modes illimités : Accédez aux modes avancés \"Keeper\" et \"Dynasty\" pour gérer votre équipe sur plusieurs saisons."),
                    _buildFeatureRow("💎", "Scouting : Dénicher les pépites sur le marché des joueurs libres avant tout le monde."),
                    _buildFeatureRow("🌍", "Championnats complets : Débloquez toutes les championnats réels pour vos drafts."),
                    _buildFeatureRow("📊", "Stats avancées : Accès total aux statistiques complexes (xG, passes clés...)."),
                    _buildFeatureRow("🚫", "Zéro pub : Une immersion totale."),
                    
                    const SizedBox(height: 24),
                    
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.2)),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Mensuel", style: GoogleFonts.inter(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
                                  Text("4,99€ / mois", style: GoogleFonts.inter(fontSize: 12, color: AppColors.muted)),
                                ],
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: const Color(0xFFFFD700),
                                  side: const BorderSide(color: Color(0xFFFFD700)),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                                  minimumSize: const Size(0, 36),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Le système de paiement PRO+ sera intégré prochainement !')));
                                },
                                child: Text("S'abonner", style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold)),
                              )
                            ],
                          ),
                          const Padding(
                             padding: EdgeInsets.symmetric(vertical: 12),
                             child: Divider(color: Colors.white10, height: 1),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text("Annuel", style: GoogleFonts.inter(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(color: const Color(0xFFFFD700), borderRadius: BorderRadius.circular(4)),
                                          child: Text("2 MOIS OFFERTS", style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.black)),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text("49,99€/an (~4,16€/mois)", style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFFFFD700))),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFFD700),
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                                  minimumSize: const Size(0, 36),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  elevation: 4,
                                  shadowColor: const Color(0xFFFFD700).withOpacity(0.5),
                                ),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Le système de paiement PRO+ sera intégré prochainement !')));
                                },
                                child: Text("S'abonner", style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold)),
                              )
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
        ),
      ),
    );
  }

  Widget _buildFeatureRow(String iconEmoji, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(iconEmoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade300, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class PassLigueModal extends StatelessWidget {
  const PassLigueModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          color: const Color(0xFF131B36),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF00E0FF).withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: const BoxDecoration(
                    color: Color(0xFF00E0FF),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8)),
                  ),
                  child: Text(
                    "ACHAT UNIQUE",
                    style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.black, letterSpacing: 1.0),
                  ),
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(LucideIcons.x, color: Colors.grey),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),
                    const Icon(LucideIcons.ticket, color: Color(0xFF00E0FF), size: 48),
                    const SizedBox(height: 16),
                    Text(
                      "DÉTAILS DU PASS LIGUE",
                      style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Le Pass Ligue vous permet de débloquer les modes historiques (Keeper, Dynasty) uniquement pour la ligue de votre choix.\n\nIl est valable pour une durée d'une saison complète. Vous pouvez acheter autant de passes que nécessaires si vous participez à plusieurs ligues !\n\nL'achat sera bientôt disponible.",
                      style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade300, height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00E0FF),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text("FERMER", style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
