import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/property_provider.dart';
import '../widgets/property_card.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../shared/widgets/error_view.dart';

class PropertySearchScreen extends ConsumerStatefulWidget {
  const PropertySearchScreen({super.key});

  @override
  ConsumerState<PropertySearchScreen> createState() => _PropertySearchScreenState();
}

class _PropertySearchScreenState extends ConsumerState<PropertySearchScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
      ref.read(propertySearchProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(propertySearchProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Properties'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(propertySearchProvider.notifier).searchProperties();
        },
        child: searchState.isLoading && searchState.properties.isEmpty
            ? const LoadingIndicator(message: 'Loading properties...')
            : searchState.error != null && searchState.properties.isEmpty
                ? ErrorView(
                    message: searchState.error!,
                    onRetry: () {
                      ref.read(propertySearchProvider.notifier).searchProperties();
                    },
                  )
                : searchState.properties.isEmpty
                    ? const Center(
                        child: Text('No properties found'),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(8),
                        itemCount: searchState.properties.length + (searchState.hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= searchState.properties.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          final property = searchState.properties[index];
                          return PropertyCard(
                            property: property,
                            onTap: () {
                              context.push('/property/${property.zpid}', extra: property);
                            },
                          );
                        },
                      ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => PropertyFilterSheet(
          scrollController: scrollController,
        ),
      ),
    );
  }
}

class PropertyFilterSheet extends ConsumerStatefulWidget {
  final ScrollController scrollController;

  const PropertyFilterSheet({
    super.key,
    required this.scrollController,
  });

  @override
  ConsumerState<PropertyFilterSheet> createState() => _PropertyFilterSheetState();
}

class _PropertyFilterSheetState extends ConsumerState<PropertyFilterSheet> {
  late String location;
  late String statusType;
  double? minPrice;
  double? maxPrice;
  int? beds;
  int? baths;

  @override
  void initState() {
    super.initState();
    final currentParams = ref.read(propertySearchProvider).searchParams;
    location = currentParams.location;
    statusType = currentParams.statusType;
    minPrice = currentParams.minPrice;
    maxPrice = currentParams.maxPrice;
    beds = currentParams.beds;
    baths = currentParams.baths;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ListView(
        controller: widget.scrollController,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filters',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    minPrice = null;
                    maxPrice = null;
                    beds = null;
                    baths = null;
                  });
                },
                child: const Text('Reset'),
              ),
            ],
          ),
          const Divider(),

          const SizedBox(height: 16),

          // Status Type
          Text('Listing Type', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'ForSale', label: Text('For Sale')),
              ButtonSegment(value: 'ForRent', label: Text('For Rent')),
            ],
            selected: {statusType},
            onSelectionChanged: (Set<String> selected) {
              setState(() => statusType = selected.first);
            },
          ),

          const SizedBox(height: 24),

          // Price Range
          Text('Price Range', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Min Price',
                    prefixText: '\$',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    minPrice = double.tryParse(value);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Max Price',
                    prefixText: '\$',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    maxPrice = double.tryParse(value);
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Bedrooms
          Text('Bedrooms', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (int i = 1; i <= 5; i++)
                ChoiceChip(
                  label: Text('$i+'),
                  selected: beds == i,
                  onSelected: (selected) {
                    setState(() => beds = selected ? i : null);
                  },
                ),
            ],
          ),

          const SizedBox(height: 24),

          // Bathrooms
          Text('Bathrooms', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (int i = 1; i <= 4; i++)
                ChoiceChip(
                  label: Text('$i+'),
                  selected: baths == i,
                  onSelected: (selected) {
                    setState(() => baths = selected ? i : null);
                  },
                ),
            ],
          ),

          const SizedBox(height: 32),

          // Apply Button
          ElevatedButton(
            onPressed: () {
              final params = ref.read(propertySearchProvider).searchParams.copyWith(
                    statusType: statusType,
                    minPrice: minPrice,
                    maxPrice: maxPrice,
                    beds: beds,
                    baths: baths,
                    page: 1,
                  );

              ref.read(propertySearchProvider.notifier).updateFilters(params);
              Navigator.pop(context);
            },
            child: const Text('Apply Filters'),
          ),
        ],
      ),
    );
  }
}
