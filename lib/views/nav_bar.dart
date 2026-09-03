import 'package:biz_scan_app/views/contact_screen.dart';
import 'package:biz_scan_app/views/dashboard_screen.dart';
import 'package:biz_scan_app/views/scan_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/colors.dart';
import '../core/size_config.dart';
import '../view_models/contacts_provider.dart';

class NavBar extends StatefulWidget {
  final int initialIndex;

  const NavBar({super.key, this.initialIndex = 0});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late int _selectedIndex;

  final List<Widget> _screens = const [
    DashboardScreen(),
    ScanScreen(),
    ContactScreen(),
  ];

  final List<Map<String, dynamic>> _navItems = [
    {'title': 'Dashboard', 'icon': Icons.dashboard},
    {'title': 'Scan', 'icon': Icons.camera_alt},
    {'title': 'Contacts', 'icon': Icons.quick_contacts_mail},
  ];

  @override
  void initState() {
    super.initState();

    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final contactProvider = context.read<ContactsProvider>();
      await contactProvider.getContacts();
      await contactProvider.getSharedContacts();
    });

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),

      bottomNavigationBar: SafeArea(
        child: Container(
          height: 70,
          decoration: BoxDecoration(color: BaseColors().whiteColor),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_navItems.length, (index) {
                final item = _navItems[index];

                final bool isSelected = _selectedIndex == index;

                return NavBarIcon(
                  icon: item['icon'],
                  title: item['title'],
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class NavBarIcon extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onTap;

  const NavBarIcon({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 40),
        decoration: BoxDecoration(
          color: isSelected
              ? BaseColors().primaryColor.withValues(alpha: 0.3)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? BaseColors().primaryColor
                  : BaseColors().blackColor,
            ),

            const SizedBox(height: 2),

            Text(
              title,
              style: TextStyle(
                fontSize: getProportionateScreenHeight(10),
                color: isSelected ? BaseColors().primaryColor : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
