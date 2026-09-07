import 'package:biz_scan_app/core/colors.dart';
import 'package:biz_scan_app/widgets/contact_detail_item.dart';
import 'package:biz_scan_app/widgets/edit_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/contact/viewmodels/personal_details_viewmodel.dart';

class PersonalDetailsCard extends StatelessWidget {
  final PersonalDetailsViewModel viewModel;

  const PersonalDetailsCard({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return _PersonalDetailsCardContent(viewModel: viewModel);
  }
}

class _PersonalDetailsCardContent extends StatelessWidget {
  final PersonalDetailsViewModel viewModel;

  const _PersonalDetailsCardContent({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: _PersonalDetailsCardContentBody(),
    );
  }
}

class _PersonalDetailsCardContentBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PersonalDetailsViewModel>();

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'PERSONAL DETAILS',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              GestureDetector(
                onTap: viewModel.isSaving ? null : viewModel.toggleEdit,
                child: Row(
                  children: [
                    Icon(
                      viewModel.isEditing ? Icons.cancel : Icons.edit,
                      color: BaseColors().primaryColor,
                      size: 18,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      viewModel.isEditing ? 'Cancel' : 'Edit',
                      style: TextStyle(color: BaseColors().primaryColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _Field(
            label: 'Full Name',
            icon: Icons.person,
            controller: viewModel.nameController,
            isEditing: viewModel.isEditing,
            error: viewModel.nameError,
          ),
          const SizedBox(height: 15),
          _Field(
            label: 'Job Title',
            icon: Icons.work,
            controller: viewModel.jobTitleController,
            isEditing: viewModel.isEditing,
          ),
          const SizedBox(height: 15),
          _Field(
            label: 'Company',
            icon: Icons.business,
            controller: viewModel.companyController,
            isEditing: viewModel.isEditing,
          ),
          const SizedBox(height: 15),
          _IndustryField(
            icon: Icons.business_outlined,
            isEditing: viewModel.isEditing,
            viewModel: viewModel,
          ),
          if (viewModel.isEditing) ...[
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: viewModel.isSaving ? null : viewModel.save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: BaseColors().primaryColor,
                  foregroundColor: BaseColors().whiteColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: viewModel.isSaving
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(BaseColors().whiteColor),
                        ),
                      )
                    : const Text('Save Changes'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final bool isEditing;
  final String? error;

  const _Field({
    required this.label,
    required this.icon,
    required this.controller,
    required this.isEditing,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    if (isEditing) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EditField(label: label, controller: controller),
          if (error != null) ...[
            const SizedBox(height: 4),
            Text(
              error!,
              style:  TextStyle(color: BaseColors().primaryColor, fontSize: 12),
            ),
          ],
        ],
      );
    }

    return ContactDetailItem(
      icon: icon,
      label: label,
      value: controller.text.isNotEmpty ? controller.text : "N/A",
    );
  }
}

class _IndustryField extends StatelessWidget {
  final IconData icon;
  final bool isEditing;
  final PersonalDetailsViewModel viewModel;

  const _IndustryField({
    required this.icon,
    required this.isEditing,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    if (isEditing) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Industry',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: BaseColors().greyColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                dropdownColor: BaseColors().whiteColor,
                value: viewModel.selectedIndustryCode?.isEmpty == true
                    ? null
                    : viewModel.selectedIndustryCode,
                isExpanded: true,
                hint: const Text('Select industry'),
                items: viewModel.industries
                    .where((i) => i.code.isNotEmpty)
                    .map((industry) {
                  return DropdownMenuItem<String>(
                    value: industry.code,
                    child: Text(
                      industry.fullName.isNotEmpty ? industry.fullName : industry.name,
                      style: TextStyle(fontWeight: FontWeight.w400),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: viewModel.industries.isEmpty
                    ? null
                    : (value) => viewModel.onIndustryChanged(value),
                icon: const Icon(Icons.arrow_drop_down),
              ),
            ),
          ),
        ],
      );
    }

    return ContactDetailItem(
      icon: icon,
      label: 'Industry',
      value: viewModel.selectedIndustryDisplay.isNotEmpty
          ? viewModel.selectedIndustryDisplay
          : "N/A",
    );
  }
}