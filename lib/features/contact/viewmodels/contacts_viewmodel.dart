import 'package:biz_scan_app/core/network/dio_client.dart';
import 'package:biz_scan_app/core/toast_message.dart';
import 'package:flutter/cupertino.dart';

import '../domain/models/contacts.dart';
import '../domain/models/industry.dart';

class ContactsViewModel extends ChangeNotifier {
  final DioClient _dioClient = DioClient();

  List<Items> contacts = [];
  List<Items> sharedContacts = [];
  List<Items> filterContacts = [];
  List<Items> filteredSharedContacts = [];

  bool isFetchingFilteredSharedContacts = false;
  bool isFetchingContacts = false;
  bool isFetchingSharedContacts = false;
  bool isFetchingFilteredContacts = false;
  bool isFetchingIndustries = false;

  List<Industry> industries = [];

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


  Future<void> getIndustries() async {
    if (industries.isNotEmpty) return;

    isFetchingIndustries = true;
    notifyListeners();

    try {
      final response = await _dioClient.get('api/v1/industries');

      final List<dynamic> dataList = response.data;

      industries = dataList
          .map((item) => Industry.fromJson(item as Map<String, dynamic>))
          .toList();

      debugPrint('The industries are ${industries.length}');
    } catch (e) {
      debugPrint('The error fetching industries is $e');
      showToast(message: 'Failed to load industries');
    } finally {
      isFetchingIndustries = false;
      notifyListeners();
    }
  }


  Future<Items?> updatePersonalDetails(
    String contactId, {
    required String fullName,
    required String jobTitle,
    required String company,
    required String industry,
  }) async {
    try {
      final body = <String, dynamic>{};

      if (fullName.isNotEmpty) {
        body['full_name'] = fullName;
      }
      if (jobTitle.isNotEmpty) {
        body['job_title'] = jobTitle;
      }
      if (company.isNotEmpty) {
        body['company'] = company;
      }
      if (industry.isNotEmpty) {
        body['industry_code'] = industry;
      }

      if (body.isEmpty) {
        debugPrint('No fields to update');
        return null;
      }

      final response = await _dioClient.patch('api/v1/contacts/$contactId', body);

      final updatedItem = Items.fromJson(response);

      final index = contacts.indexWhere((c) => c.id == contactId);
      if (index != -1) {
        contacts[index] = updatedItem;
        notifyListeners();
      }

      debugPrint('Personal details updated successfully');
      return updatedItem;
    } catch (e) {
      debugPrint('the error is $e');
      showToast(message: e.toString());
      return null;
    }
  }
}
