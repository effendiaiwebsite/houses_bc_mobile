import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../providers/property_provider.dart';
import '../models/property_model.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../shared/widgets/error_view.dart';
import '../../auth/providers/auth_provider.dart';

class PropertyDetailsScreen extends ConsumerWidget {
  final String zpid;
  final Property? property;

  const PropertyDetailsScreen({
    super.key,
    required this.zpid,
    this.property,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // If property was passed directly, use it. Otherwise fetch from API.
    final authState = ref.watch(authNotifierProvider);

    // Use passed property or fetch from API
    if (property != null) {
      return _buildPropertyDetails(context, ref, property!, authState);
    }

    final propertyAsync = ref.watch(propertyDetailsProvider(zpid));
    return Scaffold(
      body: propertyAsync.when(
        data: (fetchedProperty) {
          if (fetchedProperty == null) {
            return const ErrorView(message: 'Property not found');
          }
          return _buildPropertyDetails(context, ref, fetchedProperty, authState);
        },
        loading: () => const LoadingIndicator(message: 'Loading property...'),
        error: (error, stack) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(propertyDetailsProvider(zpid)),
        ),
      ),
    );
  }

  Widget _buildPropertyDetails(BuildContext context, WidgetRef ref, Property property, dynamic authState) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Image Carousel AppBar
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: property.images != null && property.images!.isNotEmpty
                  ? PageView.builder(
                      itemCount: property.images!.length,
                      itemBuilder: (context, index) {
                        return CachedNetworkImage(
                          imageUrl: property.images![index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          placeholder: (context, url) => Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.grey[300]!,
                                  Colors.grey[100]!,
                                ],
                              ),
                            ),
                            child: const Center(child: CircularProgressIndicator()),
                          ),
                          errorWidget: (context, url, error) => Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.grey[300]!,
                                  Colors.grey[100]!,
                                ],
                              ),
                            ),
                            child: const Icon(Icons.home_rounded, size: 100),
                          ),
                        );
                      },
                    )
                  : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.grey[300]!,
                            Colors.grey[100]!,
                          ],
                        ),
                      ),
                      child: const Icon(Icons.home_rounded, size: 100),
                    ),
            ),
          ),

          // Property Details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price
                  if (property.price != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        Formatters.formatCurrency(property.price!),
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Address
                  Row(
                    children: [
                      Icon(Icons.location_on_rounded,
                           color: Theme.of(context).primaryColor,
                           size: 24),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          property.fullAddress,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Specs Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (property.beds != null)
                        _SpecCard(
                          icon: Icons.bed_rounded,
                          label: '${property.beds}',
                          subtitle: 'Bedrooms',
                        ),
                      if (property.baths != null)
                        _SpecCard(
                          icon: Icons.bathtub_rounded,
                          label: '${property.baths}',
                          subtitle: 'Bathrooms',
                        ),
                      if (property.sqft != null)
                        _SpecCard(
                          icon: Icons.square_foot_rounded,
                          label: Formatters.formatArea(property.sqft!),
                          subtitle: 'Area',
                        ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),

                  // Property Details Section
                  Text(
                    'Property Details',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),

                  // Property Type & Year Row
                  Row(
                    children: [
                      if (property.propertyType != null)
                        Expanded(
                          child: _InfoCard(
                            title: 'Property Type',
                            value: property.propertyType!,
                            icon: Icons.home_rounded,
                          ),
                        ),
                      if (property.yearBuilt != null && property.propertyType != null)
                        const SizedBox(width: 12),
                      if (property.yearBuilt != null)
                        Expanded(
                          child: _InfoCard(
                            title: 'Year Built',
                            value: property.yearBuilt.toString(),
                            icon: Icons.calendar_today_rounded,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Lot Size
                  if (property.lotSize != null)
                    _InfoCard(
                      title: 'Lot Size',
                      value: '${Formatters.formatNumber(property.lotSize!)} sq ft',
                      icon: Icons.landscape_rounded,
                    ),

                  const SizedBox(height: 24),

                  // Description
                  if (property.description != null) ...[
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Text(
                        property.description!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              height: 1.6,
                            ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            if (authState.isAuthenticated) {
                              _saveProperty(context, ref, property);
                            } else {
                              context.push('/otp-verification?return=/property/$zpid');
                            }
                          },
                          icon: const Icon(Icons.favorite_border_rounded),
                          label: const Text('Save Property'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (authState.isAuthenticated) {
                              context.push('/book-viewing', extra: property);
                            } else {
                              context.push('/otp-verification?return=/property/$zpid');
                            }
                          },
                          icon: const Icon(Icons.calendar_today_rounded),
                          label: const Text('Book Viewing'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveProperty(BuildContext context, WidgetRef ref, Property property) async {
    final propertyService = ref.read(propertyServiceProvider);
    final result = await propertyService.saveProperty(zpid, property);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.isSuccess ? 'Property saved!' : result.error ?? 'Failed to save'),
          backgroundColor: result.isSuccess ? Colors.green : Colors.red,
        ),
      );
    }
  }
}

class _SpecCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;

  const _SpecCard({
    required this.icon,
    required this.label,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 32,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _InfoCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Old unused widgets (keep for compatibility)
class _SpecItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SpecItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}
