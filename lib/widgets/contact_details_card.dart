import 'package:biz_scan_app/core/colors.dart';
import 'package:biz_scan_app/features/contact/contact.dart';
import 'package:biz_scan_app/features/contact/domain/models/update_email.dart';
import 'package:biz_scan_app/features/contact/domain/models/update_phone.dart';
import 'package:biz_scan_app/features/scan/domain/models/regions.dart';
import 'package:biz_scan_app/widgets/add_field_button.dart';
import 'package:biz_scan_app/widgets/contact_editable_field.dart';
import 'package:biz_scan_app/widgets/custom_textfield.dart';
import 'package:biz_scan_app/widgets/delete_dialog.dart';
import 'package:biz_scan_app/widgets/edit_dialog.dart';
import 'package:biz_scan_app/widgets/phone_label.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/scan/viewmodels/scan_viewmodel.dart';

class ContactDetailsCard extends StatefulWidget {
  final Items contact;

  const ContactDetailsCard({super.key, required this.contact});

  @override
  State<ContactDetailsCard> createState() => _ContactDetailsCardState();
}

class _ContactDetailsCardState extends State<ContactDetailsCard> {
  int? editingPhoneIndex;
  int? editingEmailIndex;
  bool editingWebsite = false;

  String selectedPhoneType = 'home';
  String selectedWebsiteKind = 'Website';

  late List<TextEditingController> phoneControllers;
  late List<TextEditingController> emailControllers;
  late List<TextEditingController> websiteControllers;
  late List<TextEditingController> addressControllers;

  final TextEditingController editPhoneController = TextEditingController();
  final TextEditingController editWebsiteController = TextEditingController();
  final TextEditingController editEmailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final contactProvider = context.read<ContactsViewModel>();

    if (!contactProvider.contacts.any((c) => c.id == widget.contact.id)) {
      contactProvider.contacts.add(widget.contact);
    }

    phoneControllers = (widget.contact.phones ?? [])
        .map(
          (phone) => TextEditingController(
            text: phone.raw ?? phone.display ?? phone.e164 ?? '',
          ),
        )
        .toList();

    emailControllers = (widget.contact.emails ?? [])
        .map((email) => TextEditingController(text: email.email ?? ''))
        .toList();

    websiteControllers = (widget.contact.socials ?? [])
        .map((social) => TextEditingController(text: social.url ?? ''))
        .toList();

