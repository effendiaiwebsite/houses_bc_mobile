import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/property_provider.dart';
import '../widgets/property_card.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../shared/widgets/error_view.dart';

class SavedPropertiesScreen extends ConsumerWidget {
  const SavedPropertiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedPropertiesAsync = ref.watch(savedPropertiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Properties'),
      ),
      body: savedPropertiesAsync.when(
        data: (savedProperties) {
          if (savedProperties.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No saved properties',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Start saving properties you like',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.go('/'),
                    child: const Text('Browse Properties'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(savedPropertiesProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: savedProperties.length,
              itemBuilder: (context, index) {
                final savedProperty = savedProperties[index];
                return PropertyCard(
                  property: savedProperty.property,
                  onTap: () {
                    context.push('/property/${savedProperty.zpid}');
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () async {
                      // Unsave the property
                      final propertyService = ref.read(propertyServiceProvider);
                      await propertyService.unsaveProperty(savedProperty.zpid);
                      ref.invalidate(savedPropertiesProvider);
                    },
                  ),
                );
              },
            ),
          );
        },
        loading: () => const LoadingIndicator(message: 'Loading saved properties...'),
        error: (error, stack) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(savedPropertiesProvider),
        ),
      ),
    );
  }
}
