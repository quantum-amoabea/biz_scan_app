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

import '../../data/contact_services.dart';
import '../../domain/models/contacts_details.dart';
import '../../../../utils/pop_menu_selector.dart';
import '../../../../utils/utils.dart';
import '../../../../navigation/nav_bar.dart';
import '../../viewmodels/contacts_viewmodel.dart';

class ContactDetailsScreen extends StatefulWidget {
  final ContactDetails contact;
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

  @override
  void initState() {
    super.initState();
    final contactViewModel = context.read<ContactsViewModel>();

    _personalDetailsViewModel = PersonalDetailsViewModel(
      contact: widget.contact,
      contactsViewModel: contactViewModel,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      contactViewModel.getIndustries().then((_) {
        if (mounted && contactViewModel.industries.isNotEmpty) {
          _personalDetailsViewModel.setIndustries(contactViewModel.industries);
        }
      });
    });
  }

  @override
  void didUpdateWidget(covariant ContactDetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    final contactViewModel = context.read<ContactsViewModel>();

    if (contactViewModel.industries.isNotEmpty &&
        _personalDetailsViewModel.industries.isEmpty) {
      _personalDetailsViewModel.setIndustries(contactViewModel.industries);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cameraProvider = context.watch<CameraViewModel>();
    final contactViewModel = context.watch<ContactsViewModel>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: contactViewModel),
        ChangeNotifierProvider.value(value: _personalDetailsViewModel),
      ],
      child: Scaffold(
        backgroundColor: BaseColors().whiteColor,
        appBar: const CustomAppBar(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: SafeArea(
            child: Column(
              children: [
                Row(
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
                                  PopupMenuItem(value: item, child: Text(item)),
                            )
                            .toList();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: BaseColors().lightPrimaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: cameraProvider.frontImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(
                            File(cameraProvider.frontImage!.path),
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(
                          Icons.image_outlined,
                          size: 70,
                          color: BaseColors().primaryColor,
                        ),
                ),
                const SizedBox(height: 20),
                GridView.count(
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
                      onPressed: () {
                        final phone = widget.contact.phones.isNotEmpty
                            ? widget.contact.phones.first.value
                            : '';
                        if (phone.isNotEmpty) {
                          callNow(phone);
                        }
                      },
                    ),
                    ActionButtonWidget(
                      icon: Icons.message_outlined,
                      label: 'Text',
                      onPressed: () {
                        final phone = widget.contact.phones.isNotEmpty
                            ? widget.contact.phones.first.value
                            : '';
                        if (phone.isNotEmpty) {
                          sendSms(phone);
                        }
                      },
                    ),
                    ActionButtonWidget(
                      icon: Icons.chat,
                      label: 'WhatsApp',
                      onPressed: () {
                        final phone = widget.contact.phones.isNotEmpty
                            ? widget.contact.phones.first.value
                            : '';
                        if (phone.isNotEmpty) {
                          whatsApp(phone);
                        }
                      },
                    ),
                    ActionButtonWidget(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      onPressed: () {
                        final email = widget.contact.emails.isNotEmpty
                            ? widget.contact.emails.first.value
                            : '';
                        if (email.isNotEmpty) {
                          sendEmail(email);
                        }
                      },
                    ),
                    ActionButtonWidget(
                      icon: Icons.person_add_alt_1,
                      label: 'Save to Phone',
                      onPressed: () => saveToPhoneBook(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                PersonalDetailsCard(viewModel: _personalDetailsViewModel),
                const SizedBox(height: 10),
                ContactDetailsCard(contact: widget.contact),
                const SizedBox(height: 20),
                CustomTextButton(
                  text: "Done",
                  onPressed: () {
                    widget.isScannedContact
                        ? Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NavBar(initialIndex: 2),
                            ),
                            (route) => false,
                          )
                        : Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _personalDetailsViewModel.dispose();
    super.dispose();
  }
}