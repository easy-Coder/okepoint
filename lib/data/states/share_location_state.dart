import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okepoint/data/models/location/shared_location.dart';
import 'package:okepoint/data/repositories/shared_location_respository.dart';

final sharedLocationStateProvider = StateNotifierProvider.family<SharedLocationState, SharedLocation?, String>((ref, sharedLocationId) {
  return SharedLocationState(
    ref: ref,
    sharedLocationId: sharedLocationId,
  );
});

class SharedLocationState extends StateNotifier<SharedLocation?> {
  final String sharedLocationId;
  final Ref ref;

  StreamSubscription? _sharedLocationSubscription;
  ValueNotifier<SharedLocation?> shareLocationNotifier = ValueNotifier<SharedLocation?>(null);

  SharedLocationRepository get _sharedLocationRepo => ref.read(sharedLocationProvider);

  SharedLocationState({required this.sharedLocationId, required this.ref}) : super(null) {
    _listenToSharedLocation();
  }

  void _listenToSharedLocation() {
    try {
      _cancelSharedLocationSubscription();
      print("sharedLocationId : $sharedLocationId");

      _sharedLocationSubscription = _sharedLocationRepo.sharedLocationStream(sharedLocationId).listen((document) {
        state = document.data();
        shareLocationNotifier.value = state;

        print("state : $state");
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _cancelSharedLocationSubscription() {
    _sharedLocationSubscription?.cancel();
    _sharedLocationSubscription = null;
  }
}
