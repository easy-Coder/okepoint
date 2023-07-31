import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okepoint/data/models/user.dart';
import 'package:okepoint/data/services/auth_service.dart';

import '../repositories/user_repository.dart';
import '../services/map_service.dart';

final userStateProvider = StateNotifierProvider<UserState, User?>((ref) {
  return UserState(ref: ref);
});

class UserState extends StateNotifier<User?> with WidgetsBindingObserver {
  final Ref ref;

  bool _launchSetUp = true;

  AuthService get _authService => ref.read(authServiceProvider);
  UserRepository get _userRepository => ref.read(userRepositoryProvider);
  MapService get _mapService => ref.read(mapServiceProvider);

  ValueNotifier<User?> get currentUser => _userRepository.currentUserNotifier;

  set updateUser(User? user) => state = user;

  UserState({required this.ref}) : super(null) {
    WidgetsBinding.instance.addObserver(this);

    _authService.userAuthStream(userOnChanged: (firebaseUser) async {
      debugPrint("USER IS AUTHENTICATED: ${firebaseUser?.email != null} EMAIL: ${firebaseUser?.email} ");

      if (firebaseUser == null) {
        _onUserEvent(null);
        _clearUserCachedData();
        return;
      }

      await _fetchUserDocuments(firebaseUser.uid);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _fetchUserDocuments(String uid) async {
    await _userRepository.getCurrentUser(uid);
    updateUser = _userRepository.currentUserNotifier.value;

    if (currentUser.value != null && _launchSetUp) {
      _launchSetUp = false;
      _appStartUserAvailable(currentUser.value!);
    }

    _onUserEvent(currentUser.value);
  }

  Future<void> _onUserEvent(User? user) async {
    // cancel listeners
    _userRepository.clearUserSubscription();

    if (user != null) {
      _userRepository.listenToCurrentUser(user.uid, onUserUpdate: (user) {
        updateUser = user;
      });
    }

    _mapService.getUserCurrentPosition();
  }

  Future<void> _appStartUserAvailable(User user) async {}

  Future<void> _clearUserCachedData() async {}

  Future<void> logout() async {
    final result = await _authService.signOut();
    if (result) {
      _userRepository.currentUserNotifier.value = null;
      updateUser = null;
    }
  }
}
