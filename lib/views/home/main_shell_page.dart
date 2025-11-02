import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../utils/app_colors.dart';
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
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    BrowseEventsPage(),
    MyTicketsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true, // Important: extends body behind bottom nav
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: defaultTargetPlatform == TargetPlatform.iOS
          ? LiquidGlassTabBar(
              index: _currentIndex,
              onTap: (i) => setState(() => _currentIndex = i),
            )
          : BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() => _currentIndex = index);
              },
              backgroundColor: AppColors.surface.withValues(alpha: 0.9),
              elevation: 0,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.textTertiary,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
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
    );
  }
}
