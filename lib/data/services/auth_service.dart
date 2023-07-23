import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

enum SocialAuthProvider { apple, google }

abstract class SocialAuthService {
  final googleIn = GoogleSignIn();
  Future<UserCredential?> signInWithApple();
  Future<UserCredential?> signInWithGoogle();
}

class AuthService extends SocialAuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? _firebaseUser;

  StreamSubscription<User?>? _authSubscription;

  SocialAuthProvider get authProvider {
    final provider = firebaseAuth.currentUser?.providerData[0].providerId;

    switch (provider) {
      case "apple":
        return SocialAuthProvider.apple;
      default:
        return SocialAuthProvider.google;
    }
  }

  User? get currentFirebaseUser => FirebaseAuth.instance.currentUser;

  Stream<User?> _authStateChanges() => firebaseAuth.authStateChanges();

  void userAuthStream({required Function(User? user) userOnChanged}) {
    _authSubscription?.cancel();
    _authSubscription = null;

    _authSubscription = _authStateChanges().listen((event) async {
      bool useCallback = (_firebaseUser != null && event == null) || (_firebaseUser == null && event != null);
      _firebaseUser = event;

      if (useCallback) userOnChanged(event);
    });
  }

  Future<String?> reloadFirebaseUser() async {
    await FirebaseAuth.instance.currentUser?.reload();
    return currentFirebaseUser?.uid;
  }

  @override
  Future<UserCredential?> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      return userCredential;
    } on FirebaseException catch (_) {}
    return null;
  }

  @override
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleIn.signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseException catch (_) {}

    return null;
  }

  Future<bool> signOut() async {
    try {
      await firebaseAuth.signOut();
      return true;
    } on FirebaseAuthException catch (_) {}

    return false;
  }
}
