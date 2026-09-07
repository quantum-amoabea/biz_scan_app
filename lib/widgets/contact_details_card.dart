import 'package:biz_scan_app/core/colors.dart';
import 'package:biz_scan_app/widgets/custom_textfield.dart';
import 'package:biz_scan_app/widgets/edit_dialog.dart';
import 'package:biz_scan_app/widgets/phone_label.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/contacts_details.dart';
import '../view_models/scan_provider.dart';
import 'add_field_button.dart';
import 'contact_editable_field.dart';

class ContactDetailsCard extends StatefulWidget {
  final ContactDetails contact;

  const ContactDetailsCard({super.key, required this.contact});

  @override
  State<ContactDetailsCard> createState() => _ContactDetailsCardState();
}

class _ContactDetailsCardState extends State<ContactDetailsCard> {
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
          const Text(
            'CONTACT DETAILS',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 15),
          ...List.generate(phoneControllers.length, (index) {
            final type = widget.contact.phones.length > index
                ? widget.contact.phones[index].type
                : '';
            final label = type.isNotEmpty ? 'Phone ($type)' : 'Phone ${index + 1}';
            return ContactEditableField(
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
          AddFieldButton(
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
                            items: scanProvider.countries!.regions?.map(
                              (region) {
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
                              },
                            ).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                final region = scanProvider.countries!.regions!
                                    .firstWhere(
                                      (region) => region.name == value,
                                    );
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
          ...List.generate(emailControllers.length, (index) {
            final type = widget.contact.emails.length > index
                ? widget.contact.emails[index].type
                : '';
            final label = type.isNotEmpty ? 'Email ($type)' : 'Email ${index + 1}';
            return Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: ContactEditableField(
                icon: Icons.email_outlined,
                label: label,
                controller: emailControllers[index],
                isEditing: editingEmailIndex == index,
                keyboardType: TextInputType.emailAddress,
                onEdit: () {
                  setState(() {
                    editingEmailIndex = editingEmailIndex == index ? null : index;
                  });
                },
              ),
            );
          }),
          AddFieldButton(
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
          ContactEditableField(
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
          if (websiteController.text.isEmpty && !editingWebsite)
            AddFieldButton(
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
                                isSelected:
                                    selectedWebsiteKind == 'LinkedIn',
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
                                isSelected:
                                    selectedWebsiteKind == 'Website',
                                onTap: () {
                                  dialogSetState(() {
                                    selectedWebsiteKind = 'Website';
                                  });
                                },
                              ),
                              PhoneTypeContainer(
                                text: 'Others',
                                isSelected:
                                    selectedWebsiteKind == 'Others',
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