import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'my_bookings_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';

class MainShellScreen extends StatefulWidget {
  final int initialIndex;

  const MainShellScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  late int _currentIndex;

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
    final screens = [
      HomeScreen(onNavigateTab: _onTabSelected),
      const SearchScreen(),
      const MyBookingsScreen(),
      const FavoritesScreen(),
      ProfileScreen(onNavigateTab: _onTabSelected),
    ];

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: FloatingBottomNavBar(
        selectedIndex: _currentIndex,
        onItemTapped: _onTabSelected,
      ),
    );
  }
}
