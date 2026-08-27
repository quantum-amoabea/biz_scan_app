import 'dart:io';

import 'package:biz_scan_app/core/colors.dart';
import 'package:biz_scan_app/core/toast_message.dart';
import 'package:biz_scan_app/services/contact_services.dart';
import 'package:biz_scan_app/utils/utils.dart';
import 'package:biz_scan_app/view_models/camera_provider.dart';
import 'package:biz_scan_app/widgets/custom_app_bar.dart';
import 'package:biz_scan_app/widgets/custom_textbutton.dart';
import 'package:biz_scan_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../utils/pop_menu_selector.dart';

class ContactDetailsScreen extends StatelessWidget {
  const ContactDetailsScreen({super.key});

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

  final nameController = TextEditingController(text: 'ASHISH Nyame');

  final jobTitleController = TextEditingController(
    text: 'AVP-BUSINESS EVANGELIST',
  );

  final companyController = TextEditingController(
    text: 'Protectt.ai.Labs Pvt.Ltd',
  );

  final industryController = TextEditingController(text: 'Technology');

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
          // Header
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
            const ContactDetailItem(
              icon: Icons.person,
              label: 'Full Name',
              value: 'ASHISH Nyame',
            ),

            const SizedBox(height: 15),

            const ContactDetailItem(
              icon: Icons.work,
              label: 'Job Title',
              value: 'AVP-BUSINESS EVANGELIST',
            ),

            const SizedBox(height: 15),

            const ContactDetailItem(
              icon: Icons.business,
              label: 'Company',
              value: 'Protectt.ai.Labs Pvt.Ltd',
            ),

            const SizedBox(height: 15),

            const ContactDetailItem(
              icon: Icons.business_outlined,
              label: 'Industry',
              value: 'Technology',
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
      children: [
        Icon(icon),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label),
            Row(
              children: [
                Text(value, style: TextStyle(fontWeight: FontWeight.w500)),
                IconButton(
                  color: BaseColors().greyColor,
                  iconSize: 17,
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: value));
                    showToast(message: "Copied to Clipboard");
                  },
                  icon: Icon(Icons.copy),
                ),
              ],
            ),
          ],
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

  final phoneController = TextEditingController(text: '+233 20 000 0000');

  final emailController = TextEditingController(text: 'ashish@example.com');

  final websiteController = TextEditingController(text: 'https://protectt.com');

  @override
  void dispose() {
    phoneController.dispose();
    emailController.dispose();
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
            _EditField(
              label: 'Phone',
              controller: phoneController,
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 15),

            _EditField(
              label: 'Email',
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 15),

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
            const ContactDetailItem(
              icon: Icons.phone_outlined,
              label: 'Phone',
              value: '+233 20 000 0000',
            ),

            const SizedBox(height: 15),

            const ContactDetailItem(
              icon: Icons.email_outlined,
              label: 'Email',
              value: 'ashish@example.com',
            ),

            const SizedBox(height: 15),

            const ContactDetailItem(
              icon: Icons.web,
              label: 'Website',
              value: 'https://protectt.com',
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
