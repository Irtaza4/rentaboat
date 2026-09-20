import 'package:flutter/material.dart';
import '../models/boat.dart';

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
      cardColor: Color(0xFF2F54EB),
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
      cardColor: Color(0xFFFFA4C8),
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
      id: 'pelican-athena',
      name: 'Pelican Athena',
      category: 'Kayaks',
      tag: 'Recreational',
      cardColor: Color(0xFF55D2DF),
      imageAsset: 'assets/images/pelican_athena_vertical.png',
      pricePerHour: 42.0,
      pricePerDay: 115.0,
      rating: 4.9,
      reviewsCount: 164,
      capacity: 1,
      cabins: 0,
      length: '10.0 ft',
      year: 2024,
      description:
          'Ultra-lightweight recreational sit-inside kayak featuring a multi-chine flat bottom hull for excellent stability and smooth gliding. Ergonomic padded backrest with quick-lock footrests.',
      amenities: [
        'Single Asymmetrical Paddle',
        'Life Jacket Included',
        'Dry Hatch Storage',
        'Adjustable Footrests',
        'Cockpit Knee Pads',
      ],
      hostName: 'Lagoon Adventures',
      hostAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
      hostRating: '4.95',
      location: 'Coconut Grove Harbor, Miami',
      isFavorite: true,
    ),
    const Boat(
      id: 'sun-dolphin',
      name: 'Sun Dolphin',
      category: 'Kayaks',
      tag: 'Tandem Kayak',
      cardColor: Color(0xFF0512DD),
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
  ];

  final List<Booking> _bookings = [
    Booking(
      orderNumber: '#12D347',
      boat: const Boat(
        id: 'lifetime-youth',
        name: 'Lifetime Youth',
        category: 'Kayaks',
        tag: 'Recreational',
        cardColor: Color(0xFF2F54EB),
        imageAsset: 'assets/images/red_kayak.png',
        pricePerHour: 45.0,
        pricePerDay: 120.0,
        rating: 4.9,
        reviewsCount: 148,
        capacity: 2,
        cabins: 0,
        length: '9.8 ft',
        year: 2024,
        description: 'Engineered for maximum stability and speed.',
        amenities: ['Dual Paddles', 'Life Jackets'],
        hostName: 'Captain Alex',
        hostAvatar: '',
        hostRating: '4.95',
        location: 'Key Biscayne Marina, Miami',
      ),
      date: DateTime.now().add(const Duration(days: 2)),
      quantity: 1,
      guests: 2,
      totalPrice: 120.0,
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
