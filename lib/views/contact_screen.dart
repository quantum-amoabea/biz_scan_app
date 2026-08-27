import 'dart:io';

import 'package:biz_scan_app/core/colors.dart';
import 'package:biz_scan_app/view_models/camera_provider.dart';
import 'package:biz_scan_app/views/contact_details_screen.dart';
import 'package:biz_scan_app/widgets/custom_app_bar.dart';
import 'package:biz_scan_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: BaseColors().whiteColor,
        appBar: const CustomAppBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Contacts",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.file_download),
                        const SizedBox(width: 3),
                        const Text('Export'),
                      ],
                    ),
                  ],
                ),
          
                // Search
                const CustomTextField(
                  suffixIcon: Icon(Icons.search),
                  hintText: "Search names, companies, job titles",
                ),
          
                // Tabs
                TabBar(
                  labelColor: BaseColors().primaryColor,
                  unselectedLabelColor: BaseColors().greyColor,
                  indicatorColor: BaseColors().primaryColor,
                  indicatorWeight: 2,
                  tabs: const [
                    Tab(text: 'Mine'),
                    Tab(text: 'Shared with Me'),
                  ],
                ),
          
                const SizedBox(height: 10),
          
                // Tab content
                Expanded(
                  child: TabBarView(children: [_contactList(), _contactList()]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _contactList() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return const ContactDetailsCard();
      },
    );
  }
}

class ContactDetailsCard extends StatelessWidget {
  const ContactDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final cameraProvider = context.watch<CameraProvider>();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ContactDetailsScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
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
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: BaseColors().greyColor,
              ),
              child: cameraProvider.frontImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.file(
                        File(cameraProvider.frontImage!.path),
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(Icons.person, color: BaseColors().whiteColor),
            ),

            const SizedBox(width: 20),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ASHISH Nyame',
                  style: TextStyle(
                    color: BaseColors().primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text('AVP-Business Evangelist'),
                const Text('Protectt.ai Lab Pvt.Ltd'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
