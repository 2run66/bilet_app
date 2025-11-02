import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../../controllers/navigation_controller.dart';
import '../home/home_page.dart';
import '../tickets/my_tickets_page.dart';
import '../events/browse_events_page.dart';
import 'native_glass_view.dart';

class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  final NavigationController _navController = Get.put(NavigationController());

  final List<Widget> _pages = const [
    HomePage(),
    BrowseEventsPage(),
    MyTicketsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.background,
        extendBody: true, // Important: extends body behind bottom nav
        body: IndexedStack(
          index: _navController.currentIndex.value,
          children: _pages,
        ),
        bottomNavigationBar: defaultTargetPlatform == TargetPlatform.iOS
            ? LiquidGlassTabBar(
                index: _navController.currentIndex.value,
                onTap: (i) => _navController.changeTab(i),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppColors.border.withValues(alpha: 0.3),
                      width: 0.5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BottomNavigationBar(
                      currentIndex: _navController.currentIndex.value,
                      onTap: (index) => _navController.changeTab(index),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      selectedItemColor: AppColors.primary,
                      unselectedItemColor: AppColors.textTertiary,
                      showUnselectedLabels: false,
                      type: BottomNavigationBarType.fixed,
                      iconSize: 24,
                      items: const [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.home_outlined),
                          activeIcon: Icon(Icons.home),
                          label: 'Home',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.search_outlined),
                          activeIcon: Icon(Icons.search),
                          label: 'Browse',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.confirmation_number_outlined),
                          activeIcon: Icon(Icons.confirmation_number),
                          label: 'Tickets',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
