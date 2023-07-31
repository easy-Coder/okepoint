import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/user_repository.dart';

final authStateProvider = ChangeNotifierProvider<AuthState>((ref) {
  return AuthState(ref);
});

class AuthState extends ChangeNotifier {
  final Ref ref;

  bool isAppleSiginIn = false, isGoogleSiginIn = false;

  UserRepository get _userRepository => ref.read(userRepositoryProvider);

  AuthState(this.ref);

  Future<void> signInWithApple() async {
    if (isAppleSiginIn == false) {
      isAppleSiginIn = true;
      notifyListeners();

      await _userRepository.createAccountOrSigninWithApple();

      isAppleSiginIn = false;
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    if (isGoogleSiginIn == false) {
      isGoogleSiginIn = true;
      notifyListeners();

      await _userRepository.createAccountOrSigninWithGoogle();

      isGoogleSiginIn = false;
      notifyListeners();
    }
  }
}
