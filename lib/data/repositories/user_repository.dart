import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okepoint/data/models/user.dart';
import 'package:okepoint/utils/useful_methods.dart';

import '../../constants/db_collection_paths.dart';
import '../services/auth_service.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(ref);
});

class UserRepository {
  final Ref ref;
  final _userFirestore = FirebaseFirestore.instance.collection(DBCollectionPath.users);

  final ValueNotifier<User?> currentUserNotifier = ValueNotifier<User?>(null);

  StreamSubscription? _userSubscription;

  AuthService get _authService => ref.read(authServiceProvider);

  UserRepository(this.ref);

  Future<User?> getCurrentUser(String uid) async {
    try {
      final userSnapshot = await _userFirestore.doc(uid).get();
      if (userSnapshot.exists) {
        final user = User.fromMap(userSnapshot.data() as Map<String, dynamic>);
        currentUserNotifier.value = user;
        return user;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  Future<void> listenToCurrentUser(String uid, {Function(User newUser)? onUserUpdate}) async {
    try {
      final userSnapshot = _userFirestore.doc(uid).snapshots();

      _userSubscription = userSnapshot.listen((docSnap) async {
        if (docSnap.exists) {
          Map<String, dynamic> data = docSnap.data() as Map<String, dynamic>;
          final User user = User.fromMap(data);
          currentUserNotifier.value = user;

          if (onUserUpdate != null) onUserUpdate(currentUserNotifier.value!);
        }
      });
    } catch (_) {}
  }

  Future<User?> createAccountOrSigninWithApple() async {
    try {
      final userCredential = await _authService.signInWithApple();
      if (userCredential != null) {
        final firebaseUser = userCredential.user;
        final user = await getCurrentUser(firebaseUser!.uid);

        if (user != null) return user;

        // user not exist
        await _userFirestore.doc(firebaseUser.uid).set({
          'uid': firebaseUser.uid,
          'email': firebaseUser.email,
          'firstName': "",
          'lastName': "",
          'phone': "",
          'profileImageUrl': firebaseUser.photoURL ?? "",
          'verified': true,
          'active': true,
          'homePreferences': {},
          'settings': {},
          'createdAt': utcTimeNow,
          'updatedAt': utcTimeNow,
        });

        final newUser = await getCurrentUser(firebaseUser.uid);
        return newUser;
      }
    } catch (_) {}
    return null;
  }

  Future<User?> createAccountOrSigninWithGoogle() async {
    try {
      final userCredential = await _authService.signInWithGoogle();
      if (userCredential != null) {
        final firebaseUser = userCredential.user;
        final user = await getCurrentUser(firebaseUser!.uid);

        if (user != null) return user;

        // user not exist
        await _userFirestore.doc(firebaseUser.uid).set({
          'uid': firebaseUser.uid,
          'email': firebaseUser.email,
          'firstName': "",
          'lastName': "",
          'phone': "",
          'profileImageUrl': firebaseUser.photoURL ?? "",
          'verified': true,
          'active': true,
          'homePreferences': {},
          'settings': {},
          'createdAt': utcTimeNow,
          'updatedAt': utcTimeNow,
        });

        final newUser = await getCurrentUser(firebaseUser.uid);
        return newUser;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  void clearUserSubscription() {
    _userSubscription?.cancel();
    _userSubscription = null;
  }
}
