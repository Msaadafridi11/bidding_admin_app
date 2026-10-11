import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../core/constants/app_constants.dart';
import '../models/user_model.dart';

enum AuthResultStatus {
  success,
  pendingApproval,
  notFound,
  error,
}

class AuthResult {
  final AuthResultStatus status;
  final String? message;
  final UserModel? user;

  AuthResult({
    required this.status,
    this.message,
    this.user,
  });
}

class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  /// Signs in admin user with email and password, checking admin role in Firestore.
  Future<AuthResult> loginAdmin({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final uid = userCredential.user?.uid;
      if (uid == null) {
        return AuthResult(
          status: AuthResultStatus.error,
          message: 'Failed to retrieve user ID',
        );
      }

      // Check role in Firestore
      final doc = await _firestore
          .collection(AppConstants.firestoreUsersCollection)
          .doc(uid)
          .get();

      if (doc.exists && doc.data() != null) {
        final userModel = UserModel.fromMap(doc.data()!, docId: uid);

        if (userModel.isRole == true) {
          return AuthResult(
            status: AuthResultStatus.success,
            user: userModel,
          );
        } else {
          // Account pending admin approval
          await _auth.signOut();
          return AuthResult(
            status: AuthResultStatus.pendingApproval,
            message:
                "Aapka account admin ki approval ke liye pending hai. Jab tak approval nahi milti aap login nahi kar sakte.",
          );
        }
      } else {
        await _auth.signOut();
        return AuthResult(
          status: AuthResultStatus.notFound,
          message: "Aapka record database mein nahi mila.",
        );
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('AuthService.loginAdmin FirebaseAuthException: ${e.message}');
      return AuthResult(
        status: AuthResultStatus.error,
        message: e.message ?? 'Login Failed',
      );
    } catch (e) {
      debugPrint('AuthService.loginAdmin error: $e');
      return AuthResult(
        status: AuthResultStatus.error,
        message: 'Error: $e',
      );
    }
  }

  /// Signs out current user
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
