import 'package:biz_scan_app/core/colors.dart';
import 'package:biz_scan_app/widgets/custom_app_bar.dart';
import 'package:biz_scan_app/widgets/custom_textbutton.dart';
import 'package:flutter/material.dart';

class MergeContactScreen extends StatelessWidget {
  const MergeContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaseColors().whiteColor,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Possible duplicates",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                "Nothing is merged automatically- these are yours to decide on",
              ),

              SizedBox(height: 20),

              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: Text(
                                "very likely the same person",
                                overflow: TextOverflow.ellipsis,
                              ),
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: BaseColors().lightPrimaryColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "same email: amoabeaakuaosafo@gmail.com}",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Mr Edem Evans",
                                  style: TextStyle(
                                    color: BaseColors().primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text("Zero Zone Automobile Engineering"),
                              ],
                            ),
                          ),
                          Expanded(child: Icon(Icons.compare_arrows)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Mr Edem Evans",
                                  style: TextStyle(
                                    color: BaseColors().primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text("Zero Zone Automobile Engineering"),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CustomTextButton(
                              text: "Merge",
                              borderRadius: 20,
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: CustomTextButton(
                              text: "Not a duplicate",
                              borderRadius: 20,
                              backgroundColor: Colors.transparent,
                              foregroundColor: BaseColors().primaryColor,
                            ),
                          ),
                        ],
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
