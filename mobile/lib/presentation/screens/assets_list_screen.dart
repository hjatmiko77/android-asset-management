import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asset_management/presentation/providers/asset_provider.dart';
import 'package:asset_management/data/models/asset_model.dart';

class AssetsListScreen extends ConsumerStatefulWidget {
  const AssetsListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AssetsListScreen> createState() => _AssetsListScreenState();
}

class _AssetsListScreenState extends ConsumerState<AssetsListScreen> {
  final searchController = TextEditingController();
  String searchQuery = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final assetsAsync = searchQuery.isEmpty
        ? ref.watch(assetsProvider)
        : ref.watch(searchAssetsProvider(searchQuery));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assets'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search field
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() => searchQuery = value);
              },
              decoration: InputDecoration(
                hintText: 'Search by code, brand, serial...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          setState(() => searchQuery = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          // Assets list
          Expanded(
            child: assetsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              data: (assets) {
                if (assets.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          searchQuery.isEmpty ? 'No assets yet' : 'No results found',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: assets.length,
                  itemBuilder: (context, index) {
                    final asset = assets[index];
                    return _AssetTile(asset: asset);
                  },
                );
              },
              error: (error, stack) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AssetTile extends ConsumerWidget {
  final AssetModel asset;

  const _AssetTile({required this.asset});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color kondisiColor = Colors.green;
    if (asset.kondisi == 'Rusak Ringan') {
      kondisiColor = Colors.orange;
    } else if (asset.kondisi?.contains('Rusak') ?? false) {
      kondisiColor = Colors.red;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        child: ListTile(
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.inventory_2,
              color: Colors.blue.shade700,
            ),
          ),
          title: Text(
            asset.kodeAset,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '${asset.merk ?? 'No brand'} • ${asset.kondisi ?? 'Unknown'}',
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: kondisiColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              asset.kondisi ?? 'N/A',
              style: TextStyle(
                color: kondisiColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/asset-detail',
              arguments: asset.id,
            );
          },
        ),
      ),
    );
  }
}
