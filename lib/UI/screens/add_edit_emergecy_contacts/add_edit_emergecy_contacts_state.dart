import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okepoint/data/models/emergency.dart';
import 'package:okepoint/data/models/user/contact.dart';

import '../../../data/repositories/user_repository.dart';
import '../../../data/states/contacts_state.dart';

final addEditEmergencyContactsProvider = StateNotifierProvider.autoDispose.family<AddEditEmergencyContactsState, List<Contact>, Emergency>((ref, emergency) {
  return AddEditEmergencyContactsState(ref: ref, emergency: emergency);
});

class AddEditEmergencyContactsState extends StateNotifier<List<Contact>> {
  final Ref ref;
  final Emergency emergency;

  UserRepository get _userRepository => ref.read(userRepositoryProvider);

  AddEditEmergencyContactsState({required this.ref, required this.emergency}) : super([]) {
    final contacts = ref.watch(contactsStateProvider);
    state = contacts.where((element) => element.emergencyTypes.contains(emergency.type)).toList();
  }

  Future<void> addContactToEmergency(Contact contact) async {
    contact = contact.copyWith(emergencyTypes: [
      emergency.type,
      ...contact.emergencyTypes,
    ]);

    state = [contact, ...state];
    await _userRepository.createContact(_userRepository.currentUserNotifier.value!.uid, contact);
  }

  Future<void> removeContactFromEmergency(Contact contact) async {
    final newContacts = state.where((element) => contact.id != element.id);
    state = newContacts.toList();
  }
}
