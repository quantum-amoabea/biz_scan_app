import 'dart:io';

import 'package:biz_scan_app/view_models/camera_provider.dart';
import 'package:biz_scan_app/views/contact_details_screen.dart';
import 'package:biz_scan_app/widgets/custom_app_bar.dart';
import 'package:biz_scan_app/widgets/custom_textbutton.dart';
import 'package:biz_scan_app/widgets/image_modal_sheet.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../core/colors.dart';
import 'nav_bar.dart';

class ReviewContactScreen extends StatelessWidget {
  const ReviewContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cameraProvider = context.watch<CameraProvider>();
    String? selectedCountry;
    final countries = ['Ghana', 'Kenya', 'Sudan'];

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // FRONT
                _BusinessCardImage(
                  image: cameraProvider.frontImage,
                  label: 'Front',
                  showRemove: true,
                  onRemove: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NavBar(initialIndex: 1),
                      ),
                      (route) => false,
                    );
                    context.read<CameraProvider>().clearAllImages();
                  },
                ),

                const SizedBox(height: 20),

                // BACK
                if (cameraProvider.backImage == null) ...[
                  IconButton(
                    onPressed: () {
                      showImageSourceActionSheet(context, isFrontImage: false);
                    },
                    icon: const Icon(Icons.add),
                    style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: BaseColors().lightPrimaryColor,
                      foregroundColor: BaseColors().primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),

                  const Text(
                    'Add the back of the card if it has one',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                  ),
                ] else
                  _BusinessCardImage(
                    image: cameraProvider.backImage,
                    label: 'Back',
                    showRemove: true,
                    onRemove: () {
                      cameraProvider.removeBackImage();
                    },
                  ),

                const SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Card collected in",
                    labelStyle: TextStyle(color: BaseColors().blackColor),
                    prefixIcon: Icon(Icons.public),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:  BorderSide(color: BaseColors().greyColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:  BorderSide(
                        color: BaseColors().greyColor,
                        width: 0.8,
                      ),
                    ),
                  ),
                  initialValue: selectedCountry,
                  items: countries.map((auth) {
                    return DropdownMenuItem(value: auth, child: Text(auth));
                  }).toList(),
                  onChanged: (value) {

                  },
                ),

                const SizedBox(height: 20),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextButton(
                      text: 'scan',
                      borderRadius: 30,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContactDetailsScreen(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    CustomTextButton(
                      text: 'cancel',
                      onPressed: () => cameraProvider.removeBackImage(),
                      backgroundColor: Colors.transparent,
                      foregroundColor: BaseColors().primaryColor,
                      borderRadius: 30,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BusinessCardImage extends StatelessWidget {
  final XFile? image;
  final String label;
  final bool showRemove;
  final VoidCallback? onRemove;

  const _BusinessCardImage({
    required this.image,
    required this.label,
    this.showRemove = false,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 400,
      decoration: BoxDecoration(
        color: BaseColors().lightGreyColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(File(image!.path), fit: BoxFit.cover),
                  )
                : Icon(
                    Icons.image_outlined,
                    size: 70,
                    color: BaseColors().greyColor,
                  ),
          ),

          // Front / Back label
          Positioned(
            top: 15,
            left: 15,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: BaseColors().blackColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: BaseColors().whiteColor,
                ),
              ),
            ),
          ),

          // Remove button
          if (showRemove)
            Positioned(
              top: 5,
              right: 15,
              child: IconButton(
                onPressed: onRemove,
                icon: Icon(Icons.close, color: BaseColors().whiteColor),
                style: IconButton.styleFrom(
                  backgroundColor: BaseColors().primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
