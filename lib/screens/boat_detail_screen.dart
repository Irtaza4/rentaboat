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

class _BoatDetailScreenState extends State<BoatDetailScreen>
    with SingleTickerProviderStateMixin {
  final BoatRepository _repository = BoatRepository();
  late PageController _pageController;
  late int _currentIndex;
  double _currentPageValue = 0.0;
  int _quantity = 1;

  late AnimationController _animController;
  late Animation<double> _expandProgress;

  DateTime? _startDate = DateTime.now().add(const Duration(days: 1));
  DateTime? _endDate = DateTime.now().add(const Duration(days: 2));

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

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _expandProgress = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOutCubicEmphasized,
      reverseCurve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    if (_animController.isCompleted) {
      _animController.reverse();
    } else {
      _animController.forward();
    }
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
    final activeIndex = _currentPageValue.round().clamp(0, boats.length - 1);
    final currentBoat = boats[activeIndex];
    final Color dynamicBgColor = _interpolateColor(boats);
    final size = MediaQuery.of(context).size;
    final topPadding = MediaQuery.of(context).padding.top;

    final double paddleCost = 28.25 * _quantity;
    final double lifeVestCost = 12.50 * _quantity;
    const double pledgeCost = 10.00;
    final double totalCost = paddleCost + lifeVestCost + pledgeCost;

    // Proportional heights matching reference design
    final double collapsedContainerTop = size.height * 0.31;
    final double collapsedBoatTop = size.height * 0.14;
    final double collapsedBoatHeight = size.height * 0.45;

    return AnimatedBuilder(
      animation: _expandProgress,
      builder: (context, child) {
        final progress = _expandProgress.value;

        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              // 1. Top Bar when collapsed (Menu/Back icon & Profile icon)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  bottom: false,
                  child: Opacity(
                    opacity: (1.0 - progress * 2.0).clamp(0.0, 1.0),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(22, 10, 22, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                  ),
                ),
              ),

              // 2. Main Colored Background Container (Starts at ~26% of screen)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                top: Tween<double>(
                  begin: collapsedContainerTop,
                  end: 0.0,
                ).transform(progress),
                child: Container(
                  decoration: BoxDecoration(
                    color: dynamicBgColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(
                        Tween<double>(begin: 42.0, end: 32.0)
                            .transform(progress),
                      ),
                    ),
                  ),
                ),
              ),

              // 3. Upright Vertical Kayaks with Full-Screen Vertical PageView
              Positioned.fill(
                child: Opacity(
                  opacity: (1.0 - progress * 1.5).clamp(0.0, 1.0),
                  child: Transform.translate(
                    offset: Offset(0, -progress * size.height * 0.75),
                    child: PageView.builder(
                      controller: _pageController,
                      scrollDirection: Axis.vertical,
                      physics: progress > 0.1
                          ? const NeverScrollableScrollPhysics()
                          : const BouncingScrollPhysics(),
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
                            padding: const EdgeInsets.symmetric(horizontal: 42),
                            child: Image.asset(
                              b.imageAsset,
                              fit: BoxFit.contain,
                            ),
                          ),
                        );

                        return Stack(
                          children: [
                            Positioned(
                              top: collapsedBoatTop,
                              height: collapsedBoatHeight,
                              left: 0,
                              right: 0,
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: _toggleExpand,
                                child: b.id == widget.boat.id
                                    ? Hero(
                                        tag: 'boat-image-${b.id}',
                                        child: boatImage,
                                      )
                                    : boatImage,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),

              // 4. Boat Title & Stepper Pill (Animates from bottom to top on expand)
              Positioned(
                left: 0,
                right: 0,
                top: Tween<double>(
                  begin: size.height - 180.0,
                  end: topPadding + 20.0,
                ).transform(progress),
                child: GestureDetector(
                  onTap: _toggleExpand,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Boat Name
                      Text(
                        currentBoat.name,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Stepper Pill [ − 1 + ]
                      _buildStepperPill(dynamicBgColor),
                    ],
                  ),
                ),
              ),

              // 5. Expanded Rental Details & Golden "Rent a boat" Button (Slides up & reveals)
              if (progress > 0.05)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  top: Tween<double>(
                    begin: size.height,
                    end: topPadding + 160.0,
                  ).transform(progress),
                  child: Opacity(
                    opacity: progress.clamp(0.0, 1.0),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(28, 16, 28, 36),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),

                          // Description
                          Text(
                            'Description:',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '2 storage platforms with bungee cords located in both the front and rear of the kayak',
                            style: GoogleFonts.outfit(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withValues(alpha: 0.88),
                              height: 1.45,
                            ),
                          ),

                          const SizedBox(height: 28),

                          // Date inputs: [ dd/mm/yyyy ] [ dd/mm/yyyy ]
                          Row(
                            children: [
                              Expanded(
                                child: _buildDateInput(
                                  label: _startDate != null
                                      ? DateFormat('dd/MM/yyyy')
                                          .format(_startDate!)
                                      : 'dd/mm/yyyy',
                                  onTap: () => _pickDate(isStart: true),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: _buildDateInput(
                                  label: _endDate != null
                                      ? DateFormat('dd/MM/yyyy')
                                          .format(_endDate!)
                                      : 'dd/mm/yyyy',
                                  onTap: () => _pickDate(isStart: false),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          // Price table
                          _buildPriceRow(
                            label: 'Paddle',
                            tag: 'x$_quantity',
                            amount: '\$${paddleCost.toStringAsFixed(2)}',
                          ),
                          const SizedBox(height: 16),
                          _buildPriceRow(
                            label: 'Life Vest',
                            amount: '\$${lifeVestCost.toStringAsFixed(2)}',
                          ),
                          const SizedBox(height: 16),
                          _buildPriceRow(
                            label: 'Pledge',
                            amount: '\$${pledgeCost.toStringAsFixed(2)}',
                          ),

                          const SizedBox(height: 28),

                          // Total
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Total',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '\$${totalCost.toStringAsFixed(2)}',
                                style: GoogleFonts.outfit(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 28),

                          // Golden Yellow "Rent a boat" CTA Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                _navigateToConfirmation(
                                    currentBoat, totalCost);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFBA808),
                                foregroundColor: Colors.white,
                                elevation: 6,
                                shadowColor: const Color(0xFFFBA808)
                                    .withValues(alpha: 0.4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                'Rent a boat',
                                style: GoogleFonts.outfit(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),

              // 6. Floating Tap Back / Collapse Arrow at top when expanded
              if (progress > 0.5)
                Positioned(
                  top: topPadding + 8,
                  left: 18,
                  child: Opacity(
                    opacity: ((progress - 0.5) * 2).clamp(0.0, 1.0),
                    child: IconButton(
                      onPressed: _toggleExpand,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStepperPill(Color dynamicBgColor) {
    return Container(
      width: 146,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
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
          Text(
            '$_quantity',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textDark,
            ),
          ),
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
    );
  }

  Widget _buildDateInput({
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 14.5,
            fontWeight: FontWeight.w500,
            color: AppTheme.textGray,
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow({
    required String label,
    String? tag,
    required String amount,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            if (tag != null) ...[
              const SizedBox(width: 8),
              Text(
                tag,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFFBA808),
                ),
              ),
            ],
          ],
        ),
        Text(
          amount,
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart
          ? (_startDate ?? DateTime.now())
          : (_endDate ?? DateTime.now().add(const Duration(days: 1))),
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
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _navigateToConfirmation(Boat boat, [double? totalAmount]) {
    final booking = Booking(
      orderNumber: '#12D347',
      boat: boat,
      date: _startDate ?? DateTime.now().add(const Duration(days: 1)),
      quantity: _quantity,
      guests: boat.capacity * _quantity,
      totalPrice: totalAmount ?? (boat.pricePerDay * _quantity),
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
