import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));

  @override
  Widget build(BuildContext context) {
    final boat = widget.boat;
    final isFav = _repository.findById(boat.id)?.isFavorite ?? boat.isFavorite;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),

              // Top Bar: Back Button (left) & Favorite/Profile (right)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back arrow
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 42,
                      height: 42,
                      alignment: Alignment.centerLeft,
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: AppTheme.textDark,
                        size: 26,
                      ),
                    ),
                  ),

                  // Favorite Action Icon
                  InkWell(
                    onTap: () {
                      setState(() {
                        _repository.toggleFavorite(boat.id);
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 42,
                      height: 42,
                      alignment: Alignment.centerRight,
                      child: Icon(
                        isFav ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                        color: isFav ? AppTheme.coralRed : AppTheme.textDark,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Giant Blue Container with Vertical Kayak & Crossed Paddles (Screen 2 Mockup)
              Container(
                width: double.infinity,
                height: 480,
                decoration: BoxDecoration(
                  color: boat.cardColor == AppTheme.softPink
                      ? AppTheme.softPink
                      : boat.cardColor == AppTheme.mintGreen
                          ? AppTheme.mintGreen
                          : const Color(0xFF0721E8),
                  borderRadius: BorderRadius.circular(36),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0721E8).withValues(alpha: 0.35),
                      blurRadius: 28,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    // Vertical Kayak Asset breaking through top & center
                    Positioned(
                      top: -20,
                      bottom: 80,
                      left: 0,
                      right: 0,
                      child: Hero(
                        tag: 'boat-${boat.id}',
                        child: Center(
                          child: Image.asset(
                            boat.id == 'sun-dolphin'
                                ? 'assets/images/sundolphin_vertical.png'
                                : boat.imageAsset,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),

                    // Boat Title: e.g. "Sun Dolphin"
                    Positioned(
                      bottom: 74,
                      child: Text(
                        boat.name,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),

                    // Interactive Stepper: [ −  1  + ]
                    Positioned(
                      bottom: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
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
                              icon: const Icon(
                                CupertinoIcons.minus,
                                size: 18,
                                color: Color(0xFF0721E8),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 36,
                                minHeight: 36,
                              ),
                              padding: EdgeInsets.zero,
                            ),

                            // Quantity Text
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              child: Text(
                                '$_quantity',
                                style: GoogleFonts.outfit(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textDark,
                                ),
                              ),
                            ),

                            // Plus Button
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _quantity++;
                                });
                              },
                              icon: const Icon(
                                CupertinoIcons.plus,
                                size: 18,
                                color: Color(0xFF0721E8),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 36,
                                minHeight: 36,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Specs Row (Rating, Capacity, Length, Year)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceOffWhite,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.dividerColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSpecItem(
                      CupertinoIcons.star_fill,
                      '${boat.rating}',
                      '(${boat.reviewsCount})',
                      Colors.amber,
                    ),
                    _buildDivider(),
                    _buildSpecItem(
                      CupertinoIcons.person_2_fill,
                      '${boat.capacity * _quantity} Guests',
                      'Capacity',
                      AppTheme.primaryBlue,
                    ),
                    _buildDivider(),
                    _buildSpecItem(
                      CupertinoIcons.placemark_fill,
                      boat.length,
                      'Length',
                      AppTheme.coralRed,
                    ),
                    _buildDivider(),
                    _buildSpecItem(
                      CupertinoIcons.calendar,
                      '${boat.year}',
                      'Edition',
                      AppTheme.mintGreen,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // About this boat
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'About this boat',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                boat.description,
                style: GoogleFonts.outfit(
                  fontSize: 14.5,
                  height: 1.55,
                  color: AppTheme.textGray,
                ),
              ),

              const SizedBox(height: 24),

              // Included Amenities
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Included Equipment',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: boat.amenities.map((amenity) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceOffWhite,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.dividerColor),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppTheme.mintGreen,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          amenity,
                          style: GoogleFonts.outfit(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textDark,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // Location info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceOffWhite,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppTheme.dividerColor),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        CupertinoIcons.location_solid,
                        color: AppTheme.primaryBlue,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Departure Marina',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: AppTheme.textGray,
                            ),
                          ),
                          Text(
                            boat.location,
                            style: GoogleFonts.outfit(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Date Selection Row
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 90)),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: AppTheme.primaryBlue,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceOffWhite,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppTheme.dividerColor),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.softPink.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          CupertinoIcons.calendar,
                          color: AppTheme.coralRed,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rental Date',
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                color: AppTheme.textGray,
                              ),
                            ),
                            Text(
                              DateFormat('EEEE, MMMM d, y')
                                  .format(_selectedDate),
                              style: GoogleFonts.outfit(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        CupertinoIcons.chevron_right,
                        color: AppTheme.textLightGray,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Sticky / Bottom Reservation Bar
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: AppTheme.floatingShadow,
                  border: Border.all(color: AppTheme.dividerColor),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Total Price',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: AppTheme.textGray,
                          ),
                        ),
                        Text(
                          '\$${(boat.pricePerDay * _quantity).toStringAsFixed(0)}',
                          style: GoogleFonts.outfit(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Create booking and navigate to Screen 3 (Confirmation)
                          final booking = Booking(
                            orderNumber: '#12D347',
                            boat: boat,
                            date: _selectedDate,
                            quantity: _quantity,
                            guests: boat.capacity * _quantity,
                            totalPrice: boat.pricePerDay * _quantity,
                          );
                          _repository.addBooking(booking);

                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      BookingConfirmationScreen(
                                booking: booking,
                              ),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0721E8),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Reserve Boat',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecItem(
      IconData icon, String value, String label, Color iconColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 11,
            color: AppTheme.textGray,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 36,
      color: AppTheme.dividerColor,
    );
  }
}
