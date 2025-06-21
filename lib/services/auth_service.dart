import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:minha_van/i18n/auth_i18n.dart';

ValueNotifier<AuthService> authService = ValueNotifier(AuthService());

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<AuthResult> signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult.success(userCredential.user);
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_getErrorMessage(e));
    } catch (e) {
      return AuthResult.error(AuthI18n.unknownError);
    }
  }

  // Create user with email and password
  Future<AuthResult> createUserWithEmailAndPassword(
    String email, 
    String password, 
    String displayName
  ) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update display name
      await userCredential.user?.updateDisplayName(displayName);
      
      return AuthResult.success(userCredential.user);
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_getErrorMessage(e));
    } catch (e) {
      return AuthResult.error(AuthI18n.unknownError);
    }
  }

  // Send password reset email
  Future<AuthResult> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return AuthResult.success(null, message: AuthI18n.passwordResetSent);
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_getErrorMessage(e));
    } catch (e) {
      return AuthResult.error(AuthI18n.unknownError);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Update user display name
  Future<AuthResult> updateDisplayName(String displayName) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(displayName);
        // Notify listeners that the auth service has changed
        authService.notifyListeners();
        return AuthResult.success(user, message: 'Nome atualizado com sucesso!');
      } else {
        return AuthResult.error('Usuário não encontrado');
      }
    } catch (e) {
      return AuthResult.error('Erro ao atualizar nome: $e');
    }
  }

  // Get error message from Firebase Auth Exception
  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return AuthI18n.weakPassword;
      case 'email-already-in-use':
        return AuthI18n.emailAlreadyInUse;
      case 'user-not-found':
        return AuthI18n.userNotFound;
      case 'wrong-password':
        return AuthI18n.wrongPassword;
      case 'too-many-requests':
        return AuthI18n.tooManyRequests;
      case 'network-request-failed':
        return AuthI18n.networkError;
      default:
        return e.message ?? AuthI18n.unknownError;
    }
  }
}

// Result class for authentication operations
class AuthResult {
  final bool isSuccess;
  final User? user;
  final String? errorMessage;
  final String? successMessage;

  AuthResult._({
    required this.isSuccess,
    this.user,
    this.errorMessage,
    this.successMessage,
  });

  factory AuthResult.success(User? user, {String? message}) {
    return AuthResult._(
      isSuccess: true,
      user: user,
      successMessage: message,
    );
  }

  factory AuthResult.error(String message) {
    return AuthResult._(
      isSuccess: false,
      errorMessage: message,
    );
  }
} 