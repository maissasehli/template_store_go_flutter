class Address {
  final String? id;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final bool isDefault;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Address({
    this.id,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.isDefault = false,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id'] as String?,
      street: map['street'] as String,
      city: map['city'] as String,
      state: map['state'] as String,
      zipCode: map['postalCode'] as String,
      country: map['country'] as String,
      isDefault: map['isDefault'] as bool? ?? false,
      status: map['status'] as String?,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }

  Map<String, dynamic> toMap({bool includeId = true}) {
    return {
      if (includeId) 'id': id, // Only include id if explicitly requested
      'street': street,
      'city': city,
      'state': state,
      'postalCode': zipCode,
      'country': country,
      'isDefault': isDefault,
      'status': status,
      // Exclude created_at and updated_at from the request
    };
  }

  String get formattedAddress => '$street, $city, $state $zipCode, $country';
}