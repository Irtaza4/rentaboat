import 'package:flutter/material.dart';

class Boat {
  final String id;
  final String name;
  final String category;
  final String tag;
  final Color cardColor;
  final String imageAsset;
  final double pricePerHour;
  final double pricePerDay;
  final double rating;
  final int reviewsCount;
  final int capacity;
  final int cabins;
  final String length;
  final int year;
  final String description;
  final List<String> amenities;
  final String hostName;
  final String hostAvatar;
  final String hostRating;
  final String location;
  final bool isFavorite;

  const Boat({
    required this.id,
    required this.name,
    required this.category,
    required this.tag,
    required this.cardColor,
    required this.imageAsset,
    required this.pricePerHour,
    required this.pricePerDay,
    required this.rating,
    required this.reviewsCount,
    required this.capacity,
    this.cabins = 0,
    this.length = "10 ft",
    this.year = 2024,
    required this.description,
    required this.amenities,
    required this.hostName,
    required this.hostAvatar,
    required this.hostRating,
    required this.location,
    this.isFavorite = false,
  });

  Boat copyWith({
    String? id,
    String? name,
    String? category,
    String? tag,
    Color? cardColor,
    String? imageAsset,
    double? pricePerHour,
    double? pricePerDay,
    double? rating,
    int? reviewsCount,
    int? capacity,
    int? cabins,
    String? length,
    int? year,
    String? description,
    List<String>? amenities,
    String? hostName,
    String? hostAvatar,
    String? hostRating,
    String? location,
    bool? isFavorite,
  }) {
    return Boat(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      tag: tag ?? this.tag,
      cardColor: cardColor ?? this.cardColor,
      imageAsset: imageAsset ?? this.imageAsset,
      pricePerHour: pricePerHour ?? this.pricePerHour,
      pricePerDay: pricePerDay ?? this.pricePerDay,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      capacity: capacity ?? this.capacity,
      cabins: cabins ?? this.cabins,
      length: length ?? this.length,
      year: year ?? this.year,
      description: description ?? this.description,
      amenities: amenities ?? this.amenities,
      hostName: hostName ?? this.hostName,
      hostAvatar: hostAvatar ?? this.hostAvatar,
      hostRating: hostRating ?? this.hostRating,
      location: location ?? this.location,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class Booking {
  final String orderNumber;
  final Boat boat;
  final DateTime date;
  final int quantity;
  final int guests;
  final double totalPrice;
  final String status; // 'Confirmed', 'Pending', 'Completed'

  Booking({
    required this.orderNumber,
    required this.boat,
    required this.date,
    required this.quantity,
    required this.guests,
    required this.totalPrice,
    this.status = 'Confirmed',
  });
}
