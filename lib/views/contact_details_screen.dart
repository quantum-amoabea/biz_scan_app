import 'dart:io';

import 'package:biz_scan_app/core/colors.dart';
import 'package:biz_scan_app/core/toast_message.dart';
import 'package:biz_scan_app/services/contact_services.dart';
import 'package:biz_scan_app/utils/utils.dart';
import 'package:biz_scan_app/view_models/camera_provider.dart';
import 'package:biz_scan_app/view_models/scan_provider.dart';
import 'package:biz_scan_app/views/review_contact_screen.dart';
import 'package:biz_scan_app/views/scan_screen.dart';
import 'package:biz_scan_app/widgets/custom_app_bar.dart';
import 'package:biz_scan_app/widgets/custom_textbutton.dart';
import 'package:biz_scan_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../utils/pop_menu_selector.dart';
import 'nav_bar.dart';

class ContactDetailsScreen extends StatelessWidget {
  const ContactDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cameraProvider = context.watch<CameraProvider>();
    final scanProvider = context.read<ScanProvider>();
    final readCameraProvider = context.read<CameraProvider>();
    return Scaffold(
      backgroundColor: BaseColors().whiteColor,
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: Column(
            children: [
              // Header
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

              // Business card image
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: BaseColors().lightGreyColor,
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
                        color: BaseColors().greyColor,
                      ),
              ),

              const SizedBox(height: 20),

              // Action buttons
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 3.2,
                children: [
                  _ActionButton(
                    icon: Icons.phone,
                    label: 'Call Mobile',
                    onPressed: () => callNow('0200000000'),
                  ),

                  _ActionButton(
                    icon: Icons.message_outlined,
                    label: 'Text',
                    onPressed: () => sendSms('0200000000'),
                  ),

                  _ActionButton(
                    icon: Icons.chat,
                    label: 'WhatsApp',
                    onPressed: () => whatsApp('0200000000'),
                  ),

                  _ActionButton(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    onPressed: () => sendEmail('amoabeaakuaosafo@gmail.com'),
                  ),

                  _ActionButton(
                    icon: Icons.person_add_alt_1,
                    label: 'Save to Phone',
                    onPressed: () => saveToPhoneBook(),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Personal details card
              _PersonalDetailsCard(),
              SizedBox(height: 10),
              _ContactDetailsCard(),
              SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: CustomTextButton(
                      text: "Cancel",
                      backgroundColor: Colors.transparent,
                      foregroundColor: BaseColors().primaryColor,
                      onPressed: () {
                        readCameraProvider.clearAllImages();
                        scanProvider.resetScan();
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> ScanScreen()));
                      },
                    ),
                  ),
                  SizedBox(width: 20),

                  Expanded(
                    child: CustomTextButton(
                      text: "Done",
                      onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NavBar(initialIndex: 2),
                        ),
                        (route) => false,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: BaseColors().primaryColor),
      label: Text(label, style: TextStyle(color: BaseColors().primaryColor)),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        backgroundColor: BaseColors().whiteColor,
        elevation: 0,
        side: BorderSide(color: BaseColors().primaryColor, width: 1),
      ),
    );
  }
}

class _PersonalDetailsCard extends StatefulWidget {
  const _PersonalDetailsCard();

  @override
  State<_PersonalDetailsCard> createState() => _PersonalDetailsCardState();
}

class _PersonalDetailsCardState extends State<_PersonalDetailsCard> {
  bool isEditing = false;

  late final TextEditingController nameController;
  late final TextEditingController jobTitleController;
  late final TextEditingController companyController;
  late final TextEditingController industryController;

  @override
  void initState() {
    super.initState();

    final scannedDetails = context.read<ScanProvider>().scannedCardDetails;

    nameController = TextEditingController(
      text: scannedDetails?.contact?.fullName ?? '',
    );

    jobTitleController = TextEditingController(
      text: scannedDetails?.contact?.jobTitle ?? '',
    );

    companyController = TextEditingController(
      text: scannedDetails?.contact?.company ?? '',
    );

    industryController = TextEditingController(
      text: scannedDetails?.contact?.industry ?? '',
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    jobTitleController.dispose();
    companyController.dispose();
    industryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: BaseColors().whiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: BaseColors().greyColor,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'PERSONAL DETAILS',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),

              GestureDetector(
                onTap: () {
                  setState(() {
                    isEditing = !isEditing;
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      isEditing ? Icons.close : Icons.edit,
                      color: BaseColors().primaryColor,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isEditing ? 'Cancel' : 'Edit',
                      style: TextStyle(color: BaseColors().primaryColor),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          if (isEditing) ...[
            _EditField(label: 'Full Name', controller: nameController),

            const SizedBox(height: 15),

            _EditField(label: 'Job Title', controller: jobTitleController),

            const SizedBox(height: 15),

            _EditField(label: 'Company', controller: companyController),

            const SizedBox(height: 15),

            _EditField(label: 'Industry', controller: industryController),

            const SizedBox(height: 20),

            CustomTextButton(
              text: "Save Changes",
              onPressed: () {
                setState(() {
                  isEditing = false;
                });
              },
            ),
          ] else ...[
            ContactDetailItem(
              icon: Icons.person,
              label: 'Full Name',
              value: nameController.text,
            ),

            const SizedBox(height: 15),

            ContactDetailItem(
              icon: Icons.work,
              label: 'Job Title',
              value: jobTitleController.text,
            ),

            const SizedBox(height: 15),

            ContactDetailItem(
              icon: Icons.business,
              label: 'Company',
              value: companyController.text,
            ),

            const SizedBox(height: 15),

            ContactDetailItem(
              icon: Icons.business_outlined,
              label: 'Industry',
              value: industryController.text,
            ),
          ],
        ],
      ),
    );
  }
}

class ContactDetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ContactDetailItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon),
        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      value,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  IconButton(
                    color: BaseColors().greyColor,
                    iconSize: 17,
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: value));

                      showToast(message: "Copied to Clipboard");
                    },
                    icon: const Icon(Icons.copy),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContactDetailsCard extends StatefulWidget {
  const _ContactDetailsCard();

  @override
  State<_ContactDetailsCard> createState() => _ContactDetailsCardState();
}

