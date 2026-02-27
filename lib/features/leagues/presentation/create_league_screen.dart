import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';
import 'league_controller.dart';
import 'widgets/create_league_components.dart';

class CreateLeagueScreen extends ConsumerStatefulWidget {
  const CreateLeagueScreen({super.key});

  @override
  ConsumerState<CreateLeagueScreen> createState() => _CreateLeagueScreenState();
}

class _CreateLeagueScreenState extends ConsumerState<CreateLeagueScreen> {
  // --- ÉTATS ---
  String _leagueName = '';
  String _leagueType = 'standard'; // 'standard', 'keeper', 'dynasty'
  int _playerCount = 8;
  DateTime? _draftDate;

  // Simulation Utilisateur
  final bool _isPremiumUser = false;

  bool get _isPremiumMode => 
    (_leagueType == 'keeper' || _leagueType == 'dynasty') && !_isPremiumUser;

  bool get _isFormValid {
    final bool isNameValid = _leagueName.trim().length >= 4;
    final bool isDateValid = _draftDate != null && 
                             _draftDate!.isAfter(DateTime.now().add(const Duration(minutes: 59)));
    
    return isNameValid &&
           _leagueType.isNotEmpty &&
           isDateValid &&
           _playerCount >= 4 &&
           _playerCount <= 20;
  }

  // --- ACTIONS ---
  Future<void> _handleNextStep() async {
    if (!_isPremiumMode) {
      if (_leagueName.trim().isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Veuillez entrer un nom de ligue')),
          );
        }
        return;
      }
      
