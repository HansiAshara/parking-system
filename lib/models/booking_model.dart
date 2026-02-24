enum BookingStatus { pending, confirmed, active, completed, cancelled }

enum PaymentStatus { pending, paid, refunded, failed }

class BookingModel {
  final String id;
  final String spotId;
  final String spotTitle;
  final String spotImage;
  final String driverId;
  final String driverName;
  final String driverAvatar;
  final String ownerId;
  final DateTime startTime;
  final DateTime endTime;
  final int duration; // in hours
  final double totalAmount;
  final double platformFee;
  final double ownerEarnings;
  final BookingStatus status;
  final PaymentStatus paymentStatus;
  final DateTime createdAt;
  final String? qrCode;
  final String? notes;

  BookingModel({
    required this.id,
    required this.spotId,
    required this.spotTitle,
    required this.spotImage,
    required this.driverId,
    required this.driverName,
    required this.driverAvatar,
    required this.ownerId,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.totalAmount,
    required this.platformFee,
    required this.ownerEarnings,
    this.status = BookingStatus.pending,
    this.paymentStatus = PaymentStatus.pending,
    required this.createdAt,
    this.qrCode,
    this.notes,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? '',
      spotId: json['spotId'] ?? '',
      spotTitle: json['spotTitle'] ?? '',
      spotImage: json['spotImage'] ?? '',
      driverId: json['driverId'] ?? '',
      driverName: json['driverName'] ?? '',
      driverAvatar: json['driverAvatar'] ?? '',
      ownerId: json['ownerId'] ?? '',
      startTime: json['startTime'] != null
          ? DateTime.parse(json['startTime'])
          : DateTime.now(),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'])
          : DateTime.now(),
      duration: json['duration'] ?? 0,
      totalAmount: json['totalAmount']?.toDouble() ?? 0.0,
      platformFee: json['platformFee']?.toDouble() ?? 0.0,
      ownerEarnings: json['ownerEarnings']?.toDouble() ?? 0.0,
      status: BookingStatus.values.firstWhere(
        (e) => e.toString() == 'BookingStatus.${json['status']}',
        orElse: () => BookingStatus.pending,
      ),
      paymentStatus: PaymentStatus.values.firstWhere(
        (e) => e.toString() == 'PaymentStatus.${json['paymentStatus']}',
        orElse: () => PaymentStatus.pending,
      ),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      qrCode: json['qrCode'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'spotId': spotId,
      'spotTitle': spotTitle,
      'spotImage': spotImage,
      'driverId': driverId,
      'driverName': driverName,
      'driverAvatar': driverAvatar,
      'ownerId': ownerId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'duration': duration,
      'totalAmount': totalAmount,
      'platformFee': platformFee,
      'ownerEarnings': ownerEarnings,
      'status': status.toString().split('.').last,
      'paymentStatus': paymentStatus.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'qrCode': qrCode,
      'notes': notes,
    };
  }

  String get statusLabel {
    switch (status) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.active:
        return 'Active';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get paymentStatusLabel {
    switch (paymentStatus) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.paid:
        return 'Paid';
      case PaymentStatus.refunded:
        return 'Refunded';
      case PaymentStatus.failed:
        return 'Failed';
    }
  }

  bool get isActive =>
      status == BookingStatus.active || status == BookingStatus.confirmed;

  bool get isCompleted => status == BookingStatus.completed;

  bool get isPending => status == BookingStatus.pending;

  bool get isCancelled => status == BookingStatus.cancelled;

  String get formattedDate {
    return '${startTime.day}/${startTime.month}/${startTime.year}';
  }

  String get formattedTimeRange {
    final start = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
    final end = '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
    return '$start - $end';
  }

  BookingModel copyWith({
    String? id,
    String? spotId,
    String? spotTitle,
    String? spotImage,
    String? driverId,
    String? driverName,
    String? driverAvatar,
    String? ownerId,
    DateTime? startTime,
    DateTime? endTime,
    int? duration,
    double? totalAmount,
    double? platformFee,
    double? ownerEarnings,
    BookingStatus? status,
    PaymentStatus? paymentStatus,
    DateTime? createdAt,
    String? qrCode,
    String? notes,
  }) {
    return BookingModel(
      id: id ?? this.id,
      spotId: spotId ?? this.spotId,
      spotTitle: spotTitle ?? this.spotTitle,
      spotImage: spotImage ?? this.spotImage,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      driverAvatar: driverAvatar ?? this.driverAvatar,
      ownerId: ownerId ?? this.ownerId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      totalAmount: totalAmount ?? this.totalAmount,
      platformFee: platformFee ?? this.platformFee,
      ownerEarnings: ownerEarnings ?? this.ownerEarnings,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      createdAt: createdAt ?? this.createdAt,
      qrCode: qrCode ?? this.qrCode,
      notes: notes ?? this.notes,
    );
  }
}
