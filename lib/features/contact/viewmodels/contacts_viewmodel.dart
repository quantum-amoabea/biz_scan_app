import 'package:biz_scan_app/core/network/dio_client.dart';
import 'package:biz_scan_app/core/toast_message.dart';
import 'package:biz_scan_app/features/contact/domain/models/update_email.dart';
import 'package:biz_scan_app/features/contact/domain/models/update_phone.dart';
import 'package:biz_scan_app/features/contact/domain/models/update_socials.dart';
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

  bool isSavingContactDetails = false;

  int get scannedThisWeek {
    final cutoff = DateTime.now().subtract(const Duration(days: 7));

    return contacts.where((item) {
      final createdAt = DateTime.tryParse(item.createdAt ?? '');

      return createdAt != null && !createdAt.isBefore(cutoff);
    }).length;
  }

  Future<void> getAllContacts() async {
    isFetchingContacts = true;
    notifyListeners();

    try {
      final response = await _dioClient.get('api/v1/contacts');

      final items = Contacts.fromJson(response.data);

      contacts = items.items ?? [];

      notifyListeners();
    } catch (e) {
      debugPrint('Get contacts error: $e');
      showToast(message: e.toString());
    } finally {
      isFetchingContacts = false;
      notifyListeners();
    }
  }

  Future<Items> getContact(String contactId) async {
    try {
      final response = await _dioClient.get('api/v1/contacts/$contactId');

      return Items.fromJson(response.data);
    } catch (e) {
      showToast(message: e.toString());
      rethrow;
    }
  }

  Future<void> getFilteredContacts(String search) async {
    if (search.trim().isEmpty) {
      await getAllContacts();
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
    } catch (e) {
      debugPrint('Get filtered contacts error: $e');
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

      notifyListeners();
    } catch (e) {
      debugPrint('Get shared contacts error: $e');
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
    } catch (e) {
      debugPrint('Get filtered shared contacts error: $e');
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
    } catch (e) {
      debugPrint('Get industries error: $e');
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
        return null;
      }

      final response = await _dioClient.patch(
        'api/v1/contacts/$contactId',
        body,
      );

      final updatedItem = Items.fromJson(response);

      final index = contacts.indexWhere((contact) => contact.id == contactId);

      if (index != -1) {
        contacts[index] = updatedItem;
        notifyListeners();
      }

      return updatedItem;
    } catch (e) {
      debugPrint('Update personal details error: $e');
      showToast(message: e.toString());

      return null;
    }
  }

  Future<void> deletePhone(String contactId, String phoneId) async {
    try {
      await _dioClient.delete('api/v1/contacts/$contactId/phones/$phoneId');

      final contactIndex = contacts.indexWhere(
        (contact) => contact.id == contactId,
      );

      if (contactIndex != -1) {
        contacts[contactIndex].phones?.removeWhere(
          (phone) => phone.id == phoneId,
        );

        notifyListeners();
      }

      showToast(message: 'Phone number deleted successfully');
    } catch (e) {
      debugPrint('Delete phone error: $e');
      showToast(message: e.toString());
    }
  }

  Future<void> updatePhone(
    String contactId,
    String phoneId,
    UpdatePhone updatePhone,
  ) async {
    try {
      isSavingContactDetails = true;
      notifyListeners();

      final response = await _dioClient.patch(
        '/api/v1/contacts/$contactId/phones/$phoneId',
        updatePhone.toJson(),
      );

      final updatedPhone = Items.fromJson(response);

      final contactIndex = contacts.indexWhere(
        (contact) => contact.id == contactId,
      );

      if (contactIndex != -1) {
        final phones = contacts[contactIndex].phones;
        final updatedPhones = updatedPhone.phones;

        if (phones != null && updatedPhones != null) {
          final phoneIndex = phones.indexWhere((phone) => phone.id == phoneId);

          final updatedPhoneIndex = updatedPhones.indexWhere(
            (phone) => phone.id == phoneId,
          );

          if (phoneIndex != -1 && updatedPhoneIndex != -1) {
            phones[phoneIndex] = updatedPhones[updatedPhoneIndex];
          }
        }

        notifyListeners();
      }
    } catch (e, stackTrace) {
      debugPrint('Update phone error: $e');
      debugPrintStack(stackTrace: stackTrace);

      showToast(message: e.toString());
    } finally {
      isSavingContactDetails = false;
      notifyListeners();
    }
  }

  Future<void> addPhone(String contactId, UpdatePhone updatePhone) async {
    try {
      isSavingContactDetails = true;
      notifyListeners();

      final response = await _dioClient.post(
        '/api/v1/contacts/$contactId/phones',
        updatePhone.toJson(),
      );

      final contactDetails = Items.fromJson(response);

      final contactIndex = contacts.indexWhere(
        (contact) => contact.id == contactId,
      );

      if (contactIndex != -1) {
        contacts[contactIndex].phones ??= [];

        contacts[contactIndex].phones = contactDetails.phones;

        notifyListeners();
      }
    } catch (e, stackTrace) {
      debugPrint('Add phone error: $e');
      debugPrintStack(stackTrace: stackTrace);

      showToast(message: e.toString());
    } finally {
      isSavingContactDetails = false;
      notifyListeners();
    }
  }

  Future<void> addEmail(String contactId, UpdateEmail email) async {
    try {
      isSavingContactDetails = true;
      notifyListeners();

      final response = await _dioClient.post(
        'api/v1/contacts/$contactId/emails',
        email.toJson(),
      );

      final contactDetails = Items.fromJson(response);

      final contactIndex = contacts.indexWhere(
        (contact) => contact.id == contactId,
      );

      if (contactIndex != -1) {
        contacts[contactIndex].emails ??= [];

        contacts[contactIndex].emails = contactDetails.emails;

        notifyListeners();
      }
    } catch (e) {
      debugPrint('the error is $e');
      showToast(message: e.toString());
    } finally {
      isSavingContactDetails = false;
      notifyListeners();
    }
  }

  Future<void> deleteEmail(String contactId, String emailId) async {
    try {
      await _dioClient.delete('api/v1/contacts/$contactId/emails/$emailId');

      final contactIndex = contacts.indexWhere(
        (contact) => contact.id == contactId,
      );

      if (contactIndex != -1) {
        contacts[contactIndex].emails?.removeWhere(
          (email) => email.id == emailId,
        );

        notifyListeners();
      }

      showToast(message: 'Email deleted successfully');
    } catch (e) {
      debugPrint('Delete email error: $e');
      showToast(message: e.toString());
    }
  }

  Future<void> updateEmail(
    String contactId,
    String emailId,
    UpdateEmail updateEmail,
  ) async {
    try {
      isSavingContactDetails = true;
      notifyListeners();

      final response = await _dioClient.patch(
        '/api/v1/contacts/$contactId/emails/$emailId',
        updateEmail.toJson(),
      );

      final updatedEmails = Items.fromJson(response);

      final contactIndex = contacts.indexWhere(
        (contact) => contact.id == contactId,
      );

      if (contactIndex != -1) {
        final email = contacts[contactIndex].emails;
        final newEmails = updatedEmails.emails;

        if (email != null && newEmails != null) {
          final phoneIndex = email.indexWhere((e) => e.id == emailId);

          final updatedEmailIndex = newEmails.indexWhere(
            (email) => email.id == emailId,
          );

          if (phoneIndex != -1 && updatedEmailIndex != -1) {
            email[phoneIndex] = newEmails[updatedEmailIndex];
          }
        }

        notifyListeners();
      }
    } catch (e, stackTrace) {
      debugPrint('Update email error: $e');
      debugPrintStack(stackTrace: stackTrace);

      showToast(message: e.toString());
    } finally {
      isSavingContactDetails = false;
      notifyListeners();
    }
  }

    Future<void> addWebsite(String contactId, UpdateSocials socials) async {
    try {
      isSavingContactDetails = true;
      notifyListeners();

      final response = await _dioClient.post(
        'api/v1/contacts/$contactId/socials',
        socials.toJson(),
      );

      final contactDetails = Items.fromJson(response);

      final contactIndex = contacts.indexWhere(
        (contact) => contact.id == contactId,
      );

      if (contactIndex != -1) {
        contacts[contactIndex].socials ??= [];

        contacts[contactIndex].socials = contactDetails.socials;

        notifyListeners();
      }
    } catch (e) {
      debugPrint('the error is $e');
      showToast(message: e.toString());
    } finally {
      isSavingContactDetails = false;
      notifyListeners();
    }
  }

  Future<void> addAddress() async {}

  Future<void> updateAddress() async {}
}
