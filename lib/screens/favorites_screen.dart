import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/mock_boats.dart';
import '../theme/app_theme.dart';
import '../widgets/boat_card_widget.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final BoatRepository _repository = BoatRepository();

  @override
  void initState() {
    super.initState();
    _repository.addListener(_onRepoChanged);
  }

  @override
  void dispose() {
    _repository.removeListener(_onRepoChanged);
    super.dispose();
  }

  void _onRepoChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final favorites = _repository.favorites;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Text(
                'Saved Boats',
                style: GoogleFonts.outfit(
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.textDark,
                ),
              ),
            ),
            Expanded(
              child: favorites.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.heart,
                            size: 54,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'No saved boats yet',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Tap the heart on boats to save them here',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              color: AppTheme.textGray,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 100),
                      itemCount: favorites.length,
                      itemBuilder: (context, index) {
                        return BoatCardWidget(boat: favorites[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
