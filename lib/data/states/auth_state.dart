import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/user_repository.dart';

final authStateProvider = ChangeNotifierProvider<AuthState>((ref) {
  return AuthState(ref);
});

class AuthState extends ChangeNotifier {
  final Ref ref;

  bool isLoading = false;

  UserRepository get _userRepository => ref.read(userRepositoryProvider);

  AuthState(this.ref);

  Future<void> signInWithApple() async {
    if (isLoading == false) {
      isLoading = true;
      notifyListeners();

      await _userRepository.createAccountOrSigninWithApple();

      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    if (isLoading == false) {
      isLoading = true;
      notifyListeners();

      await _userRepository.createAccountOrSigninWithGoogle();

      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> handleSignOut() async {}
}
