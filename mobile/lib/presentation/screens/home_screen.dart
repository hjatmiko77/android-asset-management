import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asset_management/presentation/providers/auth_provider.dart';
import 'package:asset_management/presentation/providers/asset_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(currentUserProvider);
    final assetsState = ref.watch(assetsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Asset Management'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(currentUserProvider.notifier).logout();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(assetsProvider);
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              // User info card
              userState.whenData((user) {
                if (user != null) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 32,
                              backgroundColor: Colors.blue.shade100,
                              child: Icon(
                                Icons.person,
                                size: 32,
                                color: Colors.blue.shade700,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.fullname ?? user.username,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    user.role,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox();
              }).value ?? const SizedBox(),
              // Stats section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        title: 'Total Assets',
                        value: assetsState.whenData((assets) => assets.length.toString()).value ?? '0',
                        icon: Icons.inventory_2,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        title: 'Active',
                        value: assetsState.whenData((assets) => assets.where((a) => a.kondisi == 'Baik').length.toString()).value ?? '0',
                        icon: Icons.check_circle,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Assets list section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Assets',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/assets'),
                      child: const Text('View All'),
                    ),
                  ],
                ),
              ),
              assetsState.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
                data: (assets) {
                  if (assets.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.inbox,
                              size: 64,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No assets yet',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: assets.take(5).length,
                    itemBuilder: (context, index) {
                      final asset = assets[index];
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
                            title: Text(asset.kodeAset),
                            subtitle: Text(asset.merk ?? 'No brand'),
                            trailing: Icon(
                              asset.kondisi == 'Baik' ? Icons.check_circle : Icons.warning,
                              color: asset.kondisi == 'Baik' ? Colors.green : Colors.orange,
                            ),
                            onTap: () => Navigator.pushNamed(
                              context,
                              '/asset-detail',
                              arguments: asset.id,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                error: (error, stack) => Center(
                  child: Text('Error: $error'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'scan',
            mini: true,
            onPressed: () => Navigator.pushNamed(context, '/scan-barcode'),
            tooltip: 'Scan Barcode',
            child: const Icon(Icons.qr_code_2),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'add',
            onPressed: () => Navigator.pushNamed(context, '/asset-form'),
            tooltip: 'Add Asset',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.blue.shade700),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
