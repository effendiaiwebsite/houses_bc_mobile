import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../shared/models/api_response.dart';
import '../models/property_model.dart';

class PropertyService {
  final ApiClient _apiClient = ApiClient.instance;

  /// Search properties with filters
  Future<Result<List<Property>>> searchProperties(
    PropertySearchParams params,
  ) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.searchProperties,
        queryParameters: params.toQueryParams(),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final properties = (data['props'] as List)
            .map((json) => Property.fromJson(json as Map<String, dynamic>))
            .toList();

        return Result.success(properties);
      } else {
        final error = response.data?['error'] ?? 'Failed to search properties';
        return Result.failure(error);
      }
    } on ApiException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('An unexpected error occurred');
    }
  }

  /// Get property details by ZPID
  Future<Result<Property>> getPropertyDetails(String zpid) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.propertyDetails(zpid),
      );

      if (response.statusCode == 200) {
        final property = Property.fromJson(
          response.data['data'] as Map<String, dynamic>,
        );
        return Result.success(property);
      } else {
        final error = response.data?['error'] ?? 'Property not found';
        return Result.failure(error);
      }
    } on ApiException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('An unexpected error occurred');
    }
  }

  /// Save property (requires authentication)
  Future<Result<void>> saveProperty(String zpid, Property property) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.savedProperties,
        data: {
          'zpid': zpid,
          'property': property.toJson(),
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Result.success(null);
      } else {
        final error = response.data?['error'] ?? 'Failed to save property';
        return Result.failure(error);
      }
    } on ApiException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('An unexpected error occurred');
    }
  }

  /// Get saved properties (requires authentication)
  Future<Result<List<SavedProperty>>> getSavedProperties() async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.savedProperties,
      );

      if (response.statusCode == 200) {
        final savedProperties = (response.data['data'] as List)
            .map((json) => SavedProperty.fromJson(json as Map<String, dynamic>))
            .toList();

        return Result.success(savedProperties);
      } else {
        final error = response.data?['error'] ?? 'Failed to load saved properties';
        return Result.failure(error);
      }
    } on ApiException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('An unexpected error occurred');
    }
  }

  /// Remove saved property (requires authentication)
  Future<Result<void>> removeSavedProperty(String id) async {
    try {
      final response = await _apiClient.delete(
        ApiEndpoints.deleteSavedProperty(id),
      );

      if (response.statusCode == 200) {
        return Result.success(null);
      } else {
        final error = response.data?['error'] ?? 'Failed to remove property';
        return Result.failure(error);
      }
    } on ApiException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('An unexpected error occurred');
    }
  }

  /// Alias for removeSavedProperty
  Future<Result<void>> unsaveProperty(String zpid) => removeSavedProperty(zpid);
}
