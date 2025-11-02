enum TicketStatus { active, used, expired, pending }

class TicketModel {
  final String id;
  final String eventId;
  final String eventTitle;
  final String eventLocation;
  final DateTime eventDate;
  final String userId;
  final TicketStatus status;
  final DateTime purchaseDate;
  final double price;
  final String qrCode;
  final String? seatNumber;

  TicketModel({
    required this.id,
    required this.eventId,
    required this.eventTitle,
    required this.eventLocation,
    required this.eventDate,
    required this.userId,
    required this.status,
    required this.purchaseDate,
    required this.price,
    required this.qrCode,
    this.seatNumber,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventId': eventId,
      'eventTitle': eventTitle,
      'eventLocation': eventLocation,
      'eventDate': eventDate.toIso8601String(),
      'userId': userId,
      'status': status.toString(),
      'purchaseDate': purchaseDate.toIso8601String(),
      'price': price,
      'qrCode': qrCode,
      'seatNumber': seatNumber,
    };
  }

  // Create from JSON
  factory TicketModel.fromJson(Map<String, dynamic> json) {
    // Parse status - handle both "active" and "TicketStatus.active" formats
    String statusStr = json['status'] as String;
    if (statusStr.contains('.')) {
      // Format: "TicketStatus.active" -> "active"
      statusStr = statusStr.split('.').last;
    }
    
    return TicketModel(
      id: json['id'] as String,
      eventId: json['eventId'] as String,
      eventTitle: json['eventTitle'] as String,
      eventLocation: json['eventLocation'] as String,
      eventDate: DateTime.parse(json['eventDate'] as String),
      userId: json['userId'] as String,
      status: TicketStatus.values.firstWhere(
        (e) => e.name == statusStr,
        orElse: () => TicketStatus.pending,
      ),
      purchaseDate: DateTime.parse(json['purchaseDate'] as String),
      price: (json['price'] as num).toDouble(),
      qrCode: json['qrCode'] as String,
      seatNumber: json['seatNumber'] as String?,
    );
  }

  // Copy with
  TicketModel copyWith({
    String? id,
    String? eventId,
    String? eventTitle,
    String? eventLocation,
    DateTime? eventDate,
    String? userId,
    TicketStatus? status,
    DateTime? purchaseDate,
    double? price,
    String? qrCode,
    String? seatNumber,
  }) {
    return TicketModel(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      eventTitle: eventTitle ?? this.eventTitle,
      eventLocation: eventLocation ?? this.eventLocation,
      eventDate: eventDate ?? this.eventDate,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      price: price ?? this.price,
      qrCode: qrCode ?? this.qrCode,
      seatNumber: seatNumber ?? this.seatNumber,
    );
  }

  // Check if ticket is upcoming
  bool get isUpcoming =>
      eventDate.isAfter(DateTime.now()) && status == TicketStatus.active;

  // Check if ticket is past
  bool get isPast =>
      eventDate.isBefore(DateTime.now()) || status == TicketStatus.used;

  // Check if ticket is expired
  bool get isExpired => status == TicketStatus.expired;
}
