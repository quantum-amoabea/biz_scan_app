import 'package:biz_scan_app/core/network/dio_client.dart';
import 'package:biz_scan_app/core/toast_message.dart';
import 'package:flutter/cupertino.dart';

import '../models/contacts.dart';

class ContactsProvider extends ChangeNotifier {
  final DioClient _dioClient = DioClient();

  List<Items> contacts = [];
  List<Items> sharedContacts = [];
  List<Items> filterContacts = [];
  List<Items> filteredSharedContacts = [];

  bool isFetchingFilteredSharedContacts = false;
  bool isFetchingContacts = false;
  bool isFetchingSharedContacts = false;
  bool isFetchingFilteredContacts = false;

  int get scannedThisWeek {
    final cutoff = DateTime.now().subtract(const Duration(days: 7));

    return contacts.where((item) {
      final createdAt = DateTime.tryParse(item.createdAt ?? '');

      return createdAt != null && !createdAt.isBefore(cutoff);
    }).length;
  }

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

  Future<void> getFilteredContacts(String search) async {
    if (search.trim().isEmpty) {
      await getContacts();
      return;
    }

    isFetchingFilteredContacts = true;
    notifyListeners();

    try {
      final response = await _dioClient.get('api/v1/contacts', {
        'q': search.trim(),
      });

      final items = Contacts.fromJson(response.data);

      filterContacts = items.items ?? [];

      debugPrint('The filtered contacts are $filterContacts');
    } catch (e) {
      debugPrint('The error is $e');
      showToast(message: e.toString());
    } finally {
      isFetchingFilteredContacts = false;
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

  Future<void> getFilteredSharedContacts(String search) async {
    if (search.trim().isEmpty) {
      await getSharedContacts();
      return;
    }

    isFetchingFilteredSharedContacts = true;
    notifyListeners();

    try {
      final response = await _dioClient.get('api/v1/contacts/shared-with-me', {
        'q': search.trim(),
      });

      final items = Contacts.fromJson(response.data);

      filteredSharedContacts = items.items ?? [];

      debugPrint('The filtered shared contacts are $filteredSharedContacts');
    } catch (e) {
      debugPrint('The error is $e');
      showToast(message: e.toString());
    } finally {
      isFetchingFilteredSharedContacts = false;
      notifyListeners();
    }
  }
}
