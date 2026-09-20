import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/mock_boats.dart';
import '../models/boat.dart';
import '../theme/app_theme.dart';
import '../widgets/boat_card_widget.dart';
import 'search_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final BoatRepository _repository = BoatRepository();
  late AnimationController _entranceController;

  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;

  @override
  void initState() {
    super.initState();
    _repository.addListener(_onRepoChanged);

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _headerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeIn),
      ),
    );

    _headerSlide = Tween<Offset>(
      begin: const Offset(0.0, -0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOutCubic),
      ),
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _repository.removeListener(_onRepoChanged);
    super.dispose();
  }

  void _onRepoChanged() {
    if (mounted) setState(() {});
  }

  Widget _buildAnimatedCard(Boat boat, int index, int totalCount) {
    // Alternating entrance: even indices slide in from the right, odd indices from the left
    final bool fromRight = index % 2 == 0;
    final double startInterval = (0.12 + (index * 0.15)).clamp(0.0, 0.7);
    final double endInterval = (startInterval + 0.48).clamp(0.0, 1.0);

    final slideAnimation = Tween<Offset>(
      begin: Offset(fromRight ? 0.45 : -0.45, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Interval(startInterval, endInterval, curve: Curves.easeOutCubic),
      ),
    );

    final fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Interval(
          startInterval,
          (startInterval + 0.35).clamp(0.0, 1.0),
          curve: Curves.easeIn,
        ),
      ),
    );

    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: BoatCardWidget(boat: boat),
      ),
    );
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
          padding: EdgeInsets.fromLTRB(
            24,
            0,
            24,
            MediaQuery.of(context).padding.bottom + 28,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Header & Search Bar (Fades & Slides gently from top)
              SlideTransition(
                position: _headerSlide,
                child: FadeTransition(
                  opacity: _headerFade,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Bar: Hamburger Menu (left) & Profile (right)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Minimalist Double-Line Menu Icon
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SearchScreen(),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 4.0),
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProfileScreen(),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.circle,
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SearchScreen(),
                            ),
                          );
                        },
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          decoration: BoxDecoration(
                            color: AppTheme.searchPillBg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color:
                                  AppTheme.dividerColor.withValues(alpha: 0.6),
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
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Stacked Colorful Boat Cards with Staggered Left/Right Slide-in
              ...boats.asMap().entries.map(
                    (entry) => _buildAnimatedCard(
                      entry.value,
                      entry.key,
                      boats.length,
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
