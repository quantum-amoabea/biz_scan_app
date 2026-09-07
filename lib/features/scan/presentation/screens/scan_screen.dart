import 'package:biz_scan_app/core/colors.dart';
import 'package:biz_scan_app/features/scan/viewmodels/camera_viewmodel.dart';
import 'package:biz_scan_app/features/scan/viewmodels/scan_viewmodel.dart';
import 'package:biz_scan_app/widgets/custom_app_bar.dart';
import 'package:biz_scan_app/widgets/custom_textbutton.dart';
import 'package:biz_scan_app/widgets/image_modal_sheet.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cameraProvider = context.read<CameraViewModel>();
    final scanProvider = context.read<ScanViewModel>();
    return Scaffold(
      backgroundColor: BaseColors().whiteColor,
      appBar: CustomAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: SizedBox(
            width: double.infinity,
            height: 300,
            child: DottedBorder(
              options: RoundedRectDottedBorderOptions(
                dashPattern: [10, 5],
                color: BaseColors().primaryColor,
                strokeWidth: 1.5,
                padding: EdgeInsets.all(16),
                radius: Radius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.cloud_upload,
                        size: 70,
                        color: BaseColors().primaryColor,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Upload or Snap Photo',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Choose a photo from your gallery or take one with your camera",
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),

                      CustomTextButton(
                        text: "Choose a photo",
                        borderRadius: 30,
                        onPressed: () {
                          cameraProvider.clearAllImages();
                          scanProvider.resetScan();
                          showImageSourceActionSheet(
                            context,
                            isFrontImage: true,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
