import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asset_management/data/models/asset_model.dart';
import 'package:asset_management/presentation/providers/asset_provider.dart';

class AssetDetailScreen extends ConsumerWidget {
  final int assetId;

  const AssetDetailScreen({Key? key, required this.assetId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usecase = ref.watch(getAssetByIdUsecaseProvider);

    return FutureBuilder<AssetModel?>(
      future: usecase(assetId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('Asset Details')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Asset Details')),
            body: const Center(child: Text('Asset not found')),
          );
        }

        final asset = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Asset Details'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => Navigator.pushNamed(
                  context,
                  '/asset-form',
                  arguments: asset.id,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _showDeleteDialog(context, ref, asset),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.inventory_2,
                                size: 40,
                                color: Colors.blue.shade700,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    asset.kodeAset,
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    asset.merk ?? 'No brand',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _DetailInfo(
                                label: 'Kondisi',
                                value: asset.kondisi ?? 'N/A',
                              ),
                            ),
                            Expanded(
                              child: _DetailInfo(
                                label: 'Category',
                                value: asset.assetCategory ?? 'N/A',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Location section
                _DetailSection(
                  title: 'Location',
                  children: [
                    _DetailRow('Organization', asset.organization),
                    _DetailRow('Location', asset.location ?? 'N/A'),
                    _DetailRow('Building', asset.building ?? 'N/A'),
                    _DetailRow(
                      'GPS',
                      asset.latitude != null && asset.longitude != null
                          ? '${asset.latitude!.toStringAsFixed(6)}, ${asset.longitude!.toStringAsFixed(6)}'
                          : 'N/A',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Asset details section
                _DetailSection(
                  title: 'Asset Details',
                  children: [
                    _DetailRow('Serial Number', asset.serialNumber ?? 'N/A'),
                    _DetailRow('Model', asset.model ?? 'N/A'),
                    _DetailRow('Capex/Opex', asset.capexOpex ?? 'N/A'),
                    _DetailRow('Ownership', asset.kepemilikan ?? 'N/A'),
                  ],
                ),
                const SizedBox(height: 16),
                // Dates section
                _DetailSection(
                  title: 'Dates',
                  children: [
                    _DetailRow(
                      'Installed',
                      asset.installedDate?.toString().split(' ')[0] ?? 'N/A',
                    ),
                    _DetailRow(
                      'Warranty Until',
                      asset.warrantyDate?.toString().split(' ')[0] ?? 'N/A',
                    ),
                    _DetailRow(
                      'Created',
                      asset.createdAt?.toString().split(' ')[0] ?? 'N/A',
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, AssetModel asset) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Asset'),
        content: const Text('Are you sure you want to delete this asset?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await ref.read(deleteAssetUsecaseProvider)(asset.id!);
                ref.refresh(assetsProvider);
                if (context.mounted) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Asset deleted')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _DetailSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: children,
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailInfo extends StatelessWidget {
  final String label;
  final String value;

  const _DetailInfo({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
