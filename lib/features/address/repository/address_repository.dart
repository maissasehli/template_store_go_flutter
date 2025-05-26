import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/address/model/address_model.dart';

class AddressRepository {
  final ApiClient _apiClient;

  AddressRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Fetch all addresses for the authenticated user
  Future<List<Address>> getAddresses() async {
    try {
      final response = await _apiClient.get('/addresses');

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((item) => Address.fromMap(item)).toList();
      } else {
        throw Exception('Failed to load addresses: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load addresses: $e');
    }
  }

  /// Fetch a single address by ID
  Future<Address> getAddressById(String addressId) async {
    try {
      final response = await _apiClient.get('/addresses/$addressId');

      if (response.statusCode == 200) {
        return Address.fromMap(response.data['data']);
      } else {
        throw Exception('Failed to load address: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load address: $e');
    }
  }

  /// Create a new address
  Future<Address> createAddress(Address address) async {
    try {
      // Format data according to API requirements - only send required fields
      final addressData = {
        "street": address.street,
        "city": address.city,
        "state": address.state,
        "postalCode": address.postalCode,
        "country": address.country,
        "isDefault": address.isDefault,
      };

      final response = await _apiClient.post('/addresses', data: addressData);

      if (response.statusCode == 201) {
        return Address.fromMap(response.data['data']);
      } else {
        throw Exception('Failed to create address: ${response.statusCode}');
      }
    } catch (e) {
      print('API Error: $e');
      throw Exception('Failed to create address: $e');
    }
  }

  /// Update an existing address
  Future<Address> updateAddress(String addressId, Address address) async {
    try {
      // Format data according to API requirements - only send required fields
      final addressData = {
        "street": address.street,
        "city": address.city,
        "state": address.state,
        "postalCode": address.postalCode,
        "country": address.country,
        "isDefault": address.isDefault,
      };

      final response = await _apiClient.put(
        '/addresses/$addressId',
        data: addressData,
      );

      if (response.statusCode == 200) {
        return Address.fromMap(response.data['data']);
      } else {
        throw Exception('Failed to update address: ${response.statusCode}');
      }
    } catch (e) {
      print('API Error: $e');
      throw Exception('Failed to update address: $e');
    }
  }

  /// Delete an address by ID
  Future<void> deleteAddress(String addressId) async {
    try {
      final response = await _apiClient.delete('/addresses/$addressId');

      if (response.statusCode != 200) {
        throw Exception('Failed to delete address: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete address: $e');
    }
  }

  /// Set an address as default
  Future<Address> setAddressAsDefault(String addressId) async {
    try {
      final response = await _apiClient.put('/addresses/$addressId/default');

      if (response.statusCode == 200) {
        return Address.fromMap(response.data['data']);
      } else {
        throw Exception(
          'Failed to set address as default: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to set address as default: $e');
    }
  }
}
