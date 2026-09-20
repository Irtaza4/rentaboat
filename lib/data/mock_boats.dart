import 'package:flutter/material.dart';
import '../models/boat.dart';
import '../theme/app_theme.dart';

class BoatRepository extends ChangeNotifier {
  static final BoatRepository _instance = BoatRepository._internal();
  factory BoatRepository() => _instance;
  BoatRepository._internal();

  final List<Boat> _boats = [
    const Boat(
      id: 'lifetime-youth',
      name: 'Lifetime Youth',
      category: 'Kayaks',
      tag: 'Recreational',
      cardColor: AppTheme.electricBlue,
      imageAsset: 'assets/images/red_kayak.png',
      pricePerHour: 45.0,
      pricePerDay: 120.0,
      rating: 4.9,
      reviewsCount: 148,
      capacity: 2,
      cabins: 0,
      length: '9.8 ft',
      year: 2024,
      description:
          'Engineered for maximum stability and speed on tranquil lakes and coastal bays. Features a durable high-density polyethylene hull, molded-in swim-up deck, and comfortable contoured seating with integrated paddle holders.',
      amenities: [
        'Dual Paddles Included',
        'Life Jackets (2)',
        'Waterproof Dry Bag',
        'Comfort Backrest',
        'Cup Holders',
        'Carry Handles',
      ],
      hostName: 'Captain Alex',
      hostAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
      hostRating: '4.95',
      location: 'Key Biscayne Marina, Miami',
      isFavorite: true,
    ),
    const Boat(
      id: 'sunny-island',
      name: 'Sunny Island',
      category: 'Kayaks',
      tag: 'Touring',
      cardColor: AppTheme.softPink,
      imageAsset: 'assets/images/yellow_kayak.png',
      pricePerHour: 40.0,
      pricePerDay: 110.0,
      rating: 4.8,
      reviewsCount: 92,
      capacity: 1,
      cabins: 0,
      length: '10.5 ft',
      year: 2024,
      description:
          'Bright, agile touring kayak perfect for sunny lagoon exploration, island hopping, and calm waters. Offers streamlined tracking and generous bungee deck rigging for gear storage.',
      amenities: [
        'Carbon Fiber Paddle',
        'Life Jacket',
        'Phone Waterproof Pouch',
        'Adjustable Footpegs',
        'Bungee Deck Rigging',
        'Drain Plug',
      ],
      hostName: 'Marina Blue Cove',
      hostAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      hostRating: '4.9',
      location: 'Biscayne Bay, Miami',
      isFavorite: false,
    ),
    const Boat(
      id: 'sun-dolphin',
      name: 'Sun Dolphin',
      category: 'Kayaks',
      tag: 'Tandem Kayak',
      cardColor: AppTheme.primaryBlue,
      imageAsset: 'assets/images/sundolphin_vertical.png',
      pricePerHour: 65.0,
      pricePerDay: 160.0,
      rating: 5.0,
      reviewsCount: 210,
      capacity: 2,
      cabins: 0,
      length: '12.2 ft',
      year: 2024,
      description:
          'Premium dual-seat tandem adventure kayak. Designed for two paddlers to glide effortlessly across open water with supreme balance, padded ergonomic seats, and dual dry storage hatches.',
      amenities: [
        '2 Deluxe Paddles',
        '2 Neoprene Life Vests',
        'Twin Storage Hatches',
        'Padded Lumbar Seats',
        'Fishing Rod Holders',
        'Tow Rope & Whistle',
      ],
      hostName: 'Sunset Watersports',
      hostAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
      hostRating: '5.0',
      location: 'South Beach Harbor, Miami',
      isFavorite: true,
    ),
    const Boat(
      id: 'pink-breeze',
      name: 'Pink Breeze',
      category: 'Kayaks',
      tag: 'Recreational',
      cardColor: AppTheme.mintGreen,
      imageAsset: 'assets/images/pink_kayak.png',
      pricePerHour: 50.0,
      pricePerDay: 130.0,
      rating: 4.9,
      reviewsCount: 78,
      capacity: 2,
      cabins: 0,
      length: '11.0 ft',
      year: 2024,
      description:
          'Chic and comfortable pastel touring kayak crafted for serene morning glides and sunset coast excursions with easy maneuverability.',
      amenities: [
        'Matching Paddles',
        'Life Vests',
        'Waterproof Speaker',
        'Cooler Compartment',
        'Soft Grip Handles',
      ],
      hostName: 'Ocean Breeze Co.',
      hostAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
      hostRating: '4.88',
      location: 'Coconut Grove Marina',
      isFavorite: false,
    ),
    const Boat(
      id: 'sea-ray-speedster',
      name: 'Sea Ray Speedster',
      category: 'Speedboats',
      tag: 'Motorboat',
      cardColor: Color(0xFF16327E),
      imageAsset: 'assets/images/speedboat.png',
      pricePerHour: 180.0,
      pricePerDay: 520.0,
      rating: 4.95,
      reviewsCount: 312,
      capacity: 6,
      cabins: 1,
      length: '24 ft',
      year: 2024,
      description:
          'High-performance luxury sport boat with 250HP Mercury engine, premium marine audio, sun lounge deck, and swim platform.',
      amenities: [
        'Captain Included',
        'Bluetooth Hi-Fi Audio',
        'Large Sun Deck',
        'Swim Platform & Ladder',
        'Ice Cooler & Fresh Drinks',
        'GPS Navigation & Sonar',
      ],
      hostName: 'Captain Robert',
      hostAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
      hostRating: '4.98',
      location: 'Miami Beach Marina Pier 4',
      isFavorite: false,
    ),
  ];

  final List<Booking> _bookings = [
    Booking(
      orderNumber: '#12D347',
      boat: const Boat(
        id: 'sun-dolphin',
        name: 'Sun Dolphin',
        category: 'Kayaks',
        tag: 'Tandem Kayak',
        cardColor: AppTheme.primaryBlue,
        imageAsset: 'assets/images/sundolphin_vertical.png',
        pricePerHour: 65.0,
        pricePerDay: 160.0,
        rating: 5.0,
        reviewsCount: 210,
        capacity: 2,
        cabins: 0,
        length: '12.2 ft',
        year: 2024,
        description: 'Premium dual-seat tandem adventure kayak.',
        amenities: ['2 Deluxe Paddles', '2 Life Vests'],
        hostName: 'Sunset Watersports',
        hostAvatar: '',
        hostRating: '5.0',
        location: 'South Beach Harbor, Miami',
      ),
      date: DateTime.now().add(const Duration(days: 2)),
      quantity: 1,
      guests: 2,
      totalPrice: 160.0,
      status: 'Confirmed',
    ),
  ];

  List<Boat> get boats => List.unmodifiable(_boats);
  List<Boat> get favorites => _boats.where((b) => b.isFavorite).toList();
  List<Booking> get bookings => List.unmodifiable(_bookings);

  void toggleFavorite(String id) {
    final index = _boats.indexWhere((b) => b.id == id);
    if (index != -1) {
      _boats[index] = _boats[index].copyWith(isFavorite: !_boats[index].isFavorite);
      notifyListeners();
    }
  }

  void addBooking(Booking booking) {
    _bookings.insert(0, booking);
    notifyListeners();
  }

  Boat? findById(String id) {
    try {
      return _boats.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }
}
