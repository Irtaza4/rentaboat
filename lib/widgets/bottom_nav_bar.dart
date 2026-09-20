import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../theme/app_theme.dart';

class FloatingBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const FloatingBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      height: 68,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(34),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F2040).withValues(alpha: 0.08),
            blurRadius: 25,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, CupertinoIcons.compass, CupertinoIcons.compass_fill, 'Explore'),
          _buildNavItem(1, CupertinoIcons.search, CupertinoIcons.search, 'Search'),
          _buildNavItem(2, CupertinoIcons.calendar, CupertinoIcons.calendar_today, 'Bookings'),
          _buildNavItem(3, CupertinoIcons.heart, CupertinoIcons.heart_fill, 'Favorites'),
          _buildNavItem(4, CupertinoIcons.person, CupertinoIcons.person_fill, 'Profile'),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      int index, IconData unselectedIcon, IconData selectedIcon, String label) {
    final bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryBlue.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : unselectedIcon,
              color: isSelected ? AppTheme.primaryBlue : AppTheme.textLightGray,
              size: 23,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppTheme.primaryBlue : AppTheme.textGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
