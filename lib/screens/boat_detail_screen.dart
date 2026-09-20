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
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final boat = widget.boat;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 1. Top Bar: Hamburger Menu on Left, Profile Icon on Right
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Minimalist Double-Line Menu Icon (Tapping pops back to Home)
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    behavior: HitTestBehavior.opaque,
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

            const SizedBox(height: 36),

            // 2. Main Expanded Container with Overflowing Vertical Kayak
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  // Colored Bottom Container (Full width, rounded top, fills bottom of screen)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: boat.cardColor,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(42),
                        ),
                      ),
                    ),
                  ),

                  // Vertical Kayak Overflowing Past Top Edge onto White Header
                  Positioned(
                    top: -100,
                    bottom: 120,
                    left: 24,
                    right: 24,
                    child: Hero(
                      tag: 'boat-image-${boat.id}',
                      child: Image.asset(
                        boat.imageAsset,
                        fit: BoxFit.contain,
                      ),
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
                          // Boat Name
                          Text(
                            boat.name,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: -0.3,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Stepper Pill [ −  1  + ]
                          GestureDetector(
                            onTap: () {
                              _navigateToConfirmation();
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
                                      color: boat.cardColor,
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
                                      color: boat.cardColor,
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

  void _navigateToConfirmation() {
    final booking = Booking(
      orderNumber: '#12D347',
      boat: widget.boat,
      date: DateTime.now().add(const Duration(days: 1)),
      quantity: _quantity,
      guests: widget.boat.capacity * _quantity,
      totalPrice: widget.boat.pricePerDay * _quantity,
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
