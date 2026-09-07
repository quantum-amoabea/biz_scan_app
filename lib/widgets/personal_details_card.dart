import 'package:biz_scan_app/core/colors.dart';
import 'package:biz_scan_app/widgets/contact_detail_item.dart';
import 'package:biz_scan_app/widgets/edit_field.dart';
import 'package:flutter/material.dart';

import '../models/contacts_details.dart';

class PersonalDetailsCard extends StatefulWidget {
  final ContactDetails contact;

  const PersonalDetailsCard({super.key, required this.contact});

  @override
  State<PersonalDetailsCard> createState() => _PersonalDetailsCardState();
}

class _PersonalDetailsCardState extends State<PersonalDetailsCard> {
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
          const Text(
            'PERSONAL DETAILS',
            style: TextStyle(fontWeight: FontWeight.w600),
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
                EditField(label: label, controller: controller),
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