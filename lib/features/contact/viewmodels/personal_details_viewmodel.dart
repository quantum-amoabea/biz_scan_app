import 'package:biz_scan_app/features/contact/contact.dart';
import 'package:flutter/cupertino.dart';


class PersonalDetailsViewModel extends ChangeNotifier {
  final Items contact;
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

  String? _nameError;

  String? get nameError => _nameError;

  String get selectedIndustryDisplay {
    if (selectedIndustryCode == null ||
        selectedIndustryCode!.isEmpty) {
      return contact.industry ?? '';
    }

    final industry = industries.firstWhere(
      (ind) => ind.code == selectedIndustryCode,
      orElse: () => Industry(
        code: selectedIndustryCode!,
        name: '',
        fullName: '',
      ),
    );

    if (industry.fullName.isNotEmpty) {
      return industry.fullName;
    }

    return industry.name;
  }

  PersonalDetailsViewModel({
    required this.contact,
    required this.contactsViewModel,
  }) {
    _originalName = contact.fullName ?? '';
    _originalJobTitle = contact.jobTitle ?? '';
    _originalCompany = contact.company ?? '';
    _originalIndustry = contact.industry ?? '';

    nameController = TextEditingController(
      text: _originalName,
    );

    jobTitleController = TextEditingController(
      text: _originalJobTitle,
    );

    companyController = TextEditingController(
      text: _originalCompany,
    );
  }

  void syncContact(Items contact) {
    _originalName = contact.fullName ?? '';
    _originalJobTitle = contact.jobTitle ?? '';
    _originalCompany = contact.company ?? '';
    _originalIndustry = contact.industry ?? '';

    nameController.text = _originalName;
    jobTitleController.text = _originalJobTitle;
    companyController.text = _originalCompany;

    notifyListeners();
  }

  void setIndustries(List<Industry> fetchedIndustries) {
    industries = fetchedIndustries;

    if (selectedIndustryCode == null ||
        selectedIndustryCode!.isEmpty) {
      final matching = industries.firstWhere(
        (ind) =>
            ind.fullName == _originalIndustry ||
            ind.name == _originalIndustry,
        orElse: () => Industry(
          code: '',
          name: '',
          fullName: '',
        ),
      );

      selectedIndustryCode =
          matching.code.isEmpty ? null : matching.code;
    }

    notifyListeners();
  }

  void onIndustryChanged(String? code) {
    selectedIndustryCode = code;
    notifyListeners();
  }

  void toggleEdit() {
    if (isSaving) return;

    if (isEditing) {
      _restoreOriginalValues();
    }

    isEditing = !isEditing;
    _nameError = null;

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

  Future<void> save() async {
    if (!isEditing || isSaving) return;

    if (!_validate()) return;

    isSaving = true;
    _nameError = null;
    notifyListeners();

    try {
      final updatedItem =
          await contactsViewModel.updatePersonalDetails(
        contact.id ?? '',
        fullName: nameController.text.trim(),
        jobTitle: jobTitleController.text.trim(),
        company: companyController.text.trim(),
        industry: selectedIndustryCode ?? '',
      );

      if (updatedItem == null) {
        _restoreOriginalValues();

        isSaving = false;
        isEditing = false;

        notifyListeners();
        return;
      }

      // The save succeeded.
      // These now become the values to restore if the user
      // enters edit mode again and cancels.
      _originalName = nameController.text.trim();
      _originalJobTitle = jobTitleController.text.trim();
      _originalCompany = companyController.text.trim();

      final savedIndustryCode = selectedIndustryCode;

      if (savedIndustryCode != null &&
          savedIndustryCode.isNotEmpty) {
        final industry = industries.firstWhere(
          (ind) => ind.code == savedIndustryCode,
          orElse: () => Industry(
            code: '',
            name: '',
            fullName: '',
          ),
        );

        _originalIndustry = industry.fullName.isNotEmpty
            ? industry.fullName
            : industry.name;
      } else {
        _originalIndustry = '';
      }

      isSaving = false;
      isEditing = false;

      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint(
        'Personal details save error: $e',
      );
      debugPrintStack(
        stackTrace: stackTrace,
      );

      _restoreOriginalValues();

      isSaving = false;
      isEditing = false;

      notifyListeners();
    }
  }

  void _restoreOriginalValues() {
    nameController.text = _originalName;
    jobTitleController.text = _originalJobTitle;
    companyController.text = _originalCompany;

    final originalIndustry = industries.firstWhere(
      (ind) =>
          ind.fullName == _originalIndustry ||
          ind.name == _originalIndustry,
      orElse: () => Industry(
        code: '',
        name: '',
        fullName: '',
      ),
    );

    selectedIndustryCode =
        originalIndustry.code.isEmpty
            ? null
            : originalIndustry.code;

    _nameError = null;
  }

  @override
  void dispose() {
    nameController.dispose();
    jobTitleController.dispose();
    companyController.dispose();

    super.dispose();
  }
}