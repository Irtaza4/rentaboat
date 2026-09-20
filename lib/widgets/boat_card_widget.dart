import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/boat.dart';
import '../screens/boat_detail_screen.dart';

class BoatCardWidget extends StatelessWidget {
  final Boat boat;
  final VoidCallback? onTap;

  const BoatCardWidget({
    super.key,
    required this.boat,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // red_kayak and yellow_kayak are already rendered at ~ -45 deg diagonal angle
    // vertical assets (pelican_athena, sundolphin) are rotated on the home card
    final bool isAlreadyAngled =
        boat.id == 'lifetime-youth' || boat.id == 'sunny-island';
    final double cardRotation = isAlreadyAngled ? 0.0 : -0.72;

    return Container(
      margin: const EdgeInsets.only(bottom: 28),
      child: GestureDetector(
        onTap: onTap ??
            () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 600),
                  reverseTransitionDuration: const Duration(milliseconds: 500),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      BoatDetailScreen(boat: boat),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    final curvedAnimation = CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOutCubicEmphasized,
                      reverseCurve: Curves.easeInOutCubic,
                    );
                    return FadeTransition(
                      opacity: Tween<double>(begin: 0.0, end: 1.0)
                          .animate(curvedAnimation),
                      child: child,
                    );
                  },
                ),
              );
            },
        child: SizedBox(
          height: 165,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // 1. Colored Card Background Container
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                top: 14,
                child: Container(
                  decoration: BoxDecoration(
                    color: boat.cardColor,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: boat.cardColor.withValues(alpha: 0.38),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.only(
                    left: 22,
                    bottom: 24,
                    top: 22,
                    right: 140,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Arrow icon
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(height: 8),
                      // Boat Name
                      Text(
                        boat.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.3,
                          height: 1.15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Overlapping Floating 3D Kayak breaking cleanly through boundaries
              Positioned(
                right: -18,
                top: -28,
                bottom: -20,
                width: 220,
                child: Hero(
                  tag: 'boat-image-${boat.id}',
                  flightShuttleBuilder: (flightContext, animation,
                      flightDirection, fromHeroContext, toHeroContext) {
                    final rotationTween = Tween<double>(
                      begin: cardRotation,
                      end: isAlreadyAngled ? 0.72 : 0.0,
                    );
                    return AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: rotationTween.evaluate(animation),
                          child: toHeroContext.widget,
                        );
                      },
                    );
                  },
                  child: Transform.rotate(
                    angle: cardRotation,
                    child: Transform.scale(
                      scale: isAlreadyAngled ? 1.0 : 1.25,
                      child: Image.asset(
                        boat.imageAsset,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
