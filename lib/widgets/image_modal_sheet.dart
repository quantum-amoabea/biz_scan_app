import 'package:biz_scan_app/views/review_contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../view_models/camera_provider.dart';

void showImageSourceActionSheet(
  BuildContext context, {
  required bool isFrontImage,
}) {
  final cameraProvider = context.read<CameraProvider>();
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
                  ? await context.read<CameraProvider>().chooseFrontImage(
                      ImageSource.camera,
                    )
                  : await context.read<CameraProvider>().chooseBackImage(
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
                  ? await context.read<CameraProvider>().chooseFrontImage(
                      ImageSource.gallery,
                    )
                  : await context.read<CameraProvider>().chooseBackImage(
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
