class Address {
  final String id;
  final String firstName;
  final String lastName;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final String phone;
  final bool isDefault;

  Address({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    required this.phone,
    this.isDefault = false,
  });

  factory Address.empty() => Address(
    id: '',
    firstName: '',
    lastName: '',
    street: '',
    city: '',
    state: '',
    zipCode: '',
    country: '',
    phone: '',
  );

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json['id'] ?? '',
    firstName: json['firstName'] ?? '',
    lastName: json['lastName'] ?? '',
    street: json['street'] ?? '',
    city: json['city'] ?? '',
    state: json['state'] ?? '',
    zipCode: json['zipCode'] ?? '',
    country: json['country'] ?? '',
    phone: json['phone'] ?? '',
    isDefault: json['isDefault'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'street': street,
    'city': city,
    'state': state,
    'zipCode': zipCode,
    'country': country,
    'phone': phone,
    'isDefault': isDefault,
  };

  String get formattedAddress =>
      '$firstName $lastName, $street, $city, $state $zipCode, $country';
}
