import 'dart:io';

import 'package:biz_scan_app/models/scan_card.dart';
import 'package:biz_scan_app/view_models/camera_provider.dart';
import 'package:biz_scan_app/view_models/scan_provider.dart';
import 'package:biz_scan_app/views/contact_details_screen.dart';
import 'package:biz_scan_app/widgets/custom_app_bar.dart';
import 'package:biz_scan_app/widgets/custom_textbutton.dart';
import 'package:biz_scan_app/widgets/image_modal_sheet.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../core/colors.dart';
import '../models/regions.dart';
import 'nav_bar.dart';

class ReviewContactScreen extends StatefulWidget {
  const ReviewContactScreen({super.key});

  @override
  State<ReviewContactScreen> createState() => _ReviewContactScreenState();
}

class _ReviewContactScreenState extends State<ReviewContactScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final scanProvider = context.read<ScanProvider>();

      scanProvider.getCountries();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cameraProvider = context.watch<CameraProvider>();
    final scanProvider = context.watch<ScanProvider>();

    final readCameraProvider = context.read<CameraProvider>();

    return Scaffold(
      appBar: const CustomAppBar(),

      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _BusinessCardImage(
                      image: cameraProvider.frontImage,
                      label: 'Front',
                      showRemove: true,
                      onRemove: () {
                        context.read<CameraProvider>().clearAllImages();

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NavBar(initialIndex: 1),
                          ),
                          (route) => false,
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    if (cameraProvider.backImage == null) ...[
                      IconButton(
                        onPressed: () {
                          showImageSourceActionSheet(
                            context,
                            isFrontImage: false,
                          );
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
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
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

                    if (scanProvider.countries == null)
                      Text(
                        'Unable to load regions',
                        style: TextStyle(color: BaseColors().primaryColor),
                      )
                    else
                      DropdownButtonFormField<Regions>(
                        decoration: InputDecoration(
                          labelText: "Card collected in",
                          labelStyle: TextStyle(color: BaseColors().blackColor),
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

                        initialValue: scanProvider.selectedRegion,

                        items: scanProvider.countries!.regions?.map((region) {
                          return DropdownMenuItem<Regions>(
                            value: region,
                            child: Text(region.name ?? ''),
                          );
                        }).toList(),

                        onChanged: (value) {
                          scanProvider.setSelectedRegion(value!);
                        },
                      ),

                    const SizedBox(height: 20),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomTextButton(
                          text: 'Scan',
                          borderRadius: 30,
                          isLoading: context.watch<ScanProvider>().isScanning,
                          onPressed: () async {
                            if (readCameraProvider.frontImage == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please capture the front of the card',
                                  ),
                                ),
                              );
                              return;
                            }

                            if (scanProvider.selectedRegion == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please select where the card was collected',
                                  ),
                                ),
                              );
                              return;
                            }

                            final scanCard = ScanCard(
                              frontImage: readCameraProvider.frontImage!.path,

                              backImage: readCameraProvider.backImage?.path,
                              region: scanProvider.selectedRegion?.code ?? '',
                            );

                            bool isProcessed = await scanProvider.processCard(
                              scanCard,
                            );

                            if (isProcessed) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ContactDetailsScreen(),
                                ),
                              );
                            }
                          },
                        ),

                        const SizedBox(height: 20),

                        CustomTextButton(
                          text: 'Cancel',
                          onPressed: () {
                            cameraProvider.removeBackImage();
                          },
                          backgroundColor: Colors.transparent,
                          foregroundColor: BaseColors().primaryColor,
                          borderRadius: 30,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (context.watch<ScanProvider>().isScanning)
                Positioned.fill(
                  child: Container(color: Colors.black.withValues(alpha: 0.5)),
                ),
            ],
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
