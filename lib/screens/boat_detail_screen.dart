import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/mock_boats.dart';
import '../models/boat.dart';
import '../theme/app_theme.dart';
import 'booking_confirmation_screen.dart';

class BoatDetailScreen extends StatefulWidget {
  final Boat boat;

  const BoatDetailScreen({
    super.key,
    required this.boat,
  });

  @override
  State<BoatDetailScreen> createState() => _BoatDetailScreenState();
}

class _BoatDetailScreenState extends State<BoatDetailScreen> {
  final BoatRepository _repository = BoatRepository();
  late PageController _pageController;
  late int _currentIndex;
  double _currentPageValue = 0.0;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    final boats = _repository.boats;
    _currentIndex = boats.indexWhere((b) => b.id == widget.boat.id);
    if (_currentIndex == -1) _currentIndex = 0;
    _currentPageValue = _currentIndex.toDouble();
    _pageController = PageController(initialPage: _currentIndex);

    _pageController.addListener(() {
      setState(() {
        _currentPageValue = _pageController.page ?? _currentIndex.toDouble();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Color _interpolateColor(List<Boat> boats) {
    if (boats.isEmpty) return const Color(0xFF2F54EB);
    final int lowerIndex = _currentPageValue.floor().clamp(0, boats.length - 1);
    final int upperIndex = _currentPageValue.ceil().clamp(0, boats.length - 1);
    final double fraction = _currentPageValue - lowerIndex;

    return Color.lerp(
          boats[lowerIndex].cardColor,
          boats[upperIndex].cardColor,
          fraction,
        ) ??
        boats[lowerIndex].cardColor;
  }

  @override
  Widget build(BuildContext context) {
    final boats = _repository.boats;
    final currentBoat = boats[_currentIndex.clamp(0, boats.length - 1)];
    final Color dynamicBgColor = _interpolateColor(boats);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 1. Top Bar: Back Arrow on Left, Profile Icon on Right
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Arrow Button (Navigates back to Home)
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: AppTheme.textDark,
                      size: 26,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                  ),

                  // Profile Silhouette Icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      CupertinoIcons.person,
                      color: AppTheme.textDark,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 2. Main Expanded Container with Vertical PageView
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  // Smoothly Interpolating Colored Bottom Container
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: dynamicBgColor,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(42),
                        ),
                      ),
                    ),
                  ),

                  // Vertical PageView for sleek boat transitions (Swipe Up -> boat goes up, next boat enters from below)
                  Positioned(
                    top: -95,
                    bottom: 110,
                    left: 0,
                    right: 0,
                    child: PageView.builder(
                      controller: _pageController,
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      itemCount: boats.length,
                      itemBuilder: (context, index) {
                        final b = boats[index];
                        final Widget boatImage = Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Image.asset(
                              b.imageAsset,
                              fit: BoxFit.contain,
                            ),
                          ),
                        );

                        // Only apply Hero to the initial opened boat
                        if (b.id == widget.boat.id) {
                          return Hero(
                            tag: 'boat-image-${b.id}',
                            child: boatImage,
                          );
                        }

                        return boatImage;
                      },
                    ),
                  ),

                  // Bottom Section: Boat Name & Stepper
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 34,
                    child: SafeArea(
                      top: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Animated Boat Name with sleek crossfade
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: Text(
                              currentBoat.name,
                              key: ValueKey<String>(currentBoat.id),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.outfit(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Stepper Pill [ −  1  + ]
                          GestureDetector(
                            onTap: () {
                              _navigateToConfirmation(currentBoat);
                            },
                            child: Container(
                              width: 156,
                              height: 52,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.12),
                                    blurRadius: 18,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Minus Button
                                  IconButton(
                                    onPressed: () {
                                      if (_quantity > 1) {
                                        setState(() {
                                          _quantity--;
                                        });
                                      }
                                    },
                                    icon: Icon(
                                      CupertinoIcons.minus,
                                      size: 19,
                                      color: dynamicBgColor,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(
                                      minWidth: 40,
                                      minHeight: 40,
                                    ),
                                  ),

                                  // Quantity Number
                                  Text(
                                    '$_quantity',
                                    style: GoogleFonts.outfit(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textDark,
                                    ),
                                  ),

                                  // Plus Button
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _quantity++;
                                      });
                                    },
                                    icon: Icon(
                                      CupertinoIcons.plus,
                                      size: 19,
                                      color: dynamicBgColor,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(
                                      minWidth: 40,
                                      minHeight: 40,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToConfirmation(Boat boat) {
    final booking = Booking(
      orderNumber: '#12D347',
      boat: boat,
      date: DateTime.now().add(const Duration(days: 1)),
      quantity: _quantity,
      guests: boat.capacity * _quantity,
      totalPrice: boat.pricePerDay * _quantity,
    );
    _repository.addBooking(booking);

    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 550),
        pageBuilder: (context, animation, secondaryAnimation) =>
            BookingConfirmationScreen(booking: booking),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }
}