      try {
        debugPrint('--- DEBUT CREATION LIGUE ---');
        final leagueId = await ref.read(leagueControllerProvider.notifier).createLeague(
          _leagueName.trim(),
          _leagueType,
          _playerCount,
          _draftDate ?? DateTime.now().add(const Duration(days: 7)),
        );

        if (leagueId != null && mounted) {
           debugPrint('✅ Ligue creee avec succes. ID: $leagueId');
           debugPrint('Navigation vers /create-league/config');
           context.push('/create-league/config', extra: leagueId);
        } else if (mounted) {
           final error = ref.read(leagueControllerProvider).error;
           debugPrint('❌ Erreur de creation de ligue: $error');
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
               content: Text('Erreur : $error'),
               backgroundColor: AppColors.error,
             ),
           );
        }
      } catch (e, stackTrace) {
        debugPrint('❌ Exception in _handleNextStep: $e');
        debugPrint(stackTrace.toString());
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text('Exception lors de la navigation : $e'), backgroundColor: AppColors.error),
           );
        }
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _draftDate ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryVariant,
              onPrimary: Colors.black,
              surface: AppColors.card,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && context.mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: AppColors.primaryVariant,
                onPrimary: Colors.black,
                surface: AppColors.card,
                onSurface: Colors.white,
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          _draftDate = DateTime(
            pickedDate.year, pickedDate.month, pickedDate.day,
            pickedTime.hour, pickedTime.minute,
          );
        });
      }
    }
  }

  void _showPaymentModal(String planName) {
    Navigator.pop(context); // Fermer la modale d'info
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Redirection vers le paiement pour : $planName'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  // --- UI BUILDERS ---
  @override
  Widget build(BuildContext context) {
    final leagueState = ref.watch(leagueControllerProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // 1. Grille de fond
          Positioned.fill(
            child: CustomPaint(
              painter: GridPainter(
                color: AppColors.secondary.withOpacity(isDark ? 0.05 : 0.1),
                spacing: 40.0,
              ),
            ),
          ),

          // 2. Contenu Principal
          SafeArea(
            child: Column(
              children: [
                // HEADER
                _buildHeader(),

                // FORMULAIRE SCROLLABLE
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // NOM
                        _buildSectionLabel('Nom de la ligue', LucideIcons.trophy, AppColors.primary),
                        const SizedBox(height: 12),
                        TextField(
                          onChanged: (val) => setState(() => _leagueName = val),
                          style: GoogleFonts.chakraPetch(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                          decoration: InputDecoration(
                            hintText: 'EX: LIGUE DES CHAMPIONS',
                            hintStyle: GoogleFonts.chakraPetch(color: isDark ? Colors.grey[700] : Colors.grey[400]),
                            fillColor: theme.colorScheme.surface,
                            filled: true,
                            contentPadding: const EdgeInsets.all(16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.1)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.1)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: AppColors.primary),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text('Minimum 4 caractères.', style: TextStyle(fontSize: 10, color: AppColors.muted)),
                        const SizedBox(height: 32),

                        // MODE DE JEU
                        _buildSectionLabel('Type de Ligue', LucideIcons.settings, AppColors.secondary),
                        const SizedBox(height: 12),
                        Column(
                          children: [
                            _buildModeCard('standard', 'STANDARD', 'Redraft chaque saison.', LucideIcons.zap, AppColors.secondary),
                            const SizedBox(height: 12),
                            _buildModeCard('keeper', 'KEEPER', 'Gardez 3 joueurs clés.', LucideIcons.repeat, AppColors.primary),
                            const SizedBox(height: 12),
                            _buildModeCard('dynasty', 'DYNASTY', 'Carrière longue durée.', LucideIcons.infinity, const Color(0xFFA855F7)), // Violet
                          ],
                        ),

                        // OFFRES PREMIUM (Affiche si Keeper/Dynasty sélectionné)
                        if (_isPremiumMode) ...[
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(child: _buildPassLigueCard()),
                              const SizedBox(width: 12),
                              Expanded(child: _buildProPlusCard()),
                            ],
                          ),
                        ],

                        const SizedBox(height: 32),

                        // DATE DRAFT
                        _buildSectionLabel('Date de la Draft', LucideIcons.calendar, const Color(0xFFA855F7)),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  _draftDate == null 
                                      ? 'Sélectionner une date' 
                                      : '${_draftDate!.day.toString().padLeft(2, '0')}/${_draftDate!.month.toString().padLeft(2, '0')}/${_draftDate!.year} à ${_draftDate!.hour.toString().padLeft(2, '0')}:${_draftDate!.minute.toString().padLeft(2, '0')}',
                                  style: TextStyle(
                                    color: _draftDate == null ? (isDark ? Colors.grey[600] : Colors.grey[400]) : theme.colorScheme.onSurface,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'À programmer au minimum 1h à l\'avance.\nTous les managers recevront une notification 1h avant.',
                          style: TextStyle(fontSize: 10, color: AppColors.muted),
                        ),

                        const SizedBox(height: 32),

                        // PARTICIPANTS
                        _buildSectionLabel('Participants', LucideIcons.users, AppColors.primaryVariant),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.05)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildStepperBtn(LucideIcons.minus, () {
                                if (_playerCount > 4) setState(() => _playerCount -= 2);
                              }, theme),
                              Column(
                                children: [
                                  Text(
                                    '$_playerCount',
                                    style: GoogleFonts.chakraPetch(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.onSurface
                                    ),
                                  ),
                                  Text('MANAGERS', style: TextStyle(fontSize: 10, color: theme.textTheme.bodyMedium?.color)),
                                ],
                              ),
                              _buildStepperBtn(LucideIcons.plus, () {
                                if (_playerCount < 20) setState(() => _playerCount += 2);
                              }, theme),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // FOOTER ACTION (Cache si mode premium non payé)
                if (!_isPremiumMode)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      border: Border(top: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.1))),
                    ),
                    child: InkWell(
                      onTap: (!leagueState.isLoading && _isFormValid) ? _handleNextStep : null,
                      borderRadius: BorderRadius.circular(16),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: _isFormValid 
                              ? const LinearGradient(colors: [AppColors.primary, AppColors.primaryVariant])
                              : null,
                          color: _isFormValid ? null : theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: _isFormValid ? null : Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
                          boxShadow: _isFormValid ? [
                            BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 20),
                          ] : [],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              leagueState.isLoading ? 'CRÉATION...' : 'CONFIGURER LES RÈGLES',
                              style: TextStyle(color: _isFormValid ? Colors.black : Colors.grey[600], fontWeight: FontWeight.bold, letterSpacing: 1.2),
                            ),
                            const SizedBox(width: 8),
                            Icon(leagueState.isLoading ? LucideIcons.loader : LucideIcons.arrowRight, color: _isFormValid ? Colors.black : Colors.grey[600], size: 20),
                          ],
                        ),
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

  // --- SUB-WIDGETS ---
  
  Widget _buildHeader() {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              shape: BoxShape.circle,
              border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
            ),
            child: IconButton(
              icon: Icon(LucideIcons.chevronLeft, color: theme.colorScheme.onSurface, size: 20),
              onPressed: () {
                if (Navigator.canPop(context)) Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ÉTAPE 1/2',
                style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5),
              ),
              Text(
                'CRÉATION',
                style: GoogleFonts.chakraPetch(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 8),
        Text(
          text.toUpperCase(),
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildModeCard(String id, String title, String desc, IconData icon, Color color) {
    final isSelected = _leagueType == id;
    final isPremium = (id == 'keeper' || id == 'dynasty');
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => setState(() => _leagueType = id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(isDark ? 0.1 : 0.15) : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : theme.colorScheme.onSurface.withOpacity(0.05),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.2), blurRadius: 15)] : [],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? color : theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: isSelected ? (isDark ? Colors.black : Colors.white) : theme.textTheme.bodyMedium?.color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.chakraPetch(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: isSelected ? theme.colorScheme.onSurface : theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                      if (isPremium && !_isPremiumUser && !isSelected)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSurface.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Icon(LucideIcons.lock, size: 10, color: theme.textTheme.bodyMedium?.color),
                              const SizedBox(width: 4),
                              Text('PREMIUM', style: GoogleFonts.inter(fontSize: 8, fontWeight: FontWeight.bold, color: theme.textTheme.bodyMedium?.color)),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: TextStyle(fontSize: 10, color: theme.textTheme.bodyMedium?.color),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                child: Icon(LucideIcons.checkCircle2, color: color, size: 24),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPassLigueCard() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: () => _showModal('pass'),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(color: AppColors.primary.withOpacity(0.1), blurRadius: 10),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0, right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), topRight: Radius.circular(16)),
                ),
                child: const Text('ACHAT UNIQUE', style: TextStyle(color: Colors.black, fontSize: 8, fontWeight: FontWeight.bold)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary.withOpacity(0.5)),
                    ),
                    child: const Icon(LucideIcons.ticket, color: AppColors.primary),
                  ),
                  const SizedBox(height: 12),
                  Text('PASS\nLIGUE', textAlign: TextAlign.center, style: GoogleFonts.chakraPetch(fontSize: 16, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: theme.colorScheme.onSurface, height: 1.1)),
                  const SizedBox(height: 4),
                  const Text('8,99€', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Débloquer', textAlign: TextAlign.center, style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProPlusCard() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: () => _showModal('pro'),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            // On conserve un fond relativement sombre pour le badge Premium même en light mode pour que le doré ressorte.
            colors: isDark ? const [AppColors.card, Color(0xFF0A0D18)] : [const Color(0xFF1E293B), const Color(0xFF0F172A)],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.gold.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(color: AppColors.gold.withOpacity(0.15), blurRadius: 15),
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(color: AppColors.gold.withOpacity(0.03)),
            ),
            Positioned(
              top: 0, right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: const BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), topRight: Radius.circular(16)),
                ),
                child: const Text('RENTABLE', style: TextStyle(color: Colors.black, fontSize: 8, fontWeight: FontWeight.bold)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: AppColors.gold.withOpacity(0.4), blurRadius: 10)],
                    ),
                    child: const Icon(LucideIcons.crown, color: Colors.black),
                  ),
                  const SizedBox(height: 12),
                  // Maintien du texte en blanc ici car le fond Premium est toujours sombre
                  Text('ABONNEMENT\nPRO+', textAlign: TextAlign.center, style: GoogleFonts.chakraPetch(fontSize: 12, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.white, height: 1.2)),
                  const SizedBox(height: 4),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(text: 'Dès 3,33€'),
                        TextSpan(text: '/mo', style: TextStyle(fontSize: 8, color: AppColors.muted, fontWeight: FontWeight.normal)),
                      ]
                    )
                  ),
                  const Spacer(),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Découvrir', textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepperBtn(IconData icon, VoidCallback onTap, ThemeData theme) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
        ),
        child: Icon(icon, color: theme.colorScheme.onSurface, size: 20),
      ),
    );
  }

  // --- GESTION DES MODALES ---
  void _showModal(String type) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: type == 'pass' ? const PassLigueModal() : const ProPlusModal(),
      ),
    ).then((action) {
      if (action != null && mounted) {
        _showPaymentModal(action as String);
      }
    });
  }
}
