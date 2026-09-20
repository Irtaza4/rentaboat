import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/mock_boats.dart';
import '../models/boat.dart';
import '../theme/app_theme.dart';
import '../widgets/boat_card_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final BoatRepository _repository = BoatRepository();
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Kayaks',
    'Speedboats',
    'Tandem',
    'Motorboats',
    'Yachts',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Boat> get _filteredBoats {
    return _repository.boats.where((boat) {
      final matchesQuery = _searchController.text.isEmpty ||
          boat.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          boat.description.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          boat.location.toLowerCase().contains(_searchController.text.toLowerCase());

      final matchesCategory = _selectedCategory == 'All' ||
          boat.category == _selectedCategory ||
          boat.tag.contains(_selectedCategory);

      return matchesQuery && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredBoats;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Explore Boats',
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Search input
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppTheme.searchPillBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.dividerColor),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          CupertinoIcons.search,
                          color: AppTheme.textGray,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (_) => setState(() {}),
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              color: AppTheme.textDark,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search boats, locations, gear...',
                              hintStyle: GoogleFonts.outfit(
                                color: AppTheme.textLightGray,
                                fontSize: 14.5,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        if (_searchController.text.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              setState(() {});
                            },
                            child: const Icon(
                              Icons.close_rounded,
                              color: AppTheme.textGray,
                              size: 18,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Category Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: _categories.map((cat) {
                        final isSelected = _selectedCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(cat),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = cat;
                              });
                            },
                            selectedColor: AppTheme.primaryBlue,
                            backgroundColor: AppTheme.surfaceOffWhite,
                            labelStyle: GoogleFonts.outfit(
                              color: isSelected ? Colors.white : AppTheme.textDark,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              fontSize: 13.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: isSelected ? Colors.transparent : AppTheme.dividerColor,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Boat list
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.search,
                            size: 56,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No boats match your search',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Try changing keywords or categories',
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
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        return BoatCardWidget(boat: filtered[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
