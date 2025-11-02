class EventModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String location;
  final DateTime date;
  final double price;
  final String imageUrl;
  final int availableTickets;
  final String organizerName;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    required this.date,
    required this.price,
    required this.imageUrl,
    required this.availableTickets,
    required this.organizerName,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'location': location,
      'date': date.toIso8601String(),
      'price': price,
      'imageUrl': imageUrl,
      'availableTickets': availableTickets,
      'organizerName': organizerName,
    };
  }

  // Create from JSON
  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      location: json['location'] as String,
      date: DateTime.parse(json['date'] as String),
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      availableTickets: json['availableTickets'] as int,
      organizerName: json['organizerName'] as String,
    );
  }

  // Copy with
  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? location,
    DateTime? date,
    double? price,
    String? imageUrl,
    int? availableTickets,
    String? organizerName,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      location: location ?? this.location,
      date: date ?? this.date,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      availableTickets: availableTickets ?? this.availableTickets,
      organizerName: organizerName ?? this.organizerName,
    );
  }

  // Check if event is upcoming
  bool get isUpcoming => date.isAfter(DateTime.now());

  // Check if tickets available
  bool get hasTicketsAvailable => availableTickets > 0;

  // Formatted date string
  String get formattedDate {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final month = months[date.month - 1];
    final day = date.day.toString().padLeft(2, '0');
    final year = date.year;
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$month $day, $year • $hour:$minute $period';
  }
}