class _ContactDetailsCardState extends State<_ContactDetailsCard> {
  bool isEditing = false;

  final List<TextEditingController> phoneControllers = [];
  final List<TextEditingController> emailControllers = [];
  late TextEditingController websiteController;

  @override
  void initState() {
    super.initState();

    final contact = context.read<ScanProvider>().scannedCardDetails?.contact;

    // Phones
    for (final phone in contact?.phones ?? []) {
      phoneControllers.add(
        TextEditingController(
          text: phone.display ?? phone.e164 ?? phone.raw ?? '',
        ),
      );
    }

    // Emails
    for (final email in contact?.emails ?? []) {
      emailControllers.add(TextEditingController(text: email.email ?? ''));
    }

    // Website
    final website = contact?.socials
        ?.where((social) => social.platform?.toLowerCase() == 'website')
        .firstOrNull;

    websiteController = TextEditingController(text: website?.url ?? '');
  }

  @override
  void dispose() {
    for (final controller in phoneControllers) {
      controller.dispose();
    }

    for (final controller in emailControllers) {
      controller.dispose();
    }

    websiteController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contact = context.watch<ScanProvider>().scannedCardDetails?.contact;

    final phones = contact?.phones ?? [];
    final emails = contact?.emails ?? [];
    final socials = contact?.socials ?? [];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: BaseColors().whiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: BaseColors().greyColor,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'CONTACT DETAILS',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),

              GestureDetector(
                onTap: () {
                  setState(() {
                    isEditing = !isEditing;
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      isEditing ? Icons.close : Icons.edit,
                      color: BaseColors().primaryColor,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isEditing ? 'Cancel' : 'Edit',
                      style: TextStyle(color: BaseColors().primaryColor),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          if (isEditing) ...[
            ...List.generate(
              phoneControllers.length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: _EditField(
                  label:
                      phones[index].type != null &&
                          phones[index].type!.isNotEmpty
                      ? 'Phone (${phones[index].type})'
                      : 'Phone ${index + 1}',
                  controller: phoneControllers[index],
                  keyboardType: TextInputType.phone,
                ),
              ),
            ),

            ...List.generate(
              emailControllers.length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: _EditField(
                  label:
                      emails[index].type != null &&
                          emails[index].type!.isNotEmpty
                      ? 'Email (${emails[index].type})'
                      : 'Email ${index + 1}',
                  controller: emailControllers[index],
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
            ),

            if (websiteController.text.isNotEmpty)
              _EditField(
                label: 'Website',
                controller: websiteController,
                keyboardType: TextInputType.url,
              ),

            const SizedBox(height: 20),

            CustomTextButton(
              text: "Save Changes",
              onPressed: () {
                setState(() {
                  isEditing = false;
                });
              },
            ),
          ] else ...[
            ...List.generate(phones.length, (index) {
              final phone = phones[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: ContactDetailItem(
                  icon: Icons.phone_outlined,
                  label: phone.type != null && phone.type!.isNotEmpty
                      ? 'Phone (${phone.type})'
                      : 'Phone ${index + 1}',
                  value: phone.display ?? phone.e164 ?? phone.raw ?? '',
                ),
              );
            }),

            ...List.generate(emails.length, (index) {
              final email = emails[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: ContactDetailItem(
                  icon: Icons.email_outlined,
                  label: email.type != null && email.type!.isNotEmpty
                      ? 'Email (${email.type})'
                      : 'Email ${index + 1}',
                  value: email.email ?? '',
                ),
              );
            }),

            ...socials
                .where((social) => social.url != null && social.url!.isNotEmpty)
                .map(
                  (social) => Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: ContactDetailItem(
                      icon: Icons.web,
                      label: social.platform ?? 'Website',
                      value: social.url ?? '',
                    ),
                  ),
                ),
          ],
        ],
      ),
    );
  }
}

class _EditField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  const _EditField({
    required this.label,
    required this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          title: label,
          controller: controller,
          keyboardType: keyboardType,
        ),
      ],
    );
  }
}
