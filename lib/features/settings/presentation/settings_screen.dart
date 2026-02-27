import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_provider.dart';
import '../../auth/presentation/auth_controller.dart';
import '../domain/user_stats_data.dart';
import 'settings_controller.dart';
import 'widgets/premium_offers_section.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String _avatarUrl = "https://api.dicebear.com/7.x/avataaars/png?seed=Dlaw";
  bool _isLoading = false;
  final _usernameController = TextEditingController();
  final _focusNode = FocusNode();

  bool _isEditingUsername = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authControllerProvider).value;
    if (user != null) {
      if (user.avatarUrl != null && user.avatarUrl!.isNotEmpty) {
        _avatarUrl = user.avatarUrl!;
      } else {
        _avatarUrl = "https://api.dicebear.com/7.x/avataaars/png?seed=${user.username ?? 'Pro11'}";
      }
      _usernameController.text = user.username ?? 'Manager';
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _saveUsername() async {
    final currentName = ref.read(authControllerProvider).value?.username;
    if (_usernameController.text.trim().isNotEmpty && _usernameController.text.trim() != currentName) {
      try {
        await ref.read(authControllerProvider.notifier).updateProfile(username: _usernameController.text.trim());
        if (mounted) setState(() => _isEditingUsername = false);
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    } else {
      if (mounted) setState(() => _isEditingUsername = false);
    }
  }

  void _simulateImageUpload() async {
    setState(() {
      _avatarUrl = "https://api.dicebear.com/7.x/avataaars/png?seed=${DateTime.now().millisecondsSinceEpoch}";
      _isLoading = true;
    });

    try {
      await ref.read(authControllerProvider.notifier).updateProfile(avatarUrl: _avatarUrl);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo de profil mise à jour !'),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider).value;
    final statsAsync = ref.watch(settingsControllerProvider);
    final stats = statsAsync.value ?? const UserStatsData();

    if (user == null) return const Center(child: CircularProgressIndicator());

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: GridPainter(
                color: AppColors.secondary.withValues(alpha: 0.05),
                spacing: 40.0,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                        ),
                        child: IconButton(
                          icon: Icon(LucideIcons.chevronLeft, color: theme.textTheme.bodyLarge?.color, size: 20),
                          onPressed: () {
                            if (Navigator.canPop(context)) Navigator.pop(context);
                            else context.go('/');
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'PARAMÈTRES',
                        style: GoogleFonts.chakraPetch(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.displayLarge?.color,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                            gradient: LinearGradient(
                              colors: [theme.colorScheme.surface, theme.scaffoldBackgroundColor],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10)),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: -20,
                                right: -20,
                                child: Transform.rotate(
                                  angle: 0.2,
                                  child: Icon(LucideIcons.user, size: 150, color: Colors.white.withValues(alpha: 0.02)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: _simulateImageUpload,
                                      child: Container(
                                        width: 96,
                                        height: 96,
                                        margin: const EdgeInsets.only(bottom: 12),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(color: AppColors.primary, width: 4),
                                          boxShadow: [
                                            BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 20)
                                          ],
                                        ),
                                        child: Stack(
                                          children: [
                                            ClipOval(
                                              child: _isLoading
                                                ? const CircularProgressIndicator(color: AppColors.primary)
                                                : Image.network(_avatarUrl, width: 96, height: 96, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const Icon(LucideIcons.user, size: 40, color: AppColors.muted)),
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              right: 0,
                                              child: Container(
                                                padding: const EdgeInsets.all(6),
                                                decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle, border: Border.all(color: theme.colorScheme.surface, width: 3)),
                                                child: Icon(LucideIcons.camera, size: 14, color: theme.scaffoldBackgroundColor),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        if (_isEditingUsername)
                                          SizedBox(
                                            width: 150,
                                            child: TextField(
                                              controller: _usernameController,
                                              focusNode: _focusNode,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.chakraPetch(fontSize: 24, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, color: theme.textTheme.displayLarge?.color ?? Colors.white),
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                isDense: true,
                                                contentPadding: EdgeInsets.zero,
                                              ),
                                            ),
                                          )
                                        else
                                          Text(
                                            user.username ?? "Coach",
                                            style: GoogleFonts.chakraPetch(fontSize: 24, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, color: theme.textTheme.displayLarge?.color ?? Colors.white),
                                          ),
                                        const SizedBox(width: 4),
                                        if (_isEditingUsername)
                                          IconButton(
                                            icon: const Icon(LucideIcons.save, size: 20, color: AppColors.primary),
                                            onPressed: _saveUsername,
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                          )
                                        else
                                          IconButton(
                                            icon: const Icon(LucideIcons.edit3, size: 16, color: AppColors.muted),
                                            onPressed: () {
                                              setState(() {
                                                _isEditingUsername = true;
                                                _usernameController.text = user.username ?? '';
                                              });
                                              Future.delayed(const Duration(milliseconds: 50), () {
                                                if (mounted) _focusNode.requestFocus();
                                              });
                                            },
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(color: Color(stats.badgeColorHex).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4), border: Border.all(color: Color(stats.badgeColorHex).withValues(alpha: 0.3))),
                                      child: Text(stats.title, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Color(stats.badgeColorHex), letterSpacing: 1.0)),
                                    ),
                                    const SizedBox(height: 8),
                                    Text("Membre depuis 2026", style: GoogleFonts.inter(fontSize: 12, color: AppColors.muted)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        const PremiumOffersSection(),
                        const SizedBox(height: 24),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, bottom: 12),
                            child: Row(
                              children: [
                                const Icon(LucideIcons.trophy, size: 12, color: AppColors.muted),
                                const SizedBox(width: 8),
                                Text("CARRIÈRE", style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.muted, letterSpacing: 1.5)),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.05) : theme.colorScheme.onSurface.withValues(alpha: 0.1))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatItem(LucideIcons.trophy, "CHAMPION", "${stats.champions}", const Color(0xFFFFD700), stats.champions > 0 ? 1.0 : 0.4),
                              Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.05)),
                              _buildStatItem(LucideIcons.medal, "PODIUMS", "${stats.podiums}", AppColors.secondary, stats.podiums > 0 ? 1.0 : 0.4),
                              Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.05)),
                              _buildStatItem(LucideIcons.star, "MVP", "${stats.mvps}", AppColors.primary, stats.mvps > 0 ? 1.0 : 0.4),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildSectionTitle("Compte", isDark),
                        Container(
                          decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.05) : theme.colorScheme.onSurface.withValues(alpha: 0.1))),
                          child: Column(
                            children: [
                              _buildSettingRow(icon: LucideIcons.mail, label: "Email", value: user.email, iconColor: Colors.blue, onTap: () => _updateEmailDialog(context, user.email)),
                              const Divider(height: 1, color: Colors.white10),
                              _buildSettingRow(icon: LucideIcons.lock, label: "Réinitialiser le mot de passe", iconColor: Colors.blue, onTap: () => _resetPassword(context, user.email)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildSectionTitle("Système", isDark),
                        Container(
                          decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.05) : theme.colorScheme.onSurface.withValues(alpha: 0.1))),
                          child: Column(
                            children: [
                              _buildSettingRow(icon: LucideIcons.bell, label: "Notifications Push", value: "ON", iconColor: AppColors.secondary),
                              const Divider(height: 1, color: Colors.white10),
                              _buildSettingRow(icon: LucideIcons.moon, label: "Mode Sombre", 
                                value: ref.watch(themeModeNotifierProvider) == ThemeMode.dark ? "Activé" : "Désactivé", 
                                iconColor: Colors.grey,
                                onTap: () => ref.read(themeModeNotifierProvider.notifier).toggleTheme(),
                              ),
                              const Divider(height: 1, color: Colors.white10),
                              _buildSettingRow(icon: LucideIcons.helpCircle, label: "Aide & FAQ", iconColor: const Color(0xFFFFD700), onTap: () async {
                                final url = Uri.parse('https://sites.google.com/view/pro11-fantasyleague/accueil?authuser=1');
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url, mode: LaunchMode.externalApplication);
                                }
                              }),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.error.withValues(alpha: 0.2))),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () => ref.read(authControllerProvider.notifier).signOut(),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(LucideIcons.logOut, size: 18, color: AppColors.error),
                                    const SizedBox(width: 8),
                                    Text("Se déconnecter", style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.error)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                           onPressed: () => _showDeleteConfirmation(context),
                           child: Text("Supprimer mon compte", style: GoogleFonts.inter(fontSize: 12, color: AppColors.error.withValues(alpha: 0.8), decoration: TextDecoration.underline, decorationColor: AppColors.error.withValues(alpha: 0.8)))
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: Text("PROII v1.2.0 • Build 2026", style: GoogleFonts.inter(fontSize: 10, color: AppColors.muted.withValues(alpha: 0.6))),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value, Color color, double opacity) {
    return Opacity(
      opacity: opacity,
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text(label, style: GoogleFonts.inter(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.muted, letterSpacing: 0.5)),
          Text(value, style: GoogleFonts.chakraPetch(fontSize: 16, fontWeight: FontWeight.w900, color: Theme.of(context).textTheme.displayLarge?.color)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, bottom: 12),
        child: Text(title.toUpperCase(), style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? AppColors.muted : AppColors.lightMuted, letterSpacing: 1.5)),
      ),
    );
  }

  Widget _buildSettingRow({required IconData icon, required String label, String? value, required Color iconColor, VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap ?? () {},
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white.withValues(alpha: 0.1))),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              const SizedBox(width: 16),
              Expanded(child: Text(label, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: Theme.of(context).textTheme.displayLarge?.color))),
              if (value != null) ...[
                Text(value, style: GoogleFonts.inter(fontSize: 12, color: AppColors.muted)),
                const SizedBox(width: 8),
              ],
              const Icon(LucideIcons.chevronRight, size: 16, color: AppColors.muted),
            ],
          ),
        ),
      ),
    );
  }

  void _updateEmailDialog(BuildContext context, String currentEmail) {
    final emailController = TextEditingController(text: currentEmail);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text('Modifier l\'email', style: TextStyle(color: Theme.of(context).textTheme.displayLarge?.color)),
        content: TextField(
          controller: emailController,
          style: TextStyle(color: Theme.of(context).textTheme.displayLarge?.color),
          decoration: const InputDecoration(hintText: 'Nouvel e-mail', hintStyle: TextStyle(color: AppColors.muted)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Annuler', style: TextStyle(color: Theme.of(context).textTheme.displayLarge?.color))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Demande de changement d\'email traitée. (Logique backend à implémenter)')));
            },
            child: Text('Mettre à jour', style: TextStyle(color: AppColors.bg, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _resetPassword(BuildContext context, String email) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text('Réinitialiser le mot de passe ?', style: TextStyle(color: Theme.of(context).textTheme.displayLarge?.color)),
        content: Text(
          'Un e-mail sera envoyé à $email pour vous permettre de choisir un nouveau mot de passe. Confirmez-vous ?',
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler', style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () async {
              Navigator.pop(context); // Close the dialog
              try {
                await ref.read(authControllerProvider.notifier).resetPassword(email);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email de réinitialisation envoyé'), backgroundColor: Colors.green));
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
                }
              }
            },
            child: Text('Confirmer', style: TextStyle(color: AppColors.bg, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text('SUPPRIMER LE COMPTE ?', style: TextStyle(color: AppColors.error)),
        content: Text('Cette action est irréversible. Toutes vos équipes et données seront effacées.', style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Annuler', style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () async {
               Navigator.pop(context);
               try {
                 await ref.read(authControllerProvider.notifier).deleteAccount();
               } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
                  }
               }
            },
            child: Text('SUPPRIMER', style: TextStyle(color: Theme.of(context).textTheme.displayLarge?.color, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }


}

class GridPainter extends CustomPainter {
  final Color color;
  final double spacing;

  GridPainter({required this.color, required this.spacing});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 1.0;
    for (double i = 0; i < size.width; i += spacing) canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    for (double i = 0; i < size.height; i += spacing) canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
