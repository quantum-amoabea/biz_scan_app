import 'package:biz_scan_app/core/colors.dart';
import 'package:biz_scan_app/core/offline/prefs_manager.dart';
import 'package:biz_scan_app/views/merge_contact_screen.dart';
import 'package:biz_scan_app/widgets/custom_textbutton.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/dash_stat_card.dart';
import 'nav_bar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaseColors().whiteColor,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, ${PrefsManager().getUser()?.displayName ?? 'User'}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),

              const SizedBox(height: 20),

              const Text('Here is your network overview for today'),

              const SizedBox(height: 30),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: BaseColors().primaryColor,
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // LEFT SIDE
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TOTAL SCANNED',
                                style: TextStyle(
                                  color: BaseColors().whiteColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '1,248',
                                    style: TextStyle(
                                      color: BaseColors().whiteColor,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  Text(
                                    '+24',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: BaseColors().whiteColor,
                                    ),
                                  ),

                                  const SizedBox(width: 5),

                                  Text(
                                    'this week',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: BaseColors().whiteColor,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),
                            ],
                          ),
                        ),

                        const SizedBox(width: 20),

                        // RIGHT SIDE
                        Icon(
                          Icons.qr_code_scanner,
                          color: BaseColors().whiteColor,
                        ),
                      ],
                    ),

                    /* LinearProgressIndicator(
                      value: 0,
                      minHeight: 40,
                      backgroundColor: Colors.white24,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        BaseColors().whiteColor,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),*/
                  ],
                ),
              ),

              SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: DashboardStatCard(
                      value: '0',
                      title: 'Awaiting Review',
                      icon: Icons.event_note_outlined,
                      onTap: (){

                      },
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: DashboardStatCard(
                      value: '0',
                      title: 'Possible Duplicates',
                      icon: Icons.copy,
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> MergeContactScreen()));
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Text(
                    "Recent Scans",
                    style: TextStyle(
                      color: BaseColors().primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "View All",
                        style: TextStyle(
                          color: BaseColors().primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_outlined,
                        color: BaseColors().primaryColor,
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 20),

              Center(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(30),
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
                      Icon(
                        Icons.contact_mail_outlined,
                        color: BaseColors().greyColor,
                        size: 35,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "No cards scanned yet",
                        style: TextStyle(color: BaseColors().greyColor),
                      ),
                      SizedBox(height: 10),
                      CustomTextButton(
                        text: 'Scan your first card',
                        borderRadius: 26,
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const NavBar(initialIndex: 1),
                            ),
                            (route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
