import 'package:fpdart/fpdart.dart';
import '../../../core/exceptions/failure.dart';
import 'user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signInWithEmail(String email, String password);
  Future<Either<Failure, void>> signInWithGoogle();
  Future<Either<Failure, bool>> signUpWithEmail(String email, String password, String name);
  Future<Either<Failure, bool>> verifyOtp(String email, String token, String name);
  Future<Either<Failure, void>> signOut();
  Stream<User?> get authStateChanges;
  Future<Either<Failure, User?>> getCurrentUser();
  
  // Account Management
  Future<Either<Failure, void>> updateProfile({String? username, String? avatarUrl});
  Future<Either<Failure, void>> resetPassword(String email);
  Future<Either<Failure, void>> deleteAccount();
}
