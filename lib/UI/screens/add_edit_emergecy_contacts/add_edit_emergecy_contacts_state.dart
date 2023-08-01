import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okepoint/data/models/emergency.dart';
import 'package:okepoint/data/models/user/contact.dart';

final addEditEmergencyContactsProvider = StateNotifierProvider.autoDispose.family<AddEditEmergencyContactsState, List<Contact>, Emergency>((ref, emergency) {
  return AddEditEmergencyContactsState(ref: ref, emergency: emergency);
});

class AddEditEmergencyContactsState extends StateNotifier<List<Contact>> {
  final Ref ref;
  final Emergency emergency;

  AddEditEmergencyContactsState({required this.ref, required this.emergency}) : super([]);

  Future<void> addContactToEmergency(Contact contact) async {
    state = [contact, ...state];
  }

  Future<void> removeContactFromEmergency(Contact contact) async {
    final newContacts = state.where((element) => contact.id != element.id);
    state = newContacts.toList();
  }
}
