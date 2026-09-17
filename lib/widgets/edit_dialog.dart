import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/colors.dart';
import '../features/contact/viewmodels/contacts_viewmodel.dart';

void editDialog(
  BuildContext context, {
  required String title,
  required Widget content,
  required VoidCallback onSave,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return Consumer<ContactsViewModel>(
        builder: (context, provider, _) {
          final isSaving = provider.isSavingContactDetails;

          return AlertDialog(
            backgroundColor: BaseColors().whiteColor,
            title: Text(
              title,
              style: TextStyle(color: BaseColors().primaryColor),
            ),
            content: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              child: SingleChildScrollView(
                child: content,
              ),
            ),
            actions: [
              TextButton(
                onPressed: isSaving
                    ? null
                    : () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: BaseColors().primaryColor,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: BaseColors().primaryColor,
                  foregroundColor: BaseColors().whiteColor,
                ),
                onPressed: isSaving ? null : onSave,
                child: isSaving
                    ?  SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: BaseColors().whiteColor,
                        ),
                      )
                    : const Text('Save'),
              ),
            ],
          );
        },
      );
    },
  );
}