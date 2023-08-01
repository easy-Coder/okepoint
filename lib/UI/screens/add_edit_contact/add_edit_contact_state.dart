import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okepoint/data/models/user/contact.dart';
import 'package:okepoint/utils/useful_methods.dart';

final selectContactProvider = Provider.autoDispose<String?>((ref) {
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

  Future<void> getContact() async {}

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
    info["type"] = contactTypeController.text.trim();
    info["note"] = noteController.text.trim();

    final newContact = Contact(
      id: "",
      uid: '',
      info: info,
      emergencyTypes: [],
      createdAt: utcTimeNow,
      updatedAt: utcTimeNow,
    );

    debugPrint(newContact.toString());
  }
}
