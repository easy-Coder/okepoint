import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okepoint/data/models/user/contact.dart';

import '../repositories/user_repository.dart';

final contactsStateProvider = StateNotifierProvider<ContactsState, List<Contact>>((ref) {
  return ContactsState(ref: ref);
});

class ContactsState extends StateNotifier<List<Contact>> {
  final Ref ref;

  UserRepository get _userRepository => ref.read(userRepositoryProvider);

  ContactsState({required this.ref}) : super([]) {
    _userRepository.userContactsNotifier.addListener(_listenToContacts);
  }

  @override
  void dispose() {
    _userRepository.userContactsNotifier.removeListener(_listenToContacts);
    super.dispose();
  }

  void _listenToContacts() {
    state = _userRepository.userContactsNotifier.value;

    print("CONTACT LENGHT ${state.length}");
  }
}
