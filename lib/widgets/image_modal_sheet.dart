import 'package:biz_scan_app/features/scan/presentation/screens/review_contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../features/scan/viewmodels/camera_viewmodel.dart';

void showImageSourceActionSheet(
  BuildContext context, {
  required bool isFrontImage,
}) {
  showModalBottomSheet(
    context: context,
    builder: (_) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera),
            title: const Text('Camera'),
            onTap: () async {
              Navigator.pop(context);

              isFrontImage
                  ? await context.read<CameraViewModel>().chooseFrontImage(
                      ImageSource.camera,
                    )
                  : await context.read<CameraViewModel>().chooseBackImage(
                      ImageSource.camera,
                    );

              if (!context.mounted) return;

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReviewContactScreen(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Gallery'),
            onTap: () async {
              Navigator.pop(context);

              isFrontImage
                  ? await context.read<CameraViewModel>().chooseFrontImage(
                      ImageSource.gallery,
                    )
                  : await context.read<CameraViewModel>().chooseBackImage(
                      ImageSource.gallery,
                    );

              if (!context.mounted) return;

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReviewContactScreen(),
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}
