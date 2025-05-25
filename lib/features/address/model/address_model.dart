import 'package:flutter/foundation.dart';

class Address {
  final String? id;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final bool isDefault;
  final String? status;
  final String firstName;
  final String lastName;
  final String? apartment;
  final String phone;
  final String? type; // 'shipping' or 'billing'
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Address({
    this.id,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.apartment,
    this.type = 'shipping',
    this.isDefault = false,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  // Create a copy of this Address with modified fields
  Address copyWith({
    String? id,
    String? street,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    String? firstName,
    String? lastName,
    String? apartment,
    String? phone,
    String? type,
    bool? isDefault,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Address(
      id: id ?? this.id,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      apartment: apartment ?? this.apartment,
      phone: phone ?? this.phone,
      type: type ?? this.type,
      isDefault: isDefault ?? this.isDefault,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Get formatted address as a single string
  String get formattedAddress {
    final parts = <String>[
      '$firstName $lastName',
      street,
      if (apartment != null && apartment!.isNotEmpty) apartment!,
      '$city, $state $zipCode',
      country,
      phone,
    ];
    return parts.join('\n');
  }

  // Convert Address to map for API requests
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      'firstName': firstName,
      'lastName': lastName,
      'apartment': apartment,
      'phone': phone,
      'type': type,
      'isDefault': isDefault,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Create Address from map (API response)
  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id'],
      street: map['street'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      zipCode: map['zipCode'] ?? map['postalCode'] ?? '',
      country: map['country'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      apartment: map['apartment'],
      phone: map['phone'] ?? '',
      type: map['type'] ?? 'shipping',
      isDefault: map['isDefault'] ?? false,
      status: map['status'],
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }
}
