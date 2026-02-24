enum UserRole { driver, owner }

class UserModel {
  final String id;
  final String email;
  final String name;
  final String phone;
  final UserRole role;
  final String? avatarUrl;
  final DateTime createdAt;
  final bool isVerified;
  
  // Driver specific
  final List<String>? favoriteSpots;
  final int? totalBookings;
  final double? totalSpent;
  
  // Owner specific
  final int? totalSpots;
  final double? totalEarnings;
  final double? averageRating;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.role,
    this.avatarUrl,
    required this.createdAt,
    this.isVerified = false,
    this.favoriteSpots,
    this.totalBookings,
    this.totalSpent,
    this.totalSpots,
    this.totalEarnings,
    this.averageRating,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${json['role']}',
        orElse: () => UserRole.driver,
      ),
      avatarUrl: json['avatarUrl'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      isVerified: json['isVerified'] ?? false,
      favoriteSpots: json['favoriteSpots'] != null
          ? List<String>.from(json['favoriteSpots'])
          : null,
      totalBookings: json['totalBookings'],
      totalSpent: json['totalSpent']?.toDouble(),
      totalSpots: json['totalSpots'],
      totalEarnings: json['totalEarnings']?.toDouble(),
      averageRating: json['averageRating']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'role': role.toString().split('.').last,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt.toIso8601String(),
      'isVerified': isVerified,
      'favoriteSpots': favoriteSpots,
      'totalBookings': totalBookings,
      'totalSpent': totalSpent,
      'totalSpots': totalSpots,
      'totalEarnings': totalEarnings,
      'averageRating': averageRating,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    UserRole? role,
    String? avatarUrl,
    DateTime? createdAt,
    bool? isVerified,
    List<String>? favoriteSpots,
    int? totalBookings,
    double? totalSpent,
    int? totalSpots,
    double? totalEarnings,
    double? averageRating,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      isVerified: isVerified ?? this.isVerified,
      favoriteSpots: favoriteSpots ?? this.favoriteSpots,
      totalBookings: totalBookings ?? this.totalBookings,
      totalSpent: totalSpent ?? this.totalSpent,
      totalSpots: totalSpots ?? this.totalSpots,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      averageRating: averageRating ?? this.averageRating,
    );
  }
}
