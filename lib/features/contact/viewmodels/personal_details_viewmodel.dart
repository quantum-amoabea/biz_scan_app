import 'package:flutter/cupertino.dart';

import '../domain/models/contacts_details.dart';
import '../domain/models/industry.dart';
import 'contacts_viewmodel.dart';

class PersonalDetailsViewModel extends ChangeNotifier {
  final ContactDetails contact;
  final ContactsViewModel contactsViewModel;

  bool isEditing = false;
  bool isSaving = false;

  late final TextEditingController nameController;
  late final TextEditingController jobTitleController;
  late final TextEditingController companyController;

  String _originalName = '';
  String _originalJobTitle = '';
  String _originalCompany = '';
  String _originalIndustry = '';

  List<Industry> industries = [];

  String? selectedIndustryCode;
  String get selectedIndustryDisplay => _getIndustryDisplay();
  String _getIndustryDisplay() {
    if (selectedIndustryCode == null || selectedIndustryCode!.isEmpty) {
      return contact.industry;
    }
    final industry = industries.firstWhere(
      (ind) => ind.code == selectedIndustryCode,
      orElse: () => Industry(code: selectedIndustryCode!, name: '', fullName: ''),
    );
    return industry.fullName.isNotEmpty ? industry.fullName : industry.name;
  }

  String? get nameError => _nameError;
  String? _nameError;

  PersonalDetailsViewModel({
    required this.contact,
    required this.contactsViewModel,
  }) {
    _originalName = contact.fullName;
    _originalJobTitle = contact.jobTitle;
    _originalCompany = contact.company;
    _originalIndustry = contact.industry;

    nameController = TextEditingController(text: contact.fullName);
    jobTitleController = TextEditingController(text: contact.jobTitle);
    companyController = TextEditingController(text: contact.company);
  }

  void setIndustries(List<Industry> fetchedIndustries) {
    industries = fetchedIndustries;

    if (selectedIndustryCode == null || selectedIndustryCode!.isEmpty) {
      final matching = industries.firstWhere(
        (ind) => ind.fullName == contact.industry || ind.name == contact.industry,
        orElse: () => Industry(code: '', name: '', fullName: ''),
      );
      selectedIndustryCode = matching.code.isEmpty ? null : matching.code;
    }

    notifyListeners();
  }

  void onIndustryChanged(String? code) {
    selectedIndustryCode = code;
    notifyListeners();
  }

  bool _validate() {
    _nameError = null;

    if (nameController.text.trim().isEmpty) {
      _nameError = 'Name is required';
      notifyListeners();
      return false;
    }

    return true;
  }

  Future<void> toggleEdit() async {
    if (isEditing) {
      nameController.text = _originalName;
      jobTitleController.text = _originalJobTitle;
      companyController.text = _originalCompany;

      final match = industries.firstWhere(
        (ind) => ind.code == selectedIndustryCode,
        orElse: () => Industry(code: '', name: '', fullName: ''),
      );
      selectedIndustryCode = match.code.isEmpty ? null : match.code;
    }

    isEditing = !isEditing;
    _nameError = null;
    notifyListeners();
  }

  Future<void> save() async {
    if (!isEditing) return;

    if (!_validate()) return;

    isSaving = true;
    notifyListeners();

    try {
      final updatedItem = await contactsViewModel.updatePersonalDetails(
        contact.id,
        fullName: nameController.text.trim(),
        jobTitle: jobTitleController.text.trim(),
        company: companyController.text.trim(),
        industry: selectedIndustryCode ?? '',
      );

      if (updatedItem != null) {
        isEditing = false;
        isSaving = false;
        notifyListeners();
      } else {
        nameController.text = _originalName;
        jobTitleController.text = _originalJobTitle;
        companyController.text = _originalCompany;
        final origIndustry = industries.firstWhere(
          (ind) => ind.fullName == _originalIndustry || ind.name == _originalIndustry,
          orElse: () => Industry(code: '', name: '', fullName: ''),
        );
        selectedIndustryCode = origIndustry.code.isEmpty ? null : origIndustry.code;
        isSaving = false;
        isEditing=false;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Personal details save error: $e');
      nameController.text = _originalName;
      jobTitleController.text = _originalJobTitle;
      companyController.text = _originalCompany;
      final origIndustry = industries.firstWhere(
        (ind) => ind.fullName == _originalIndustry || ind.name == _originalIndustry,
        orElse: () => Industry(code: '', name: '', fullName: ''),
      );
      selectedIndustryCode = origIndustry.code.isEmpty ? null : origIndustry.code;
      isSaving = false;
      isEditing = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    jobTitleController.dispose();
    companyController.dispose();
    super.dispose();
  }
}