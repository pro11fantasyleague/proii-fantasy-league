import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:async';
import '../../../core/theme/app_theme.dart';
import 'league_controller.dart';
import 'widgets/create_league_components.dart';

class LeagueConfigScreen extends ConsumerStatefulWidget {
  final String leagueId;

  const LeagueConfigScreen({super.key, required this.leagueId});

  @override
  ConsumerState<LeagueConfigScreen> createState() => _LeagueConfigScreenState();
}

class _LeagueConfigScreenState extends ConsumerState<LeagueConfigScreen> {
  // --- SIMULATION UTILISATEUR & RÈGLES ---
  static const bool _isPremiumUser =
      false; // Mettez à true pour tester la version Pro
  static const int _maxLeaguesFree = 2;
  static const int _maxStats = 9;

  // --- ÉTATS LOCAUX ---
  List<String> _selectedLeagues = ['L1'];
  List<String> _selectedStats = [
    'goals',
    'assists',
    'shots_ontarget',
    'passes_key',
    'interceptions',
    'tackles',
    'saves',
  ];
  Map<String, int> _roster = {
    'gk': 2,
    'def': 4,
    'mid': 4,
    'att': 2,
    'uti': 3,
    'inj': 0,
  };

  // État du Toast (Alerte personnalisée)
  String? _alertMessage;
  Timer? _alertTimer;

  // --- DONNÉES ---
  final List<Map<String, String>> _leaguesData = [
    {'id': 'L1', 'name': 'Ligue 1', 'country': 'FRA'},
    {'id': 'PL', 'name': 'Premier League', 'country': 'ENG'},
    {'id': 'LIGA', 'name': 'La Liga', 'country': 'ESP'},
    {'id': 'SERIE', 'name': 'Serie A', 'country': 'ITA'},
    {'id': 'BUND', 'name': 'Bundesliga', 'country': 'GER'},
    {'id': 'NOS', 'name': 'Liga Portugal', 'country': 'POR'},
  ];

  final List<Map<String, dynamic>> _statsPool = [
    {'id': 'goals', 'label': 'Buts', 'category': 'Attaque', 'isPro': false},
    {'id': 'shots_ontarget', 'label': 'Tirs Cadrés', 'category': 'Attaque', 'isPro': false},
    {'id': 'xg', 'label': 'xG (Expected Goals)', 'category': 'Attaque', 'isPro': true},
    {'id': 'shots_ontarget_pct', 'label': '% Tir Cadré', 'category': 'Attaque', 'isPro': true},
    {'id': 'conversion_pct', 'label': 'Conv %', 'category': 'Attaque', 'isPro': true},

    {'id': 'assists', 'label': 'Passes D.', 'category': 'Construction', 'isPro': false},
    {'id': 'crosses', 'label': 'Centres Réussis', 'category': 'Construction', 'isPro': false},
    {'id': 'xa', 'label': 'xA (Expected Assists)', 'category': 'Construction', 'isPro': true},
    {'id': 'passes_completed_pct', 'label': '% Passes Réussies', 'category': 'Construction', 'isPro': true},
    {'id': 'passes_key', 'label': 'Passes Clés', 'category': 'Construction', 'isPro': false},

    {'id': 'tackles', 'label': 'Tacles', 'category': 'Défense', 'isPro': false},
    {'id': 'interceptions', 'label': 'Interceptions', 'category': 'Défense', 'isPro': false},
    {'id': 'duels_won_air', 'label': 'Duels aériens', 'category': 'Défense', 'isPro': false},
    {'id': 'duels_won_ground', 'label': 'Duels au sol', 'category': 'Défense', 'isPro': false},
    {'id': 'clean_sheet', 'label': 'Clean Sheet', 'category': 'Défense', 'isPro': true},

    {'id': 'saves', 'label': 'Arrêts', 'category': 'Gardien', 'isPro': false},
    {'id': 'goals_conceded', 'label': 'Buts pris', 'category': 'Gardien', 'isPro': false},
    {'id': 'saves_pct', 'label': '% d\'arrêt', 'category': 'Gardien', 'isPro': true},

    {'id': 'fouls', 'label': 'Fautes', 'category': 'Discipline', 'isPro': false},
    {'id': 'yellow_cards', 'label': 'Cartons jaunes', 'category': 'Discipline', 'isPro': false},
    {'id': 'red_cards', 'label': 'Carton rouge', 'category': 'Discipline', 'isPro': false},
  ];

