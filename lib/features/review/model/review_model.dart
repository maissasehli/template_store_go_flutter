import 'dart:developer' as developer;

class Review {
  final String id;
  final String userName;
  final String appUserId;
  final int rating;
  final String? content;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.userName,
    required this.appUserId,
    required this.rating,
    this.content,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    developer.log('Parsing Review JSON: $json', name: 'Review.fromJson');

    return Review(
      id: json['id']?.toString() ?? '',
      userName: json['appUser'] != null
          ? json['appUser']['name']?.toString() ?? 'Anonymous'
          : 'Anonymous',
      appUserId: json['appUserId']?.toString() ?? '',
      rating: int.tryParse(json['rating']?.toString() ?? '0') ?? 0,
      content: json['content']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      'rating': rating,
      'content': content ?? '',
      'appUserId': appUserId,
    };
    developer.log('Converting Review to JSON: $json', name: 'Review.toJson');
    return json;
  }
}