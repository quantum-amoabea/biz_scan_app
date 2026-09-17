import 'package:biz_scan_app/core/colors.dart';
import 'package:biz_scan_app/features/contact/presentation/screens/contact_details_screen.dart';
import 'package:biz_scan_app/features/contact/viewmodels/contacts_viewmodel.dart';
import 'package:biz_scan_app/widgets/custom_app_bar.dart';
import 'package:biz_scan_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/contacts_shimmer.dart';
import '../../data/contact_services.dart';
import '../../domain/models/contacts.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController sharedSearchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    sharedSearchController.dispose();
    super.dispose();
  }

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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
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

                SizedBox(height: 20),

                // Search

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
                  child: TabBarView(
                    children: [
                      _contactList(context),
                      _sharedContactList(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _contactList(BuildContext context) {
    final contactsProvider = context.watch<ContactsViewModel>();

    final bool isSearching = searchController.text.trim().isNotEmpty;

    final List<Items> contacts = isSearching
        ? contactsProvider.filterContacts
        : contactsProvider.contacts;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CustomTextField(
            suffixIcon: const Icon(Icons.search),
            controller: searchController,
            hintText: "Search names, companies, job titles",
            onChanged: (value) {
              context.read<ContactsViewModel>().getFilteredContacts(value);
            },
          ),

          Expanded(
            child: isSearching
                ? contactsProvider.isFetchingFilteredContacts
                      ? ListView.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return const ContactDetailsCardShimmer();
                          },
                        )
                      : ListView.builder(
                          itemCount: contacts.length,
                          itemBuilder: (context, index) {
                            return ContactDetailsCard(
                              contacts: contacts[index],
                            );
                          },
                        )
                : contactsProvider.isFetchingContacts
                ? ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return const ContactDetailsCardShimmer();
                    },
                  )
                : ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      return ContactDetailsCard(contacts: contacts[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _sharedContactList(BuildContext context) {
    final contactsProvider = context.watch<ContactsViewModel>();

    final bool isSearching = sharedSearchController.text.trim().isNotEmpty;

    final List<Items> contacts = isSearching
        ? contactsProvider.filteredSharedContacts
        : contactsProvider.sharedContacts;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CustomTextField(
            suffixIcon: const Icon(Icons.search),
            controller: sharedSearchController,
            hintText: "Search names, companies, job titles",
            onChanged: (value) {
              context.read<ContactsViewModel>().getFilteredSharedContacts(
                value,
              );
            },
          ),

          Expanded(
            child: isSearching
                ? contactsProvider.isFetchingFilteredSharedContacts
                      ? ListView.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return const ContactDetailsCardShimmer();
                          },
                        )
                      : ListView.builder(
                          itemCount: contacts.length,
                          itemBuilder: (context, index) {
                            return ContactDetailsCard(
                              contacts: contacts[index],
                            );
                          },
                        )
                : contactsProvider.isFetchingSharedContacts
                ? ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return const ContactDetailsCardShimmer();
                    },
                  )
                : ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      return ContactDetailsCard(contacts: contacts[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class ContactDetailsCard extends StatelessWidget {
  final Items contacts;

  const ContactDetailsCard({super.key, required this.contacts});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ContactDetailsScreen(contact: contacts),
          ),
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
                shape: BoxShape.circle,
                color: BaseColors().primaryColor,
              ),
              alignment: Alignment.center,
              child: Text(
                getContactInitials(contacts.fullName ?? ""),
                style: TextStyle(
                  fontSize: 16,
                  color: BaseColors().whiteColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(width: 20),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contacts.fullName ?? '',
                    style: TextStyle(
                      color: BaseColors().primaryColor,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    contacts.jobTitle ?? '',
                    style: const TextStyle(overflow: TextOverflow.ellipsis),
                  ),
                  Text(
                    contacts.company ?? '',
                    style: const TextStyle(overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
