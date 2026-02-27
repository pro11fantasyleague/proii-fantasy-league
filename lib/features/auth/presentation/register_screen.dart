import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import 'auth_controller.dart';
import 'login_screen.dart'; // Pour récupérer GridPainter

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _acceptTerms = false;
  bool _obscurePass = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final pass = _passwordController.text;
    final confirm = _confirmController.text;

    if (name.isEmpty || email.isEmpty || pass.isEmpty || confirm.isEmpty) {
      _showError('Tous les champs sont obligatoires.');
      return;
    }

    if (pass != confirm) {
      _showError('Les mots de passe ne correspondent pas.');
      return;
    }

    if (!_acceptTerms) {
      _showError('Vous devez accepter les CGU.');
      return;
    }

    // Le backend call renvoie true si succès, on ne navigue pas automatiquement 
    // car on veut rediriger vers l'OTP view manuellement
    final success = await ref.read(authControllerProvider.notifier).signUp(email, pass, name);
    print('RegisterScreen: signUp success? $success');
    
    if (success && mounted) {
      // Passer les parametres à la page OTP
      context.push('/verify-code?email=$email&name=$name');
    } else if (!success && mounted) {
      _showError('Échec de l\'inscription de notre côté. Veuillez réessayer.');
    }
  }

  void _handleGoogleRegister() {
    if (!_acceptTerms) {
      _showError('Vous devez accepter les CGU avant de continuer.');
      return;
    }
    ref.read(authControllerProvider.notifier).signInWithGoogle();
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text('ATTENTION', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.error)),
        content: Text(message, style: TextStyle(color: Theme.of(context).textTheme.displayLarge?.color)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Compris', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: GridPainter()),
          ),
          
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    children: [
                      // Mini Logo
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          border: Border.all(color: AppColors.primary, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.5),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                          image: const DecorationImage(
                            image: AssetImage('assets/images/logo.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Register Card HUD
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              blurRadius: 20,
                              spreadRadius: -5,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('NOM DU MANAGER', style: theme.textTheme.labelLarge),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                hintText: 'Ex: TheSpecialOne',
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                            ),
                            const SizedBox(height: 16),

                            Text('EMAIL', style: theme.textTheme.labelLarge),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                hintText: 'manager@proii.com',
                                prefixIcon: Icon(Icons.mail_outline),
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            Text('MOT DE PASSE', style: theme.textTheme.labelLarge),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _passwordController,
                              obscureText: _obscurePass,
                              decoration: InputDecoration(
                                hintText: '••••••••',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscurePass ? Icons.visibility_off : Icons.visibility),
                                  onPressed: () => setState(() => _obscurePass = !_obscurePass),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            Text('CONFIRMATION', style: theme.textTheme.labelLarge),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _confirmController,
                              obscureText: _obscureConfirm,
                              decoration: InputDecoration(
                                hintText: '••••••••',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility),
                                  onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Checkbox(
                                  value: _acceptTerms,
                                  onChanged: (val) => setState(() => _acceptTerms = val ?? false),
                                  activeColor: AppColors.primary,
                                ),
                                Text('J\'accepte les ', style: theme.textTheme.bodyMedium),
                                Text('CGU', style: theme.textTheme.labelLarge?.copyWith(fontSize: 14)),
                              ],
                            ),

                            const SizedBox(height: 24),
                            
                            if (state.isLoading)
                              const Center(child: CircularProgressIndicator())
                            else
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  gradient: const LinearGradient(
                                    colors: [AppColors.primaryVariant, AppColors.primary],
                                  ),
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    foregroundColor: Theme.of(context).scaffoldBackgroundColor,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  onPressed: _handleRegister,
                                  child: Text('REJOINDRE PRO11', style: theme.textTheme.labelLarge?.copyWith(color: Theme.of(context).scaffoldBackgroundColor)),
                                ),
                              ),
                              
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Divider(color: Colors.white24, thickness: 1),
                            ),

                            // Google Button
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: _acceptTerms ? Colors.white : Colors.white38,
                                  side: BorderSide(
                                    color: _acceptTerms ? Colors.white.withValues(alpha: 0.1) : Colors.white10, 
                                    width: 1.5
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: _acceptTerms ? _handleGoogleRegister : null,
                                icon: const Icon(Icons.g_mobiledata, size: 28),
                                label: Text("S'inscrire avec Google", style: TextStyle(fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      TextButton(
                        onPressed: () => context.pop(),
                        child: RichText(
                          text: TextSpan(
                            text: 'Vous avez déjà un compte ? ',
                            style: theme.textTheme.bodyMedium,
                            children: [
                              TextSpan(
                                text: 'SE CONNECTER',
                                style: theme.textTheme.labelLarge?.copyWith(color: AppColors.secondary),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
