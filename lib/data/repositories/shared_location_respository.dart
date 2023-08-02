import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okepoint/data/models/location/shared_location.dart';

import '../../constants/db_collection_paths.dart';

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
}
