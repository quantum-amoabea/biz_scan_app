import 'package:biz_scan_app/core/network/dio_client.dart';
import 'package:biz_scan_app/core/toast_message.dart';
import 'package:flutter/cupertino.dart';

import '../models/contacts.dart';

class ContactsProvider extends ChangeNotifier {
  final DioClient _dioClient = DioClient();

  List<Items> contacts = [];
  List<Items> sharedContacts = [];

  bool isFetchingContacts = false;
  bool isFetchingSharedContacts = false;


  Future<void> getContacts() async {
    isFetchingContacts = true;
    notifyListeners();
    try {
      final response = await _dioClient.get('api/v1/contacts');

      final items = Contacts.fromJson(response.data);

      contacts = items.items ?? [];
      debugPrint('the contacts are $contacts');
      notifyListeners();
    } catch (e) {
      debugPrint('the error is $e');
      showToast(message: e.toString());
    } finally {
      isFetchingContacts = false;
      notifyListeners();
    }
  }

  Future<void> getSharedContacts() async {
    isFetchingSharedContacts = true;
    notifyListeners();
    try {
      final response = await _dioClient.get('api/v1/contacts/shared-with-me');

      final items = Contacts.fromJson(response.data);

      sharedContacts = items.items ?? [];
      debugPrint('the contacts are $sharedContacts');
      notifyListeners();
    } catch (e) {
      debugPrint('the error is $e');
      showToast(message: e.toString());
    } finally {
      isFetchingSharedContacts = false;
      notifyListeners();
    }
  }
}
