import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../../core/exceptions/failure.dart';
import '../domain/auth_repository.dart';
import '../domain/user.dart';

class SupabaseAuthRepository implements AuthRepository {
  final supabase.SupabaseClient _supabase;

  SupabaseAuthRepository(this._supabase);

  @override
  Future<Either<Failure, User>> signInWithEmail(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(email: email, password: password);
      if (response.user == null) {
        return left(const AuthFailure('User not found'));
      }
      return right(_mapSupabaseUserToDomain(response.user!));
    } on supabase.AuthException catch (e) {
      return left(AuthFailure(e.message));
    } catch (e) {
      return left(AuthFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> signInWithGoogle() async {
    try {
      await _supabase.auth.signInWithOAuth(
        supabase.OAuthProvider.google,
        redirectTo: 'proii-fantasyleague://login-callback',
      );
      return right(null);
    } catch (e) {
      return left(AuthFailure('Failed to sign in with Google: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> signUpWithEmail(String email, String password, String name) async {
    try {
       // On ne veut pas connect directement
      await _supabase.auth.signUp(
        email: email, 
        password: password,
      );
      return right(true); // Return Success status boolean
    } on supabase.AuthException catch (e) {
      return left(AuthFailure(e.message));
    } catch (e) {
      return left(AuthFailure('Unexpected erreur: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyOtp(String email, String token, String managerName) async {
    try {
      final response = await _supabase.auth.verifyOTP(
        type: supabase.OtpType.signup,
        email: email,
        token: token,
      );

      if (response.session != null) {
        // Authentifié avec succès ! 
        // Sauvegardons maintenant le nom du manager dans public.profiles.
        final userId = response.session!.user.id;
        
        await _supabase.from('profiles').update({'manager_name': managerName}).eq('id', userId);
        return right(true);
      }
      return left(const AuthFailure('Validation échouée'));
    } on supabase.AuthException catch (e) {
      return left(AuthFailure(e.message));
    } catch (e) {
      return left(AuthFailure('OTP verification failed: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _supabase.auth.signOut();
      return right(null);
    } catch (e) {
      return left(AuthFailure('Sign out failed: $e'));
    }
  }

  @override
  Stream<User?> get authStateChanges {
    return _supabase.auth.onAuthStateChange.map((event) {
      final session = event.session;
      if (session?.user == null) return null;
      return _mapSupabaseUserToDomain(session!.user);
    });
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return right(null);
      return right(_mapSupabaseUserToDomain(user));
    } catch (e) {
      return left(AuthFailure('Failed to get current user: $e'));
    }
  }

  User _mapSupabaseUserToDomain(supabase.User user) {
    return User(
      id: user.id,
      email: user.email ?? '',
      username: user.userMetadata?['username'] as String?,
      avatarUrl: user.userMetadata?['avatar_url'] as String?,
    );
  }

  @override
  Future<Either<Failure, void>> updateProfile({String? username, String? avatarUrl}) async {
    try {
      final updates = <String, dynamic>{};
      if (username != null) updates['username'] = username;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
      
      final userId = _supabase.auth.currentUser!.id;

      // 1. Update Auth Metadata (Private)
      await _supabase.auth.updateUser(
        supabase.UserAttributes(data: updates),
      );

      // 2. Update Public Profiles Table
      await _supabase.from('profiles').update(updates).eq('id', userId);

      return right(null);
    } catch (e) {
      return left(AuthFailure('Failed to update profile: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    try {
       await _supabase.auth.resetPasswordForEmail(email);
       return right(null);
    } catch (e) {
      return left(AuthFailure('Failed to send reset email: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      await _supabase.rpc('delete_user_account');
      await _supabase.auth.signOut(); // Ensure client cleanup
      return right(null);
    } catch (e) {
      if (e is supabase.AuthException) return left(AuthFailure(e.message));
      return left(AuthFailure('Failed to delete account: $e'));
    }
  }
}
