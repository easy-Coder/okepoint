import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okepoint/data/models/emergency.dart';
import 'package:okepoint/data/models/location/point.dart';
import 'package:okepoint/data/models/location/shared_location.dart';
import 'package:okepoint/data/models/user/user.dart';

import '../../constants/db_collection_paths.dart';
import '../../utils/useful_methods.dart';

final sharedLocationProvider = Provider<SharedLocationRepository>((ref) {
  return SharedLocationRepository(ref: ref);
});

class SharedLocationRepository {
  final Ref ref;
  final _sharedLocationFirestore = FirebaseFirestore.instance.collection(DBCollectionPath.sharedLocations);

  SharedLocationRepository({required this.ref});

  Stream<DocumentSnapshot<SharedLocation>> sharedLocationStream(String id) {
    return _sharedLocationFirestore
        .doc(id)
        .withConverter(fromFirestore: (data, options) => SharedLocation.fromMap(data.data() as Map<String, dynamic>), toFirestore: (data, options) => data.toMap())
        .snapshots();
  }

  Future<bool> shareLocation(User user, {required LocationPoint location, required Emergency emergency}) async {
    try {
      return FirebaseFirestore.instance.runTransaction((ts) async {
        try {
          final locationSnapshot = await ts.get(_sharedLocationFirestore.doc(user.currentSharedLocationId));

          if (locationSnapshot.exists) {
            /// update location
            ts.update(_sharedLocationFirestore.doc(user.currentSharedLocationId), {
              "updatedAt": utcTimeNow,
              "lastLocation": location.toMap(),
            });

            final locationPointSubCollectionDocRef = _sharedLocationFirestore.doc(user.currentSharedLocationId).collection(DBCollectionPath.locationPointsSubcollection).doc(location.id);
            ts.set(locationPointSubCollectionDocRef, location.toMap());

            return true;
          } else {
            // create new location
            final newSharedLocation = SharedLocation(
              id: SharedLocation.generatedId,
              createdBy: user.miniUserData,
              startLocation: location,
              lastLocation: location,
              emergencyType: emergency.type,
              duration: timeStampNow.add(const Duration(hours: 48)).millisecondsSinceEpoch,
              createdAt: utcTimeNow,
              updatedAt: utcTimeNow,
            );

            ts.set(_sharedLocationFirestore.doc(newSharedLocation.id), newSharedLocation.toMap());
            ts.update(FirebaseFirestore.instance.collection(DBCollectionPath.users).doc(user.uid), {
              "currentSharedLocation": {
                "id": newSharedLocation.id,
                "emergencyType": newSharedLocation.emergencyType,
                "createdAt": newSharedLocation.createdAt,
              },
              "homePreferences.enabledLocation": true,
            });
          }
          return true;
        } catch (e) {
          debugPrint(e.toString());
        }

        return false;
      });
    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
  }
}
