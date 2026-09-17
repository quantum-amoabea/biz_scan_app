import 'dart:io';

import 'package:biz_scan_app/core/colors.dart';
import 'package:biz_scan_app/features/contact/viewmodels/personal_details_viewmodel.dart';
import 'package:biz_scan_app/features/scan/viewmodels/camera_viewmodel.dart';
import 'package:biz_scan_app/widgets/action_button_widget.dart';
import 'package:biz_scan_app/widgets/contact_details_card.dart';
import 'package:biz_scan_app/widgets/custom_app_bar.dart';
import 'package:biz_scan_app/widgets/custom_textbutton.dart';
import 'package:biz_scan_app/widgets/personal_details_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../navigation/nav_bar.dart';
import '../../../../utils/pop_menu_selector.dart';
import '../../../../utils/utils.dart';
import '../../data/contact_services.dart';
import '../../domain/models/contacts.dart';
import '../../viewmodels/contacts_viewmodel.dart';

class ContactDetailsScreen extends StatefulWidget {
  final Items contact;
  final bool isScannedContact;

  const ContactDetailsScreen({
    super.key,
    required this.contact,
    this.isScannedContact = false,
  });

  @override
  State<ContactDetailsScreen> createState() => _ContactDetailsScreenState();
}

class _ContactDetailsScreenState extends State<ContactDetailsScreen> {
  late final PersonalDetailsViewModel _personalDetailsViewModel;

  bool _showFront = true;

