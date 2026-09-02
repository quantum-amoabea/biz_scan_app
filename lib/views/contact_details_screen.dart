import 'dart:io';
import 'package:biz_scan_app/core/colors.dart';
import 'package:biz_scan_app/core/toast_message.dart';
import 'package:biz_scan_app/services/contact_services.dart';
import 'package:biz_scan_app/utils/utils.dart';
import 'package:biz_scan_app/view_models/camera_provider.dart';
import 'package:biz_scan_app/views/scan_screen.dart';
import 'package:biz_scan_app/widgets/custom_app_bar.dart';
import 'package:biz_scan_app/widgets/custom_textbutton.dart';
import 'package:biz_scan_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/contacts_details.dart';
import '../utils/pop_menu_selector.dart';
import 'nav_bar.dart';

class ContactDetailsScreen extends StatelessWidget {
  final ContactDetails contact;
  final bool isScannedContact;

  const ContactDetailsScreen({
    super.key,
    required this.contact,
    this.isScannedContact = false,
  });

  @override
  Widget build(BuildContext context) {
    final cameraProvider = context.watch<CameraProvider>();

    return Scaffold(
      backgroundColor: BaseColors().whiteColor,
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: Column(
            children: [
              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Business Card',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PopupMenuButton<String>(
                    color: BaseColors().whiteColor,
                    onSelected: (newValue) {
                      handleDropdownSelection(
                        newValue,
                        context,
                      );
                    },
                    itemBuilder: (context) {
                      return popMenuItems
                          .map(
                            (item) => PopupMenuItem(
                              value: item,
                              child: Text(item),
                            ),
                          )
                          .toList();
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // BUSINESS CARD IMAGE
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
                          File(
                            cameraProvider.frontImage!.path,
                          ),
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

              // ACTION BUTTONS
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
                    onPressed: () {
                      final phone = contact.phones.isNotEmpty
                          ? contact.phones.first.value
                          : '';

                      if (phone.isNotEmpty) {
                        callNow(phone);
                      }
                    },
                  ),

                  _ActionButton(
                    icon: Icons.message_outlined,
                    label: 'Text',
                    onPressed: () {
                      final phone = contact.phones.isNotEmpty
                          ? contact.phones.first.value
                          : '';

                      if (phone.isNotEmpty) {
                        sendSms(phone);
                      }
                    },
                  ),

                  _ActionButton(
                    icon: Icons.chat,
                    label: 'WhatsApp',
                    onPressed: () {
                      final phone = contact.phones.isNotEmpty
                          ? contact.phones.first.value
                          : '';

                      if (phone.isNotEmpty) {
                        whatsApp(phone);
                      }
                    },
                  ),

                  _ActionButton(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    onPressed: () {
                      final email = contact.emails.isNotEmpty
                          ? contact.emails.first.value
                          : '';

                      if (email.isNotEmpty) {
                        sendEmail(email);
                      }
                    },
                  ),

                  _ActionButton(
                    icon: Icons.person_add_alt_1,
                    label: 'Save to Phone',
                    onPressed: () => saveToPhoneBook(),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // PERSONAL DETAILS
              _PersonalDetailsCard(
                contact: contact,
              ),

              const SizedBox(height: 10),

              // CONTACT DETAILS
              _ContactDetailsCard(
                contact: contact,
              ),

              const SizedBox(height: 20),

              // BOTTOM BUTTONS
              if (isScannedContact)
                Row(
                  children: [
                    Expanded(
                      child: CustomTextButton(
                        text: "Cancel",
                        backgroundColor: Colors.transparent,
                        foregroundColor:
                            BaseColors().primaryColor,
                        onPressed: () {
                          context
                              .read<CameraProvider>()
                              .clearAllImages();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ScanScreen(),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: 20),

                    Expanded(
                      child: CustomTextButton(
                        text: "Done",
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const NavBar(
                                initialIndex: 2,
                              ),
                            ),
                            (route) => false,
                          );
                        },
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
      icon: Icon(
        icon,
        color: BaseColors().primaryColor,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: BaseColors().primaryColor,
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        backgroundColor: BaseColors().whiteColor,
        elevation: 0,
        side: BorderSide(
          color: BaseColors().primaryColor,
          width: 1,
        ),
      ),
    );
  }
}

class _PersonalDetailsCard extends StatefulWidget {
  final ContactDetails contact;

  const _PersonalDetailsCard({
    required this.contact,
  });

  @override
  State<_PersonalDetailsCard> createState() =>
      _PersonalDetailsCardState();
}

class _PersonalDetailsCardState
    extends State<_PersonalDetailsCard> {
  bool isEditing = false;

  late final TextEditingController nameController;
  late final TextEditingController jobTitleController;
  late final TextEditingController companyController;
  late final TextEditingController industryController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: widget.contact.fullName,
    );

    jobTitleController = TextEditingController(
      text: widget.contact.jobTitle,
    );

    companyController = TextEditingController(
      text: widget.contact.company,
    );

    industryController = TextEditingController(
      text: widget.contact.industry,
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
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'PERSONAL DETAILS',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
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
                      isEditing
                          ? Icons.close
                          : Icons.edit,
                      color: BaseColors().primaryColor,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isEditing ? 'Cancel' : 'Edit',
                      style: TextStyle(
                        color: BaseColors().primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          if (isEditing) ...[
            _EditField(
              label: 'Full Name',
              controller: nameController,
            ),

            const SizedBox(height: 15),

            _EditField(
              label: 'Job Title',
              controller: jobTitleController,
            ),

            const SizedBox(height: 15),

            _EditField(
              label: 'Company',
              controller: companyController,
            ),

            const SizedBox(height: 15),

            _EditField(
              label: 'Industry',
              controller: industryController,
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
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  if (value.isNotEmpty)
                    IconButton(
                      color: BaseColors().greyColor,
                      iconSize: 17,
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: value),
                        );

                        showToast(
                          message: "Copied to Clipboard",
                        );
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
  final ContactDetails contact;

  const _ContactDetailsCard({
    required this.contact,
  });

  @override
  State<_ContactDetailsCard> createState() =>
      _ContactDetailsCardState();
}

class _ContactDetailsCardState
    extends State<_ContactDetailsCard> {
  bool isEditing = false;

  late final List<TextEditingController>
      phoneControllers;

  late final List<TextEditingController>
      emailControllers;

  late final TextEditingController websiteController;

  @override
  void initState() {
    super.initState();

    phoneControllers = [];

    emailControllers = [];

    // PHONES
    if (widget.contact.phones.isEmpty) {
      phoneControllers.add(
        TextEditingController(),
      );
    } else {
      for (final phone in widget.contact.phones) {
        phoneControllers.add(
          TextEditingController(
            text: phone.value,
          ),
        );
      }
    }

    // EMAILS
    if (widget.contact.emails.isEmpty) {
      emailControllers.add(
        TextEditingController(),
      );
    } else {
      for (final email in widget.contact.emails) {
        emailControllers.add(
          TextEditingController(
            text: email.value,
          ),
        );
      }
    }

    websiteController = TextEditingController(
      text: widget.contact.website,
    );
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
          // HEADER
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'CONTACT DETAILS',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
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
                      isEditing
                          ? Icons.close
                          : Icons.edit,
                      color: BaseColors().primaryColor,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isEditing ? 'Cancel' : 'Edit',
                      style: TextStyle(
                        color: BaseColors().primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          if (isEditing) ...[
            // PHONES
            ...List.generate(
              phoneControllers.length,
              (index) {
                final type =
                    widget.contact.phones.length > index
                        ? widget
                                .contact
                                .phones[index]
                                .type
                        : '';

                return Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15),
                  child: _EditField(
                    label: type.isNotEmpty
                        ? 'Phone ($type)'
                        : 'Phone ${index + 1}',
                    controller:
                        phoneControllers[index],
                    keyboardType:
                        TextInputType.phone,
                  ),
                );
              },
            ),

            // EMAILS
            ...List.generate(
              emailControllers.length,
              (index) {
                final type =
                    widget.contact.emails.length > index
                        ? widget
                                .contact
                                .emails[index]
                                .type
                        : '';

                return Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15),
                  child: _EditField(
                    label: type.isNotEmpty
                        ? 'Email ($type)'
                        : 'Email ${index + 1}',
                    controller:
                        emailControllers[index],
                    keyboardType:
                        TextInputType.emailAddress,
                  ),
                );
              },
            ),

            // WEBSITE
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
            // PHONES
            ...List.generate(
              widget.contact.phones.length,
              (index) {
                final phone =
                    widget.contact.phones[index];

                return Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15),
                  child: ContactDetailItem(
                    icon: Icons.phone,
                    label: phone.type.isNotEmpty
                        ? 'Phone (${phone.type})'
                        : 'Phone ${index + 1}',
                    value: phone.value,
                  ),
                );
              },
            ),

            if (widget.contact.phones.isEmpty)
              const Padding(
                padding:
                    EdgeInsets.only(bottom: 15),
                child: ContactDetailItem(
                  icon: Icons.phone,
                  label: 'Phone',
                  value: '',
                ),
              ),

            // EMAILS
            ...List.generate(
              widget.contact.emails.length,
              (index) {
                final email =
                    widget.contact.emails[index];

                return Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15),
                  child: ContactDetailItem(
                    icon: Icons.email_outlined,
                    label: email.type.isNotEmpty
                        ? 'Email (${email.type})'
                        : 'Email ${index + 1}',
                    value: email.value,
                  ),
                );
              },
            ),

            if (widget.contact.emails.isEmpty)
              const Padding(
                padding:
                    EdgeInsets.only(bottom: 15),
                child: ContactDetailItem(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: '',
                ),
              ),

            // WEBSITE
            if (widget.contact.website.isNotEmpty)
              ContactDetailItem(
                icon: Icons.language,
                label: 'Website',
                value: widget.contact.website,
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
    return CustomTextField(
      title: label,
      controller: controller,
      keyboardType: keyboardType,
    );
  }
}
