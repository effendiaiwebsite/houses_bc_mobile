import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/property_model.dart';
import '../services/property_service.dart';
import '../../../shared/models/api_response.dart';

// Property Service Provider
final propertyServiceProvider = Provider<PropertyService>((ref) {
  return PropertyService();
});

// Property Search State
class PropertySearchState {
  final List<Property> properties;
  final bool isLoading;
  final String? error;
  final PropertySearchParams searchParams;
  final bool hasMore;

  PropertySearchState({
    this.properties = const [],
    this.isLoading = false,
    this.error,
    PropertySearchParams? searchParams,
    this.hasMore = true,
  }) : searchParams = searchParams ?? const PropertySearchParams();

  PropertySearchState copyWith({
    List<Property>? properties,
    bool? isLoading,
    String? error,
    PropertySearchParams? searchParams,
    bool? hasMore,
  }) {
    return PropertySearchState(
      properties: properties ?? this.properties,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchParams: searchParams ?? this.searchParams,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

// Property Search Notifier
class PropertySearchNotifier extends StateNotifier<PropertySearchState> {
  final PropertyService _propertyService;

  PropertySearchNotifier(this._propertyService) : super(PropertySearchState()) {
    searchProperties(); // Load initial properties
  }

  // Search properties with filters
  Future<void> searchProperties({PropertySearchParams? params}) async {
    final searchParams = params ?? state.searchParams;

    state = state.copyWith(
      isLoading: true,
      error: null,
      searchParams: searchParams,
    );

    final result = await _propertyService.searchProperties(searchParams);

    if (result.isSuccess) {
      state = state.copyWith(
        properties: result.data ?? [],
        isLoading: false,
        hasMore: (result.data?.length ?? 0) >= 20,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: result.error,
      );
    }
  }

  // Load more properties (pagination)
  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    final nextPage = state.searchParams.copyWith(
      page: state.searchParams.page + 1,
    );

    state = state.copyWith(isLoading: true);

    final result = await _propertyService.searchProperties(nextPage);

    if (result.isSuccess) {
      final newProperties = result.data ?? [];
      state = state.copyWith(
        properties: [...state.properties, ...newProperties],
        isLoading: false,
        searchParams: nextPage,
        hasMore: newProperties.length >= 20,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: result.error,
      );
    }
  }

  // Update search filters
  void updateFilters(PropertySearchParams params) {
    searchProperties(params: params);
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Property Search Provider
final propertySearchProvider = StateNotifierProvider<PropertySearchNotifier, PropertySearchState>((ref) {
  final propertyService = ref.watch(propertyServiceProvider);
  return PropertySearchNotifier(propertyService);
});

// Property Details Provider (for individual property)
final propertyDetailsProvider = FutureProvider.family<Property?, String>((ref, zpid) async {
  final propertyService = ref.watch(propertyServiceProvider);
  final result = await propertyService.getPropertyDetails(zpid);
  return result.isSuccess ? result.data : null;
});

// Saved Properties Provider
final savedPropertiesProvider = FutureProvider<List<SavedProperty>>((ref) async {
  final propertyService = ref.watch(propertyServiceProvider);
  final result = await propertyService.getSavedProperties();
  return result.isSuccess ? result.data ?? [] : [];
});
