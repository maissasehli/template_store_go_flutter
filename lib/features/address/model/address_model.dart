class Address {
  final String? id;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  
  Address({
    this.id,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
  });
  
  // Create a copy of this address with some fields replaced
  Address copyWith({
    String? street,
    String? city,
    String? state,
    String? zipCode,
  }) {
    return Address(
      id: id,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
    );
  }
  
  // Convert address to a map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
    };
  }
  
  // Create address from a map
  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id'],
      street: map['street'],
      city: map['city'],
      state: map['state'],
      zipCode: map['zipCode'],
    );
  }
  
  // Format address as a string
  String get formattedAddress {
    return '$street, $city, $state $zipCode';
  }
}