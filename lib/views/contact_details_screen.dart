import 'dart:io';

import 'package:biz_scan_app/core/colors.dart';
import 'package:biz_scan_app/core/toast_message.dart';
import 'package:biz_scan_app/services/contact_services.dart';
import 'package:biz_scan_app/utils/utils.dart';
import 'package:biz_scan_app/view_models/camera_provider.dart';
import 'package:biz_scan_app/view_models/scan_provider.dart';
import 'package:biz_scan_app/widgets/custom_app_bar.dart';
import 'package:biz_scan_app/widgets/custom_textbutton.dart';
import 'package:biz_scan_app/widgets/custom_textfield.dart';
import 'package:biz_scan_app/widgets/edit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/contacts_details.dart';
import '../models/regions.dart';
import '../utils/pop_menu_selector.dart';
import '../widgets/phone_label.dart';
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
              _PersonalDetailsCard(contact: contact),

              const SizedBox(height: 10),

              // CONTACT DETAILS
              _ContactDetailsCard(contact: contact),

              const SizedBox(height: 20),

              CustomTextButton(
                text: "Done",
                onPressed: () {
                  isScannedContact
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

              // BOTTOM BUTTONS
              /*if (isScannedContact)
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


                  ],
                ),*/
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
  final ContactDetails contact;

  const _PersonalDetailsCard({required this.contact});

  @override
  State<_PersonalDetailsCard> createState() => _PersonalDetailsCardState();
}

class _PersonalDetailsCardState extends State<_PersonalDetailsCard> {
  String? editingField;

  late final TextEditingController nameController;
  late final TextEditingController jobTitleController;
  late final TextEditingController companyController;
  late final TextEditingController industryController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.contact.fullName);

    jobTitleController = TextEditingController(text: widget.contact.jobTitle);

    companyController = TextEditingController(text: widget.contact.company);

    industryController = TextEditingController(text: widget.contact.industry);
  }

  @override
  void dispose() {
    nameController.dispose();
    jobTitleController.dispose();
    companyController.dispose();
    industryController.dispose();

    super.dispose();
  }

  void _toggleEdit(String field) {
    setState(() {
      editingField = editingField == field ? null : field;
    });
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
          const Row(
            children: [
              Text(
                'PERSONAL DETAILS',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),

          const SizedBox(height: 15),

          _PersonalField(
            label: 'Full Name',
            icon: Icons.person,
            controller: nameController,
            isEditing: editingField == 'name',
            onEdit: () => _toggleEdit('name'),
          ),

          const SizedBox(height: 15),

          _PersonalField(
            label: 'Job Title',
            icon: Icons.work,
            controller: jobTitleController,
            isEditing: editingField == 'jobTitle',
            onEdit: () => _toggleEdit('jobTitle'),
          ),

          const SizedBox(height: 15),

          _PersonalField(
            label: 'Company',
            icon: Icons.business,
            controller: companyController,
            isEditing: editingField == 'company',
            onEdit: () => _toggleEdit('company'),
          ),

          const SizedBox(height: 15),

          _PersonalField(
            label: 'Industry',
            icon: Icons.business_outlined,
            controller: industryController,
            isEditing: editingField == 'industry',
            onEdit: () => _toggleEdit('industry'),
          ),
        ],
      ),
    );
  }
}

class _PersonalField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final bool isEditing;
  final VoidCallback onEdit;

  const _PersonalField({
    required this.label,
    required this.icon,
    required this.controller,
    required this.isEditing,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    if (isEditing) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: BaseColors().primaryColor),
          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                    GestureDetector(
                      onTap: onEdit,
                      child: Row(
                        children: [
                          Icon(
                            Icons.close,
                            color: BaseColors().primaryColor,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Cancel',
                            style: TextStyle(color: BaseColors().primaryColor),
                          ),
                        ],
                      ),

            ),

                const SizedBox(height: 5),

                _EditField(label: label, controller: controller),
              ],
            ),
          ),
        ],
      );
    }

    return ContactDetailItem(
      icon: icon,
      label: label,
      value: controller.text.isNotEmpty ? controller.text : "N/A",
      onEdit: onEdit,
    );
  }
}

class ContactDetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onEdit;

  const ContactDetailItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: BaseColors().primaryColor),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: TextStyle(overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      value,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  if (value.isNotEmpty)
                    IconButton(
                      color: BaseColors().greyColor,
                      iconSize: 17,
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: value));

                        showToast(message: "Copied to Clipboard");
                      },
                      icon: const Icon(Icons.copy),
                    ),

                  if (onEdit != null)
                    GestureDetector(
                      onTap: onEdit,
                      child: Icon(
                        Icons.edit,
                        color: BaseColors().greyColor,
                        size: 18,
                      ),
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

  const _ContactDetailsCard({required this.contact});

  @override
  State<_ContactDetailsCard> createState() => _ContactDetailsCardState();
}