  // --- ACTIONS ---
  void _showAlert(String msg) {
    setState(() => _alertMessage = msg);
    _alertTimer?.cancel();
    _alertTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _alertMessage = null);
    });
  }

  void _toggleLeague(String id) {
    setState(() {
      if (_selectedLeagues.contains(id)) {
        _selectedLeagues.remove(id);
      } else {
        if (!_isPremiumUser && _selectedLeagues.length >= _maxLeaguesFree) {
          _showAlert(
            'Limite atteinte : $_maxLeaguesFree championnats max pour les comptes gratuits.',
          );
          return;
        }
        _selectedLeagues.add(id);
      }
    });
  }

  void _toggleStat(String id) {
    setState(() {
      if (_selectedStats.contains(id)) {
        _selectedStats.remove(id);
      } else {
        if (_selectedStats.length >= _maxStats) {
          _showAlert(
            'Limite atteinte : $_maxStats catégories statistiques maximum.',
          );
          return;
        }
        _selectedStats.add(id);
      }
    });
  }

  void _updateRoster(String pos, int val, int min, int max) {
    if (val >= min && val <= max) {
      setState(() {
        _roster[pos] = val;
      });
    }
  }

  void _showProModal() {
    showDialog(
      context: context,
      builder: (context) => const Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(16),
        child: ProPlusModal(),
      ),
    );
  }

  Future<void> _handleSave() async {
    final state = ref.read(leagueControllerProvider);
    if (state.isLoading) return;

    if (!_isPremiumUser && _selectedLeagues.length > _maxLeaguesFree) {
      _showAlert(
        'Limite atteinte : $_maxLeaguesFree championnats max pour les comptes gratuits.',
      );
      return;
    }
    if (_selectedStats.length > _maxStats) {
      _showAlert(
        'Limite atteinte : $_maxStats catégories statistiques maximum.',
      );
      return;
    }

    // Appel au Contrôleur pour sauvegarder la configuration
    final success = await ref
        .read(leagueControllerProvider.notifier)
        .saveConfiguration(
          leagueId: widget.leagueId,
          selectedLeagues: _selectedLeagues,
          selectedStats: _selectedStats,
          rosterConfig: _roster,
        );

    if (success && mounted) {
      context.go('/'); // Retour au Hub
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ligue initialisée avec succès, bon courage Coach ! ⚽'),
          backgroundColor: AppColors.secondary,
        ),
      );
    }
  }

  @override
  void dispose() {
    _alertTimer?.cancel();
    super.dispose();
  }

  // --- UI BUILDERS ---
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(leagueControllerProvider).isLoading;
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

          // 2. Contenu principal (Scrollable)
          Column(
            children: [
              // Header Fixe
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.onSurface.withOpacity(0.1),
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(
                            LucideIcons.chevronLeft,
                            color: theme.colorScheme.onSurface,
                            size: 20,
                          ),
                          onPressed: isLoading
                              ? null
                              : () {
                                  context.pop();
                                },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ÉTAPE 2/2',
                            style: GoogleFonts.inter(
                              color: AppColors.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                          Text(
                            'RÈGLES DU JEU',
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
                ),
              ),

              // Contenu Scrollable
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 8.0,
                  ),
                  child: IgnorePointer(
                    ignoring: isLoading,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLeaguesSection(),
                        const SizedBox(height: 32),
                        _buildScoringSection(),
                        const SizedBox(height: 32),
                        _buildRosterSection(),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),

              // Footer Fixe
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  border: Border(
                    top: BorderSide(
                      color: theme.colorScheme.onSurface.withOpacity(0.05),
                    ),
                  ),
                ),
                child: InkWell(
                  onTap: isLoading ? null : _handleSave,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryVariant],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: isLoading
                          ? [
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                  strokeWidth: 2,
                                ),
                              ),
                            ]
                          : [
                              const Icon(
                                LucideIcons.save,
                                color: Colors.black,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'SAUVEGARDER LA LIGUE',
                                style: GoogleFonts.inter(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 3. ALERT TOAST (Personnalisé, flottant en haut)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            top: _alertMessage != null ? 80 : 0, // Descend si actif
            left: 24,
            right: 24,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _alertMessage != null ? 1.0 : 0.0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.gold),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        LucideIcons.alertCircle,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Action impossible',
                            style: TextStyle(
                              color: AppColors.gold,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            _alertMessage ?? '',
                            style: TextStyle(
                              color: theme.textTheme.bodyMedium?.color,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- SECTIONS ---

  Widget _buildLeaguesSection() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                const Icon(
                  LucideIcons.globe,
                  size: 14,
                  color: AppColors.secondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'CHAMPIONNATS',
                  style: GoogleFonts.inter(
                    color: theme.textTheme.bodyMedium?.color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
            if (!_isPremiumUser)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _selectedLeagues.length >= _maxLeaguesFree
                      ? Colors.orange.withOpacity(0.2)
                      : AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: _selectedLeagues.length >= _maxLeaguesFree
                        ? Colors.orange.withOpacity(0.5)
                        : AppColors.primary.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  '${_selectedLeagues.length} / $_maxLeaguesFree (Gratuit)',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    color: _selectedLeagues.length >= _maxLeaguesFree
                        ? Colors.orange
                        : AppColors.primary,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          children: _leaguesData.map((league) {
            final isSelected = _selectedLeagues.contains(league['id']);
            final isDisabled =
                !_isPremiumUser &&
                !isSelected &&
                _selectedLeagues.length >= _maxLeaguesFree;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: GestureDetector(
                onTap: () => _toggleLeague(league['id']!),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.secondary.withOpacity(isDark ? 0.1 : 0.2)
                        : theme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.secondary
                          : theme.colorScheme.onSurface.withOpacity(0.05),
                    ),
                  ),
                  child: Opacity(
                    opacity: isDisabled ? 0.5 : 1.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          league['name']!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: isSelected
                                ? theme.colorScheme.onSurface
                                : theme.colorScheme.onSurface.withOpacity(0.8),
                          ),
                        ),
                        if (isSelected)
                          Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              color: AppColors.secondary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              LucideIcons.check,
                              size: 14,
                              color: Colors.black,
                            ),
                          )
                        else if (isDisabled)
                          const Icon(
                            LucideIcons.lock,
                            size: 16,
                            color: Colors.orange,
                          )
                        else
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.2,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (!_isPremiumUser)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: InkWell(
              onTap: _showProModal,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.gold.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      LucideIcons.crown,
                      size: 12,
                      color: AppColors.gold,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'DÉBLOQUER TOUS LES CHAMPIONNATS',
                      style: GoogleFonts.inter(
                        color: AppColors.gold,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

      ],
    );
  }

  Widget _buildScoringSection() {
    final categories = _statsPool.map((s) => s['category']).toSet().toList();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                const Icon(
                  LucideIcons.activity,
                  size: 14,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'STATISTIQUE',
                  style: GoogleFonts.inter(
                    color: theme.textTheme.bodyMedium?.color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _selectedStats.length >= _maxStats
                    ? Colors.red.withOpacity(0.2)
                    : AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: _selectedStats.length >= _maxStats
                      ? Colors.red.withOpacity(0.5)
                      : AppColors.primary.withOpacity(0.3),
                ),
              ),
              child: Text(
                '${_selectedStats.length} / $_maxStats',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: _selectedStats.length >= _maxStats
                      ? Colors.red[400]
                      : AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...categories.map((cat) {
          final statsInCat = _statsPool
              .where((s) => s['category'] == cat)
              .toList();
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
                  child: Text(
                    cat.toString().toUpperCase(),
                    style: TextStyle(
                      color: theme.textTheme.bodyMedium?.color,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: statsInCat.map((stat) {
                    final isSelected = _selectedStats.contains(stat['id']);
                    final isProStat = stat['isPro'] == true;
                    final isDisabled = !_isPremiumUser && isProStat;
                    final isLimitReached =
                        !isSelected && _selectedStats.length >= _maxStats;

                    return GestureDetector(
                      onTap: () {
                        if (isDisabled) {
                          _showProModal();
                          return;
                        }
                        _toggleStat(stat['id'] as String);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withOpacity(
                                  isDark ? 0.2 : 0.15,
                                )
                              : theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : theme.colorScheme.onSurface.withOpacity(0.05),
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.2),
                                    blurRadius: 10,
                                  ),
                                ]
                              : [],
                        ),
                        child: Opacity(
                          opacity: (isLimitReached || isDisabled) && !isSelected
                              ? 0.5
                              : 1.0,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                stat['label'] as String,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? (isDark
                                            ? AppColors.primary
                                            : theme.colorScheme.primary)
                                      : theme.textTheme.bodyMedium?.color,
                                ),
                              ),
                              if (isProStat) ...[
                                const SizedBox(width: 6),
                                const Icon(
                                  LucideIcons.lock,
                                  size: 10,
                                  color: AppColors.gold,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildRosterSection() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(LucideIcons.users, size: 14, color: Color(0xFFA855F7)),
            const SizedBox(width: 8),
            Text(
              'EFFECTIF (POSTES)',
              style: GoogleFonts.inter(
                color: theme.textTheme.bodyMedium?.color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.onSurface.withOpacity(0.05),
            ),
          ),
          child: Column(
            children: [
              _buildRosterStepper('Gardiens (GK)', 'gk', 1, 3, 'Idéal : 1 titulaire, 1 remplaçant.'),
              _buildRosterStepper('Défenseurs (DEF)', 'def', 3, 8, ''),
              _buildRosterStepper('Milieux (MID)', 'mid', 3, 8, ''),
              _buildRosterStepper('Attaquants (ATT)', 'att', 1, 6, ''),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(color: Colors.white10, height: 1),
              ),
              _buildRosterStepper('Banc (Bench)', 'uti', 3, 8, 'Pour gérer les rotations et blessures.'),
              _buildRosterStepper('Infirmerie (IR)', 'inj', 0, 4, 'Pour conserver ses stars blessées en mode Keeper/Dynasty.'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRosterStepper(String label, String key, int min, int max, String desc) {
    final value = _roster[key] ?? 0;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.onSurface.withOpacity(0.05),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
                Row(
                  children: [
                    _buildStepperBtn(LucideIcons.minus, () {
                      if (value > min) _updateRoster(key, value - 1, min, max);
                    }),
                    SizedBox(
                      width: 32,
                      child: Text(
                        value.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.primary,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                    _buildStepperBtn(LucideIcons.plus, () {
                      if (value < max) _updateRoster(key, value + 1, min, max);
                    }),
                  ],
                ),
              ],
            ),
            if (desc.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      desc,
                      style: TextStyle(
                        fontSize: 10,
                        color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStepperBtn(IconData icon, VoidCallback onTap) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: theme.colorScheme.onSurface.withOpacity(0.1),
          ),
        ),
        child: Icon(icon, size: 14, color: theme.textTheme.bodyMedium?.color),
      ),
    );
  }
}
