import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okepoint/data/models/user/contact.dart';
import 'package:okepoint/utils/useful_methods.dart';

import '../../../data/states/contacts_state.dart';

final selectContactProvider = StateProvider.autoDispose<String?>((ref) {
  return null;
});

final addEditContactStateProvider = ChangeNotifierProvider.autoDispose.family<AddEditContactState, String?>((ref, contactId) {
  return AddEditContactState(ref: ref, contactId: contactId);
});

class AddEditContactState extends ChangeNotifier {
  final Ref ref;
  final String? contactId;

  late GlobalKey<FormState> formKey;
  late TextEditingController nameController, phoneController, emailController, contactTypeController, noteController;

  Contact? contact;

  bool get isEdittingContact => contact != null;

  AddEditContactState({required this.ref, this.contactId}) {
    formKey = GlobalKey<FormState>();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    contactTypeController = TextEditingController();
    noteController = TextEditingController();

    getContact();
  }

  Future<void> getContact() async {
    try {
      final contacts = ref.watch(contactsStateProvider);
      contact = contacts.firstWhere((element) => element.id == contactId);
      if (contact == null) return;
      nameController.text = contact!.displayName;
      phoneController.text = contact!.phone;

      notifyListeners();
    } catch (_) {}
  }

  void selectContactType(String value) {
    contactTypeController.text = value;
    notifyListeners();
  }

  Future<void> saveContact(Function(Contact? contact) onCompleted) async {
    if (!formKey.currentState!.validate()) return;
    Map<String, dynamic> info = {};

    info["name"] = nameController.text.trim();
    info["phone"] = phoneController.text.trim();
    info["email"] = emailController.text.trim();
    info["type"] = contactTypeController.text.trim().toLowerCase();
    info["note"] = noteController.text.trim();

    final newContact = Contact(
      id: Contact.generatedId,
      uid: '',
      info: info,
      emergencyTypes: <String>[],
      createdAt: utcTimeNow,
      updatedAt: utcTimeNow,
    );

    debugPrint(newContact.toString());
    onCompleted(newContact);
  }
}