class _ContactDetailsCardState extends State<_ContactDetailsCard> {
  int? editingPhoneIndex;
  int? editingEmailIndex;
  bool editingWebsite = false;

  String selectedPhoneType = 'Home';
  String selectedWebsiteKind = 'Website';
  late final List<TextEditingController> phoneControllers;
  late final List<TextEditingController> emailControllers;
  late final TextEditingController websiteController;
  final TextEditingController editPhoneController = TextEditingController();
  final TextEditingController editWebsiteController = TextEditingController();
  final TextEditingController editEmailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    phoneControllers = widget.contact.phones
        .map((phone) => TextEditingController(text: phone.value))
        .toList();

    emailControllers = widget.contact.emails
        .map((email) => TextEditingController(text: email.value))
        .toList();

    websiteController = TextEditingController(text: widget.contact.website);
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

  void _addPhone() {
    setState(() {
      phoneControllers.add(TextEditingController());

      editingPhoneIndex = phoneControllers.length - 1;
    });
  }

  void _addEmail() {
    setState(() {
      emailControllers.add(TextEditingController());

      editingEmailIndex = emailControllers.length - 1;
    });
  }

  void _addWebsite() {
    setState(() {
      editingWebsite = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scanProvider = context.read<ScanProvider>();
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
          const Row(
            children: [
              Text(
                'CONTACT DETAILS',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // PHONES
          ...List.generate(phoneControllers.length, (index) {
            final type = widget.contact.phones.length > index
                ? widget.contact.phones[index].type
                : '';

            final label = type.isNotEmpty
                ? 'Phone ($type)'
                : 'Phone ${index + 1}';

            return _ContactEditableField(
              icon: Icons.phone,
              label: label,
              controller: phoneControllers[index],
              isEditing: editingPhoneIndex == index,
              keyboardType: TextInputType.phone,
              onEdit: () {
                setState(() {
                  editingPhoneIndex = editingPhoneIndex == index ? null : index;
                });
              },
            );
          }),

          // ADD PHONE
          _AddFieldButton(
            label: 'Add Phone',
            onPressed: () {
              editDialog(
                context,
                title: "Add a number",
                content: StatefulBuilder(
                  builder: (context, dialogSetState) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          title: 'Number',
                          controller: editPhoneController,
                          keyboardType: TextInputType.phone,
                        ),

                        const SizedBox(height: 15),

                        const Text('Label'),

                        const SizedBox(height: 10),

                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            PhoneTypeContainer(
                              text: 'Home',
                              isSelected: selectedPhoneType == 'Home',
                              onTap: () {
                                dialogSetState(() {
                                  selectedPhoneType = 'Home';
                                });
                              },
                            ),

                            PhoneTypeContainer(
                              text: 'Work',
                              isSelected: selectedPhoneType == 'Work',
                              onTap: () {
                                dialogSetState(() {
                                  selectedPhoneType = 'Work';
                                });
                              },
                            ),

                            PhoneTypeContainer(
                              text: 'Mobile',
                              isSelected: selectedPhoneType == 'Mobile',
                              onTap: () {
                                dialogSetState(() {
                                  selectedPhoneType = 'Mobile';
                                });
                              },
                            ),

                            PhoneTypeContainer(
                              text: 'Fax',
                              isSelected: selectedPhoneType == 'Fax',
                              onTap: () {
                                dialogSetState(() {
                                  selectedPhoneType = 'Fax';
                                });
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        if (scanProvider.countries == null)
                          Text(
                            'Unable to load regions',
                            style: TextStyle(color: BaseColors().primaryColor),
                          )
                        else
                          DropdownButtonFormField<String>(
  decoration: InputDecoration(
    labelText: "Card collected in",
    labelStyle: TextStyle(
      color: BaseColors().blackColor,
    ),
    prefixIcon: const Icon(Icons.public),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: BaseColors().greyColor,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: BaseColors().greyColor,
        width: 0.8,
      ),
    ),
  ),

  initialValue: scanProvider.selectedRegion?.name,

  items: scanProvider.countries!.regions?.map((region) {
    return DropdownMenuItem<String>(
      value: region.name,
      child: SizedBox(
        width: 120,
        child: Text(
          region.name ?? '',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }).toList(),

  onChanged: (value) {
    if (value != null) {
      final region = scanProvider.countries!.regions!
          .firstWhere((region) => region.name == value);

      scanProvider.setSelectedRegion(region);
    }
  },
),
                      ],
                    );
                  },
                ),
                onSave: () {},
              );
            },
          ),

          const SizedBox(height: 15),

          // EMAILS
          ...List.generate(emailControllers.length, (index) {
            final type = widget.contact.emails.length > index
                ? widget.contact.emails[index].type
                : '';

            final label = type.isNotEmpty
                ? 'Email ($type)'
                : 'Email ${index + 1}';

            return Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: _ContactEditableField(
                icon: Icons.email_outlined,
                label: label,
                controller: emailControllers[index],
                isEditing: editingEmailIndex == index,
                keyboardType: TextInputType.emailAddress,
                onEdit: () {
                  setState(() {
                    editingEmailIndex = editingEmailIndex == index
                        ? null
                        : index;
                  });
                },
              ),
            );
          }),

          // ADD EMAIL
          _AddFieldButton(
            label: 'Add Email',
            onPressed: () {
              editDialog(
                context,
                title: "Add an email",
                content: StatefulBuilder(
                  builder: (context, dialogSetState) {
                    return CustomTextField(
                      title: 'Email',
                      controller: editEmailController,
                      keyboardType: TextInputType.emailAddress,
                    );
                  },
                ),
                onSave: () {
                  // save email
                },
              );
            },
          ),

          const SizedBox(height: 15),

          // WEBSITE
          _ContactEditableField(
            icon: Icons.language,
            label: 'Website',
            controller: websiteController,
            isEditing: editingWebsite,
            keyboardType: TextInputType.url,
            onEdit: () {
              setState(() {
                editingWebsite = !editingWebsite;
              });
            },
          ),

          // ADD WEBSITE
          if (websiteController.text.isEmpty && !editingWebsite)
            _AddFieldButton(
              label: 'Add Website',
              onPressed: () {
                editDialog(
                  context,
                  title: "Add a website",
                  content: StatefulBuilder(
                    builder: (context, dialogSetState) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Kind'),

                          const SizedBox(height: 10),

                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              PhoneTypeContainer(
                                text: 'LinkedIn',
                                isSelected: selectedWebsiteKind == 'LinkedIn',
                                onTap: () {
                                  dialogSetState(() {
                                    selectedWebsiteKind = 'LinkedIn';
                                  });
                                },
                              ),

                              PhoneTypeContainer(
                                text: 'X',
                                isSelected: selectedWebsiteKind == 'X',
                                onTap: () {
                                  dialogSetState(() {
                                    selectedWebsiteKind = 'X';
                                  });
                                },
                              ),

                              PhoneTypeContainer(
                                text: 'Website',
                                isSelected: selectedWebsiteKind == 'Website',
                                onTap: () {
                                  dialogSetState(() {
                                    selectedWebsiteKind = 'Website';
                                  });
                                },
                              ),

                              PhoneTypeContainer(
                                text: 'Others',
                                isSelected: selectedWebsiteKind == 'Others',
                                onTap: () {
                                  dialogSetState(() {
                                    selectedWebsiteKind = 'Others';
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),

                          CustomTextField(
                            title: 'URL',
                            controller: editWebsiteController,
                            keyboardType: TextInputType.url,
                          ),
                        ],
                      );
                    },
                  ),
                  onSave: () {
                    // save website
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}

class _ContactEditableField extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final bool isEditing;
  final TextInputType? keyboardType;
  final VoidCallback onEdit;

  const _ContactEditableField({
    required this.icon,
    required this.label,
    required this.controller,
    required this.isEditing,
    required this.onEdit,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    if (isEditing) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(label),
                    ),
                    GestureDetector(
                      onTap: onEdit,
                      child: Row(
                        children: [
                          Icon(
                            Icons.close,
                            color: BaseColors().primaryColor,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Cancel',
                            style: TextStyle(color: BaseColors().primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                _EditField(
                  label: label,
                  controller: controller,
                  keyboardType: keyboardType,
                ),
              ],
            ),
          ),
        ],
      );
    }

    return ContactDetailItem(
      icon: icon,
      label: label,
      value: controller.text.isNotEmpty ? controller.text : "N/A",
      onEdit: onEdit,
    );
  }
}

class _AddFieldButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _AddFieldButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: onPressed,
        style: TextButton.styleFrom(padding: EdgeInsets.zero),
        icon: Icon(Icons.add, color: BaseColors().primaryColor, size: 20),
        label: Text(
          label,
          style: TextStyle(
            color: BaseColors().primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
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
