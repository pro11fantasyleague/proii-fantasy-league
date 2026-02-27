import 'dart:async';
import 'package:fpdart/fpdart.dart';
import 'package:proii_fantasy_league/core/exceptions/failure.dart';
import 'package:proii_fantasy_league/features/auth/domain/auth_repository.dart';
import 'package:proii_fantasy_league/features/auth/domain/user.dart';

class MockAuthRepository implements AuthRepository {
  // Mock User
  final _mockUser = User(
    id: 'mock-user-id',
    email: 'mock@example.com',
    username: 'Mock User',
  );

  @override
  Stream<User?> get authStateChanges => Stream.value(_mockUser);

  @override
  Future<Either<Failure, User>> signInWithEmail(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulating network delay
    return right<Failure, User>(_mockUser);
  }

  @override
  Future<Either<Failure, bool>> signUpWithEmail(String email, String password, String name) async {
    await Future.delayed(const Duration(seconds: 1));
    return right(true);
  }

  @override
  Future<Either<Failure, void>> signInWithGoogle() async {
    await Future.delayed(const Duration(seconds: 1));
    return right(null);
  }

  @override
  Future<Either<Failure, bool>> verifyOtp(String email, String token, String name) async {
    await Future.delayed(const Duration(seconds: 1));
    return right(true);
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return right<Failure, void>(null); 
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    return right<Failure, User?>(_mockUser);
  }

  @override
  Future<Either<Failure, void>> updateProfile({String? username, String? avatarUrl}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return right<Failure, void>(null);
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return right<Failure, void>(null);
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return right<Failure, void>(null);
  }
}
