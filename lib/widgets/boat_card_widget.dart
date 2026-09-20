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
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
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
          height: 160,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Colored Card Background Container
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                top: 16,
                child: Container(
                  decoration: BoxDecoration(
                    color: boat.cardColor,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: boat.cardColor.withValues(alpha: 0.35),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.only(
                    left: 22,
                    bottom: 22,
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

              // Overlapping Floating 3D Kayak Asset with smooth rotation & Hero flight
              Positioned(
                right: -10,
                top: -8,
                bottom: 6,
                width: 195,
                child: Hero(
                  tag: 'boat-image-${boat.id}',
                  flightShuttleBuilder: (flightContext, animation,
                      flightDirection, fromHeroContext, toHeroContext) {
                    final rotationTween = Tween<double>(
                      begin: -0.15,
                      end: 0.0,
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
                    angle: -0.15,
                    child: Image.asset(
                      boat.imageAsset,
                      fit: BoxFit.contain,
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