    addressControllers = (widget.contact.addresses ?? [])
        .map(
          (address) =>
              TextEditingController(text: "${address.raw}, ${address.country}"),
        )
        .toList();
  }

  void _syncPhoneControllers(Items contact) {
    final phones = contact.phones ?? [];

    while (phoneControllers.length > phones.length) {
      phoneControllers.removeLast().dispose();
    }

    while (phoneControllers.length < phones.length) {
      phoneControllers.add(TextEditingController());
    }

    for (var i = 0; i < phones.length; i++) {
      final text = phones[i].raw ?? phones[i].display ?? phones[i].e164 ?? '';

      if (phoneControllers[i].text != text) {
        phoneControllers[i].value = TextEditingValue(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
        );
      }
    }
  }

  void _syncEmailControllers(Items contact) {
    final emails = contact.emails ?? [];

    while (emailControllers.length > emails.length) {
      emailControllers.removeLast().dispose();
    }

    while (emailControllers.length < emails.length) {
      emailControllers.add(TextEditingController());
    }

    for (var i = 0; i < emails.length; i++) {
      final text = emails[i].email ?? '';

      if (emailControllers[i].text != text) {
        emailControllers[i].value = TextEditingValue(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
        );
      }
    }
  }

  void _syncWebsiteControllers(Items contact) {
    final socials = contact.socials ?? [];

    while (websiteControllers.length > socials.length) {
      websiteControllers.removeLast().dispose();
    }

    while (websiteControllers.length < socials.length) {
      websiteControllers.add(TextEditingController());
    }

    for (var i = 0; i < socials.length; i++) {
      final text = socials[i].url ?? '';

      if (websiteControllers[i].text != text) {
        websiteControllers[i].value = TextEditingValue(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
        );
      }
    }
  }

  void _syncAddressControllers(Items contact) {
    final addresses = contact.addresses ?? [];

    while (addressControllers.length > addresses.length) {
      addressControllers.removeLast().dispose();
    }

    while (addressControllers.length < addresses.length) {
      addressControllers.add(TextEditingController());
    }

    for (var i = 0; i < addresses.length; i++) {
      final text = addresses[i].raw ?? '';

      if (addressControllers[i].text != text) {
        addressControllers[i].value = TextEditingValue(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
        );
      }
    }
  }

  @override
  void didUpdateWidget(covariant ContactDetailsCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    final contactProvider = context.read<ContactsViewModel>();

    final currentContact = contactProvider.contacts.firstWhere(
      (c) => c.id == widget.contact.id,
      orElse: () => widget.contact,
    );

    _syncPhoneControllers(currentContact);
    _syncEmailControllers(currentContact);
    _syncWebsiteControllers(currentContact);
    _syncAddressControllers(currentContact);
  }

  @override
  void dispose() {
    for (final controller in phoneControllers) {
      controller.dispose();
    }

    for (final controller in emailControllers) {
      controller.dispose();
    }

    editPhoneController.dispose();
    editWebsiteController.dispose();
    editEmailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scanProvider = context.watch<ScanViewModel>();
    final contactProvider = context.watch<ContactsViewModel>();

    final currentContact = contactProvider.contacts.firstWhere(
      (c) => c.id == widget.contact.id,
      orElse: () => widget.contact,
    );

    _syncPhoneControllers(currentContact);
    _syncEmailControllers(currentContact);
    _syncWebsiteControllers(currentContact);
    _syncAddressControllers(currentContact);

    final phones = currentContact.phones ?? [];
    final emails = currentContact.emails ?? [];

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CONTACT DETAILS',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 15),

          ...List.generate(phones.length, (index) {
            final phone = phones[index];

            final type = phone.type ?? '';

            final label = type.isNotEmpty
                ? 'Phone ($type)'
                : 'Phone ${index + 1}';

            return ContactEditableField(
              icon: Icons.phone,
              label: label,
              controller: phoneControllers[index],
              isEditing: editingPhoneIndex == index,
              keyboardType: TextInputType.phone,
              onEdit: () {
                final phone = phones[index];

                editPhoneController.text =
                    phone.raw ?? phone.display ?? phone.e164 ?? '';

                selectedPhoneType = (phone.type ?? 'home').toLowerCase();

                final regions = scanProvider.countries?.regions;

                if (regions != null &&
                    phone.parsedRegion != null &&
                    phone.parsedRegion!.isNotEmpty) {
                  final matchingRegion = regions.firstWhere(
                    (region) =>
                        region.code?.toLowerCase() ==
                        phone.parsedRegion!.toLowerCase(),
                    orElse: () => Regions(),
                  );

                  if (matchingRegion.code != null &&
                      matchingRegion.code!.isNotEmpty) {
                    scanProvider.setSelectedRegion(matchingRegion);
                  }
                }

                editDialog(
                  context,
                  title: 'Update number',
                  content: StatefulBuilder(
                    builder: (context, dialogSetState) {
                      final availableRegions =
                          scanProvider.countries?.regions ?? [];

                      final selectedRegion = scanProvider.selectedRegion;

                      final validSelectedRegion =
                          availableRegions.any(
                            (region) => region.name == selectedRegion?.name,
                          )
                          ? selectedRegion?.name
                          : null;

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
                                text: 'home',
                                isSelected: selectedPhoneType == 'home',
                                onTap: () {
                                  dialogSetState(() {
                                    selectedPhoneType = 'home';
                                  });
                                },
                              ),
                              PhoneTypeContainer(
                                text: 'work',
                                isSelected: selectedPhoneType == 'work',
                                onTap: () {
                                  dialogSetState(() {
                                    selectedPhoneType = 'work';
                                  });
                                },
                              ),
                              PhoneTypeContainer(
                                text: 'mobile',
                                isSelected: selectedPhoneType == 'mobile',
                                onTap: () {
                                  dialogSetState(() {
                                    selectedPhoneType = 'mobile';
                                  });
                                },
                              ),
                              PhoneTypeContainer(
                                text: 'fax',
                                isSelected: selectedPhoneType == 'fax',
                                onTap: () {
                                  dialogSetState(() {
                                    selectedPhoneType = 'fax';
                                  });
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          if (scanProvider.countries == null)
                            Text(
                              'Unable to load regions',
                              style: TextStyle(
                                color: BaseColors().primaryColor,
                              ),
                            )
                          else
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Card collected in',
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
                              initialValue: validSelectedRegion,
                              items: availableRegions.map((region) {
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
                                if (value == null) {
                                  return;
                                }

                                final region = availableRegions.firstWhere(
                                  (region) => region.name == value,
                                );

                                scanProvider.setSelectedRegion(region);

                                dialogSetState(() {});
                              },
                            ),
                        ],
                      );
                    },
                  ),
                  onSave: () async {
                    final phoneId = phone.id;
                    final contactId = widget.contact.id;

                    if (phoneId == null || phoneId.isEmpty) {
                      return;
                    }

                    if (contactId == null || contactId.isEmpty) {
                      return;
                    }

                    final selectedRegion = scanProvider.selectedRegion;

                    if (selectedRegion == null ||
                        selectedRegion.code == null ||
                        selectedRegion.code!.isEmpty) {
                      return;
                    }

                    final number = editPhoneController.text.trim();

                    if (number.isEmpty) {
                      return;
                    }

                    final updatePhone = UpdatePhone(
                      raw: number,
                      type: selectedPhoneType,
                      isPrimary: phone.isPrimary ?? false,
                      region: selectedRegion.code,
                    );

                    await contactProvider.updatePhone(
                      contactId,
                      phoneId,
                      updatePhone,
                    );

                    if (!mounted) {
                      return;
                    }

                    setState(() {
                      editingPhoneIndex = null;
                    });

                    Navigator.pop(context);
                  },
                );
              },
              onDelete: () {
                final phoneId = phone.id;

                if (phoneId == null || phoneId.isEmpty) {
                  return;
                }

                showDeleteDialog(
                  context,
                  title: 'Delete Number',
                  content: const Text(
                    'Are you sure you want to delete this number? '
                    'This action cannot be undone.',
                  ),
                  onConfirm: () async {
                    Navigator.pop(context);

                    final contactId = widget.contact.id;

                    if (contactId == null || contactId.isEmpty) {
                      return;
                    }

                    await contactProvider.deletePhone(contactId, phoneId);
                  },
                );
              },
            );
          }),

          AddFieldButton(
            label: 'Add Phone',
            onPressed: () {
              editPhoneController.clear();
              selectedPhoneType = 'home';

              editDialog(
                context,
                title: 'Add a number',
                content: StatefulBuilder(
                  builder: (context, dialogSetState) {
                    final regions = scanProvider.countries?.regions ?? [];

                    final selectedRegion = scanProvider.selectedRegion;

                    final validSelectedRegion =
                        regions.any(
                          (region) => region.name == selectedRegion?.name,
                        )
                        ? selectedRegion?.name
                        : null;

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
                              text: 'home',
                              isSelected: selectedPhoneType == 'home',
                              onTap: () {
                                dialogSetState(() {
                                  selectedPhoneType = 'home';
                                });
                              },
                            ),
                            PhoneTypeContainer(
                              text: 'work',
                              isSelected: selectedPhoneType == 'work',
                              onTap: () {
                                dialogSetState(() {
                                  selectedPhoneType = 'work';
                                });
                              },
                            ),
                            PhoneTypeContainer(
                              text: 'mobile',
                              isSelected: selectedPhoneType == 'mobile',
                              onTap: () {
                                dialogSetState(() {
                                  selectedPhoneType = 'mobile';
                                });
                              },
                            ),
                            PhoneTypeContainer(
                              text: 'fax',
                              isSelected: selectedPhoneType == 'fax',
                              onTap: () {
                                dialogSetState(() {
                                  selectedPhoneType = 'fax';
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
                              labelText: 'Card collected in',
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
                            initialValue: validSelectedRegion,
                            items: regions.map((region) {
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
                              if (value == null) {
                                return;
                              }

                              final region = regions.firstWhere(
                                (region) => region.name == value,
                              );

                              scanProvider.setSelectedRegion(region);

                              dialogSetState(() {});
                            },
                          ),
                      ],
                    );
                  },
                ),
                onSave: contactProvider.isSavingContactDetails
                    ? () {}
                    : () async {
                        final contactId = widget.contact.id;

                        if (contactId == null || contactId.isEmpty) {
                          return;
                        }

                        final selectedRegion = scanProvider.selectedRegion;

                        if (selectedRegion == null ||
                            selectedRegion.code == null ||
                            selectedRegion.code!.isEmpty) {
                          return;
                        }

                        final number = editPhoneController.text.trim();

                        if (number.isEmpty) {
                          return;
                        }

                        final phonePayload = UpdatePhone(
                          raw: number,
                          type: selectedPhoneType,
                          isPrimary: false,
                          region: selectedRegion.code,
                        );

                        await contactProvider.addPhone(contactId, phonePayload);

                        if (!mounted) {
                          return;
                        }

                        setState(() {});

                        Navigator.pop(context);
                      },
              );
            },
          ),

          const SizedBox(height: 15),

          ...List.generate(emailControllers.length, (index) {
            final email = emails[index];

            final type = email.type ?? '';

            final label = type.isNotEmpty
                ? 'Email ($type)'
                : 'Email ${index + 1}';

            return Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: ContactEditableField(
                icon: Icons.email_outlined,
                label: label,
                controller: emailControllers[index],
                isEditing: editingEmailIndex == index,
                keyboardType: TextInputType.emailAddress,
                onEdit: () {
                  editEmailController.text = email.email ?? "";

                  editDialog(
                    context,
                    title: 'Edit Email',
                    content: CustomTextField(
                      controller: editEmailController,
                      title: 'Email',
                    ),
                    onSave: () async {
                      final emailId = email.id;
                      final contactId = widget.contact.id;

                      if (emailId == null || emailId.isEmpty) {
                        return;
                      }

                      if (contactId == null || contactId.isEmpty) {
                        return;
                      }

                      final newEmail = editEmailController.text.trim();

                      if (newEmail.isEmpty) {
                        return;
                      }

                      final updateEmail = UpdateEmail(email: newEmail);

                      await contactProvider.updateEmail(
                        contactId,
                        emailId,
                        updateEmail,
                      );

                      if (!mounted) {
                        return;
                      }

                      setState(() {
                        editingPhoneIndex = null;
                      });

                      Navigator.pop(context);
                    },
                  );
                },
                onDelete: () {
                  final emailId = email.id;

                  if (emailId == null || emailId.isEmpty) {
                    return;
                  }

                  showDeleteDialog(
                    context,
                    title: 'Delete Number',
                    content: const Text(
                      'Are you sure you want to delete this email? '
                      'This action cannot be undone.',
                    ),
                    onConfirm: () async {
                      Navigator.pop(context);

                      final contactId = widget.contact.id;

                      if (contactId == null || contactId.isEmpty) {
                        return;
                      }

                      await contactProvider.deleteEmail(contactId, emailId);
                    },
                  );
                },
              ),
            );
          }),

          AddFieldButton(
            label: 'Add Email',
            onPressed: () {
              editEmailController.clear();

              editDialog(
                context,
                title: 'Add an email',
                content: CustomTextField(
                  title: 'Email',
                  controller: editEmailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                onSave: contactProvider.isSavingContactDetails
                    ? () {}
                    : () async {
                        final contactId = widget.contact.id;

                        if (contactId == null || contactId.isEmpty) {
                          return;
                        }

                        final email = editEmailController.text.trim();

                        if (email.isEmpty){
                          return;
                        }

                        final emailPayload = UpdateEmail(email: email);

                        await contactProvider.addEmail(contactId, emailPayload);

                        if (!mounted) {
                          return;
                        }

                        setState(() {});

                        Navigator.pop(context);
                      },
              );
            },
          ),

          const SizedBox(height: 15),

          ...List.generate(currentContact.socials?.length ?? 0, (index) {
            final social = currentContact.socials![index];

            final type = social.platform ?? '';

            final label = type.isNotEmpty ? type : 'Website ${index + 1}';

            return Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: ContactEditableField(
                icon: Icons.language,
                label: label,
                controller: websiteControllers[index],
                isEditing: editingWebsite,
                keyboardType: TextInputType.url,
                onEdit: () {},
                onDelete: () {},
              ),
            );
          }),

          AddFieldButton(
            label: 'Add a link',
            onPressed: () {
              editWebsiteController.clear();
              selectedWebsiteKind = 'Website';

              editDialog(
                context,
                title: 'Add a link',
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
                  final contactId = widget.contact.id;

                  if (contactId == null || contactId.isEmpty) {
                    return;
                  }


                },
              );
            },
          ),

          ...List.generate(currentContact.addresses?.length ?? 0, (index) {
            final address = currentContact.addresses![index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: ContactEditableField(
                icon: Icons.location_on,
                label: 'Address ${index + 1}',
                controller: addressControllers[index],
                isEditing: false,
                keyboardType: TextInputType.streetAddress,
                onEdit: () {},
                onDelete: () {},
              ),
            );
          }),

          AddFieldButton(
            label: 'Add Address',
            onPressed: () {
              editWebsiteController.clear();
              selectedWebsiteKind = 'Website';

              editDialog(
                context,
                title: 'Add Address',
                content: StatefulBuilder(
                  builder: (context, dialogSetState) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          title: 'Address',
                          controller: editWebsiteController,
                          keyboardType: TextInputType.url,
                        ),
                      ],
                    );
                  },
                ),
                onSave: () {},
              );
            },
          ),
        ],
      ),
    );
  }
}
