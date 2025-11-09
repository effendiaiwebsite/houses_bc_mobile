import 'package:equatable/equatable.dart';

class Property extends Equatable {
  final String zpid;
  final String? address;
  final String? city;
  final String? state;
  final String? zipcode;
  final double? price;
  final int? beds;
  final double? baths;
  final double? sqft;
  final String? propertyType;
  final String? listingStatus;
  final List<String>? images;
  final double? latitude;
  final double? longitude;
  final String? description;
  final int? yearBuilt;
  final double? lotSize;
  final String? listingUrl;

  const Property({
    required this.zpid,
    this.address,
    this.city,
    this.state,
    this.zipcode,
    this.price,
    this.beds,
    this.baths,
    this.sqft,
    this.propertyType,
    this.listingStatus,
    this.images,
    this.latitude,
    this.longitude,
    this.description,
    this.yearBuilt,
    this.lotSize,
    this.listingUrl,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    // Handle both 'images' array and 'imgSrc' string from Zillow API
    List<String>? imagesList;
    if (json['images'] != null) {
      imagesList = List<String>.from(json['images'] as List);
    } else if (json['imgSrc'] != null) {
      // Zillow API returns imgSrc as primary image
      imagesList = [json['imgSrc'] as String];
    } else if (json['carouselPhotos'] != null) {
      // Zillow also returns carouselPhotos array
      final photos = json['carouselPhotos'] as List;
      imagesList = photos.map((p) => p['url'] as String).toList();
    }

    return Property(
      zpid: json['zpid']?.toString() ?? '',
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      zipcode: json['zipcode'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      beds: json['beds'] as int? ?? json['bedrooms'] as int?, // Handle both 'beds' and 'bedrooms'
      baths: (json['baths'] as num?)?.toDouble() ?? (json['bathrooms'] as num?)?.toDouble(), // Handle both
      sqft: (json['sqft'] as num?)?.toDouble() ?? (json['livingArea'] as num?)?.toDouble(), // Handle both
      propertyType: json['propertyType'] as String?,
      listingStatus: json['listingStatus'] as String?,
      images: imagesList,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      description: json['description'] as String?,
      yearBuilt: json['yearBuilt'] as int?,
      lotSize: (json['lotSize'] as num?)?.toDouble() ?? (json['lotAreaValue'] as num?)?.toDouble(), // Handle both
      listingUrl: json['listingUrl'] as String? ?? json['detailUrl'] as String?, // Handle both
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'zpid': zpid,
      'address': address,
      'city': city,
      'state': state,
      'zipcode': zipcode,
      'price': price,
      'beds': beds,
      'baths': baths,
      'sqft': sqft,
      'propertyType': propertyType,
      'listingStatus': listingStatus,
      'images': images,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'yearBuilt': yearBuilt,
      'lotSize': lotSize,
      'listingUrl': listingUrl,
    };
  }

  String get fullAddress {
    final parts = <String>[];
    if (address != null) parts.add(address!);
    if (city != null) parts.add(city!);
    if (state != null) parts.add(state!);
    if (zipcode != null) parts.add(zipcode!);
    return parts.join(', ');
  }

  String? get primaryImage => images?.isNotEmpty == true ? images!.first : null;

  @override
  List<Object?> get props => [
        zpid,
        address,
        city,
        state,
        zipcode,
        price,
        beds,
        baths,
        sqft,
        propertyType,
        listingStatus,
        images,
        latitude,
        longitude,
        description,
        yearBuilt,
        lotSize,
        listingUrl,
      ];
}

class PropertySearchParams extends Equatable {
  final String location;
  final String statusType; // 'ForSale' or 'ForRent'
  final String? homeType;
  final double? minPrice;
  final double? maxPrice;
  final int? beds;
  final int? baths;
  final int page;

  const PropertySearchParams({
    this.location = 'British Columbia',
    this.statusType = 'ForSale',
    this.homeType,
    this.minPrice,
    this.maxPrice,
    this.beds,
    this.baths,
    this.page = 1,
  });

  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{
      'location': location,
      'status_type': statusType,
      'page': page,
    };

    if (homeType != null) params['home_type'] = homeType;
    if (minPrice != null) params['minPrice'] = minPrice;
    if (maxPrice != null) params['maxPrice'] = maxPrice;
    if (beds != null) params['beds'] = beds;
    if (baths != null) params['baths'] = baths;

    return params;
  }

  PropertySearchParams copyWith({
    String? location,
    String? statusType,
    String? homeType,
    double? minPrice,
    double? maxPrice,
    int? beds,
    int? baths,
    int? page,
  }) {
    return PropertySearchParams(
      location: location ?? this.location,
      statusType: statusType ?? this.statusType,
      homeType: homeType ?? this.homeType,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      beds: beds ?? this.beds,
      baths: baths ?? this.baths,
      page: page ?? this.page,
    );
  }

  @override
  List<Object?> get props =>
      [location, statusType, homeType, minPrice, maxPrice, beds, baths, page];
}

class SavedProperty extends Equatable {
  final String id;
  final String userId;
  final String zpid;
  final Property property;
  final DateTime savedAt;
  final String? notes;

  const SavedProperty({
    required this.id,
    required this.userId,
    required this.zpid,
    required this.property,
    required this.savedAt,
    this.notes,
  });

  factory SavedProperty.fromJson(Map<String, dynamic> json) {
    return SavedProperty(
      id: json['id'] as String,
      userId: json['userId'] as String,
      zpid: json['zpid'] as String,
      property: Property.fromJson(json['property'] as Map<String, dynamic>),
      savedAt: DateTime.parse(json['savedAt'] as String),
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'zpid': zpid,
      'property': property.toJson(),
      'savedAt': savedAt.toIso8601String(),
      'notes': notes,
    };
  }

  @override
  List<Object?> get props => [id, userId, zpid, property, savedAt, notes];
}
