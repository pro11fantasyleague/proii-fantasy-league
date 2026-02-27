import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/user.dart';
import '../../../core/providers/repository_providers.dart'; // Import central provider

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<User?> build() async {
    final repository = ref.watch(authRepositoryProvider);
    final userOrFailure = await repository.getCurrentUser();
    return userOrFailure.fold((l) => null, (r) => r);
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.signInWithEmail(email, password);
    state = result.fold(
      (l) => AsyncError(l.message, StackTrace.current),
      (r) => AsyncData(r),
    );
  }
  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.signInWithGoogle();
    state = result.fold(
      (l) => AsyncError(l.message, StackTrace.current),
      (r) => const AsyncData(null), // Google OAuth usually handled via deep links redirecting to app
    );
  }
  
  Future<bool> signUp(String email, String password, String name) async {
    print('Starting signup for $email');
    state = const AsyncLoading();
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.signUpWithEmail(email, password, name);
    return result.fold(
      (l) {
        print('SignUp Failed in Controller: ${l.message}');
        state = AsyncError(l.message, StackTrace.current);
        return false;
      },
      (r) {
        print('SignUp Success in Controller!');
        state = const AsyncData(null); // Keep empty user state, User not logged in yet.
        return true;
      },
    );
  }

  Future<bool> verifyCode(String email, String token, String name) async {
    state = const AsyncLoading();
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.verifyOtp(email, token, name);
    
    // Refresh user state if success
    if (result.isRight()) {
       ref.invalidateSelf(); 
       return true;
    } else {
       state = AsyncError(result.getLeft().toNullable()?.message ?? 'Error', StackTrace.current);
       return false;
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.signOut();
    state = result.fold(
      (l) => AsyncError(l.message, StackTrace.current),
      (r) => const AsyncData(null),
    );
  }

  Future<void> updateProfile({String? username, String? avatarUrl}) async {
    // state = const AsyncLoading(); // Optional: Don't block whole app, just let UI handle it? 
    // Usually better to keep state data but maybe set a "loading" flag or return Future.
    // Here we return Future so UI calls `await`.
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.updateProfile(username: username, avatarUrl: avatarUrl);
    
    // Refresh user state
    if (result.isRight()) {
       ref.invalidateSelf(); 
    } else {
       throw Exception(result.getLeft().toNullable()?.message);
    }
  }

  Future<void> deleteAccount() async {
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.deleteAccount();
    result.fold(
      (l) => throw Exception(l.message),
      (r) {
        state = const AsyncData(null); // Signed out
      },
    );
  }
  
  Future<void> resetPassword(String email) async {
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.resetPassword(email);
    result.fold(
      (l) => throw Exception(l.message),
      (r) => null,
    );
  }
}
