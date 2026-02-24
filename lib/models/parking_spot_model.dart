enum SpotType { open, covered, garage, underground }

enum SpotStatus { available, booked, maintenance }

class ParkingSpotModel {
  final String id;
  final String ownerId;
  final String ownerName;
  final String title;
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  final double pricePerHour;
  final double? pricePerDay;
  final SpotType type;
  final SpotStatus status;
  final List<String> images;
  final double rating;
  final int reviewCount;
  final List<String> amenities;
  final bool isApproved;
  final DateTime createdAt;
  
  // Distance from search location (calculated)
  final double? distance;

  ParkingSpotModel({
    required this.id,
    required this.ownerId,
    required this.ownerName,
    required this.title,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.pricePerHour,
    this.pricePerDay,
    required this.type,
    this.status = SpotStatus.available,
    required this.images,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.amenities,
    this.isApproved = false,
    required this.createdAt,
    this.distance,
  });

  factory ParkingSpotModel.fromJson(Map<String, dynamic> json) {
    return ParkingSpotModel(
      id: json['id'] ?? '',
      ownerId: json['ownerId'] ?? '',
      ownerName: json['ownerName'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      pricePerHour: json['pricePerHour']?.toDouble() ?? 0.0,
      pricePerDay: json['pricePerDay']?.toDouble(),
      type: SpotType.values.firstWhere(
        (e) => e.toString() == 'SpotType.${json['type']}',
        orElse: () => SpotType.open,
      ),
      status: SpotStatus.values.firstWhere(
        (e) => e.toString() == 'SpotStatus.${json['status']}',
        orElse: () => SpotStatus.available,
      ),
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      rating: json['rating']?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] ?? 0,
      amenities: json['amenities'] != null
          ? List<String>.from(json['amenities'])
          : [],
      isApproved: json['isApproved'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      distance: json['distance']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'title': title,
      'description': description,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'pricePerHour': pricePerHour,
      'pricePerDay': pricePerDay,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'images': images,
      'rating': rating,
      'reviewCount': reviewCount,
      'amenities': amenities,
      'isApproved': isApproved,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  String get formattedPrice {
    return '\$${pricePerHour.toStringAsFixed(2)}/hr';
  }

  String get formattedDayPrice {
    return pricePerDay != null
        ? '\$${pricePerDay!.toStringAsFixed(0)}/day'
        : '';
  }

  String get typeLabel {
    switch (type) {
      case SpotType.open:
        return 'Open Air';
      case SpotType.covered:
        return 'Covered';
      case SpotType.garage:
        return 'Garage';
      case SpotType.underground:
        return 'Underground';
    }
  }

  String get statusLabel {
    switch (status) {
      case SpotStatus.available:
        return 'Available';
      case SpotStatus.booked:
        return 'Booked';
      case SpotStatus.maintenance:
        return 'Maintenance';
    }
  }

  ParkingSpotModel copyWith({
    String? id,
    String? ownerId,
    String? ownerName,
    String? title,
    String? description,
    String? address,
    double? latitude,
    double? longitude,
    double? pricePerHour,
    double? pricePerDay,
    SpotType? type,
    SpotStatus? status,
    List<String>? images,
    double? rating,
    int? reviewCount,
    List<String>? amenities,
    bool? isApproved,
    DateTime? createdAt,
    double? distance,
  }) {
    return ParkingSpotModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      title: title ?? this.title,
      description: description ?? this.description,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      pricePerHour: pricePerHour ?? this.pricePerHour,
      pricePerDay: pricePerDay ?? this.pricePerDay,
      type: type ?? this.type,
      status: status ?? this.status,
      images: images ?? this.images,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      amenities: amenities ?? this.amenities,
      isApproved: isApproved ?? this.isApproved,
      createdAt: createdAt ?? this.createdAt,
      distance: distance ?? this.distance,
    );
  }
}
