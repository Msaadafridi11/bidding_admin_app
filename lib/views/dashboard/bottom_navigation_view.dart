import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../car/admin_add_car_view.dart';
import '../car/admin_car_list_view.dart';
import '../profile/admin_profile_view.dart';

class BottomNavigationView extends StatefulWidget {
  final int initialIndex;

  const BottomNavigationView({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<BottomNavigationView> createState() => _BottomNavigationViewState();
}

class _BottomNavigationViewState extends State<BottomNavigationView> {
  late int _currentIndex;

  final List<Widget> _views = const [
    AdminAddCarView(),
    AdminCarListView(),
    AdminProfileView(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _views,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: const Border(
            top: BorderSide(color: AppColors.border, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: _onTabSelected,
            backgroundColor: AppColors.surface,
            indicatorColor: AppColors.primaryLight,
            elevation: 0,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.add_circle_outline_rounded),
                selectedIcon: Icon(Icons.add_circle_rounded, color: AppColors.primary),
                label: 'Add Car',
              ),
              NavigationDestination(
                icon: Icon(Icons.directions_car_outlined),
                selectedIcon: Icon(Icons.directions_car_rounded, color: AppColors.primary),
                label: 'Inventory',
              ),
              NavigationDestination(
                icon: Icon(Icons.admin_panel_settings_outlined),
                selectedIcon: Icon(Icons.admin_panel_settings_rounded, color: AppColors.primary),
                label: 'Admin',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
