import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/mock_boats.dart';
import '../theme/app_theme.dart';
import '../widgets/boat_card_widget.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(int)? onNavigateTab;

  const HomeScreen({
    super.key,
    this.onNavigateTab,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BoatRepository _repository = BoatRepository();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _repository.addListener(_onRepoChanged);
  }

  @override
  void dispose() {
    _repository.removeListener(_onRepoChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onRepoChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final boats = _repository.boats;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Top Bar: Hamburger Menu (left) & Profile (right)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Minimalist Double-Line Menu Icon
                  InkWell(
                    onTap: () {
                      if (widget.onNavigateTab != null) {
                        widget.onNavigateTab!(1); // Navigate to search/filter
                      }
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 18,
                            height: 2.2,
                            decoration: BoxDecoration(
                              color: AppTheme.textDark,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            width: 26,
                            height: 2.2,
                            decoration: BoxDecoration(
                              color: AppTheme.textDark,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Profile Icon
                  InkWell(
                    onTap: () {
                      if (widget.onNavigateTab != null) {
                        widget.onNavigateTab!(4); // Navigate to Profile
                      }
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        CupertinoIcons.person,
                        color: AppTheme.textDark,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // "Rent a boat" Title
              Text(
                'Rent a boat',
                style: GoogleFonts.outfit(
                  fontSize: 34,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.textDark,
                  letterSpacing: -0.3,
                ),
              ),

              const SizedBox(height: 20),

              // Rounded Pill Search Input
              GestureDetector(
                onTap: () {
                  if (widget.onNavigateTab != null) {
                    widget.onNavigateTab!(1);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchScreen(),
                      ),
                    );
                  }
                },
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: AppTheme.searchPillBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.dividerColor.withValues(alpha: 0.6),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        CupertinoIcons.search,
                        color: AppTheme.textLightGray,
                        size: 19,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Search',
                        style: GoogleFonts.outfit(
                          color: AppTheme.textLightGray,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Stacked Colorful Boat Cards with Overlapping 3D Assets
              ...boats.map((boat) => BoatCardWidget(boat: boat)),

              // Bottom spacing for floating navigation bar
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