  @override
  void initState() {
    super.initState();

    final contactViewModel = context.read<ContactsViewModel>();

    if (!contactViewModel.contacts.any((c) => c.id == widget.contact.id)) {
      contactViewModel.contacts.add(widget.contact);
    }

    _personalDetailsViewModel = PersonalDetailsViewModel(
      contact: widget.contact,
      contactsViewModel: contactViewModel,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadIndustries(contactViewModel);
    });
  }

  Items _getCurrentContact(ContactsViewModel viewModel) {
    return viewModel.contacts.firstWhere(
      (c) => c.id == widget.contact.id,
      orElse: () => widget.contact,
    );
  }

  Future<void> _loadIndustries(ContactsViewModel contactViewModel) async {
    await contactViewModel.getIndustries();

    if (!mounted) return;

    if (contactViewModel.industries.isNotEmpty &&
        _personalDetailsViewModel.industries.isEmpty) {
      _personalDetailsViewModel.setIndustries(contactViewModel.industries);
    }
  }

  @override
  void didUpdateWidget(covariant ContactDetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    final contactViewModel = context.read<ContactsViewModel>();

    final currentContact = _getCurrentContact(contactViewModel);

    if (currentContact.id != oldWidget.contact.id ||
        currentContact.fullName != widget.contact.fullName ||
        currentContact.jobTitle != widget.contact.jobTitle ||
        currentContact.company != widget.contact.company) {
      _personalDetailsViewModel.syncContact(currentContact);
    }

    if (contactViewModel.industries.isNotEmpty &&
        _personalDetailsViewModel.industries.isEmpty) {
      _personalDetailsViewModel.setIndustries(contactViewModel.industries);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cameraProvider = context.watch<CameraViewModel>();
    final contactViewModel = context.watch<ContactsViewModel>();
    final currentContact = _getCurrentContact(contactViewModel);

    return Scaffold(
      backgroundColor: BaseColors().whiteColor,
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              _buildCardImage(cameraProvider, currentContact),
              const SizedBox(height: 10),
              _buildCardSideSelector(),
              const SizedBox(height: 20),
              _buildActionButtons(currentContact),
              const SizedBox(height: 20),
              PersonalDetailsCard(viewModel: _personalDetailsViewModel),
              const SizedBox(height: 10),
              ContactDetailsCard(contact: currentContact),
              const SizedBox(height: 20),
              CustomTextButton(text: 'Done', onPressed: _handleDone),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Business Card',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        PopupMenuButton<String>(
          color: BaseColors().whiteColor,
          onSelected: (newValue) {
            handleDropdownSelection(newValue, context);
          },
          itemBuilder: (context) {
            return popMenuItems
                .map(
                  (item) =>
                      PopupMenuItem<String>(value: item, child: Text(item)),
                )
                .toList();
          },
        ),
      ],
    );
  }

  Widget _buildCardImage(CameraViewModel cameraProvider, Items contact) {
    final frontImagePath = cameraProvider.frontImage?.path;

    final frontImageUrl = contact.cardImages?.front;
    final backImageUrl = contact.cardImages?.back;

    final imageUrl = _showFront ? frontImageUrl : backImageUrl;

    final localImagePath = _showFront ? frontImagePath : null;

    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: BaseColors().lightPrimaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: localImagePath != null
            ? Image.file(
                File(localImagePath),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildImagePlaceholder();
                },
              )
            : imageUrl != null && imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildImagePlaceholder();
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return Center(
                    child: CircularProgressIndicator(
                      color: BaseColors().primaryColor,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              )
            : _buildImagePlaceholder(),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Center(
      child: Icon(
        Icons.image_outlined,
        size: 70,
        color: BaseColors().primaryColor,
      ),
    );
  }

  Widget _buildCardSideSelector() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _showFront = true;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: _showFront
                  ? BaseColors().primaryColor
                  : BaseColors().whiteColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: BaseColors().primaryColor),
            ),
            child: Center(
              child: Text(
                'Front',
                style: TextStyle(
                  fontSize: 12,
                  color: _showFront
                      ? BaseColors().whiteColor
                      : BaseColors().primaryColor,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 3),
        GestureDetector(
          onTap: () {
            setState(() {
              _showFront = false;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: !_showFront
                  ? BaseColors().primaryColor
                  : BaseColors().whiteColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: BaseColors().primaryColor),
            ),
            child: Center(
              child: Text(
                'Back',
                style: TextStyle(
                  fontSize: 12,
                  color: !_showFront
                      ? BaseColors().whiteColor
                      : BaseColors().primaryColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(Items contact) {
    final primaryPhone = _primaryPhone(contact);
    final primaryEmail = _primaryEmail(contact);

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 3.2,
      children: [
        ActionButtonWidget(
          icon: Icons.phone,
          label: 'Call Mobile',
          onPressed: () => _callMobile(contact),
        ),
        ActionButtonWidget(
          icon: Icons.message_outlined,
          label: 'Text',
          onPressed: () => _sendText(contact),
        ),
        ActionButtonWidget(
          icon: Icons.chat,
          label: 'WhatsApp',
          onPressed: () => _openWhatsApp(contact),
        ),
        ActionButtonWidget(
          icon: Icons.email_outlined,
          label: 'Email',
          onPressed: () => _sendEmail(contact),
        ),
        ActionButtonWidget(
          icon: Icons.person_add_alt_1,
          label: 'Save to Phone',
          onPressed: () => saveToPhoneBook(
            name: contact.fullName,
            phoneNumber: primaryPhone,
            email: primaryEmail,
          ),
        ),
      ],
    );
  }

  void _callMobile(Items contact) {
    final phone = _primaryPhone(contact);

    if (phone == null) return;

    callNow(phone);
  }

  void _sendText(Items contact) {
    final phone = _primaryPhone(contact);

    if (phone == null) return;

    sendSms(phone);
  }

  void _openWhatsApp(Items contact) {
    final phone = _primaryPhone(contact);

    if (phone == null) return;

    whatsApp(phone);
  }

  void _sendEmail(Items contact) {
    final email = _primaryEmail(contact);

    if (email == null) return;

    sendEmail(email);
  }

  String? _primaryPhone(Items contact) {
    final phones = contact.phones;

    if (phones == null || phones.isEmpty) {
      return null;
    }

    final phone = phones.first;

    final value = phone.e164?.trim();

    if (value == null || value.isEmpty) {
      return null;
    }

    return value;
  }

  String? _primaryEmail(Items contact) {
    final emails = contact.emails;

    if (emails == null || emails.isEmpty) {
      return null;
    }

    final email = emails.first.email?.trim();

    if (email == null || email.isEmpty) {
      return null;
    }

    return email;
  }

  void _handleDone() {
    if (!mounted) return;

    if (widget.isScannedContact) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const NavBar(initialIndex: 2)),
        (route) => false,
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _personalDetailsViewModel.dispose();
    super.dispose();
  }
}
