import 'dart:convert';
import 'package:asset_management/data/datasources/local/database_helper.dart';
import 'package:asset_management/data/datasources/remote/api_client.dart';
import 'package:asset_management/data/models/asset_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class AssetRepository {
  final ApiClient apiClient;
  final DatabaseHelper databaseHelper;
  final Connectivity connectivity;

  AssetRepository({
    required this.apiClient,
    required this.databaseHelper,
    required this.connectivity,
  });

  Future<bool> _isOnline() async {
    final result = await connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<int> createAsset(AssetModel asset) async {
    try {
      if (await _isOnline()) {
        // Upload to server
        final response = await apiClient.post(
          '/assets',
          data: asset.toJson(),
        );
        if (response.statusCode == 201) {
          final createdAsset = AssetModel.fromJson(response.data);
          // Save to local database
          return await databaseHelper.insertAsset({
            ...createdAsset.toMap(),
            'sync_status': 'synced',
          });
        }
      } else {
        // Save locally for later sync
        return await databaseHelper.insertAsset({
          ...asset.toMap(),
          'sync_status': 'pending',
        });
      }
    } catch (e) {
      // Save locally on error
      return await databaseHelper.insertAsset({
        ...asset.toMap(),
        'sync_status': 'pending',
      });
    }
    throw Exception('Failed to create asset');
  }

  Future<List<AssetModel>> getAssets({String? search}) async {
    try {
      final localAssets = await databaseHelper.getAssets(search: search);
      return localAssets.map((asset) => AssetModel.fromMap(asset)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<AssetModel?> getAssetById(int id) async {
    try {
      final asset = await databaseHelper.getAssetById(id);
      return asset != null ? AssetModel.fromMap(asset) : null;
    } catch (e) {
      rethrow;
    }
  }

  Future<AssetModel?> getAssetBySerialNumber(String serialNumber) async {
    try {
      final asset = await databaseHelper.getAssetBySerialNumber(serialNumber);
      return asset != null ? AssetModel.fromMap(asset) : null;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateAsset(int id, AssetModel asset) async {
    try {
      if (await _isOnline()) {
        // Update on server
        await apiClient.patch(
          '/assets/$id',
          data: asset.toJson(),
        );
        // Update locally
        await databaseHelper.updateAsset(id, {
          ...asset.toMap(),
          'sync_status': 'synced',
        });
      } else {
        // Update locally only
        await databaseHelper.updateAsset(id, {
          ...asset.toMap(),
          'sync_status': 'pending',
        });
      }
    } catch (e) {
      // Update locally on error
      await databaseHelper.updateAsset(id, {
        ...asset.toMap(),
        'sync_status': 'pending',
      });
    }
  }

  Future<void> deleteAsset(int id) async {
    try {
      if (await _isOnline()) {
        await apiClient.delete('/assets/$id');
      }
      await databaseHelper.deleteAsset(id);
    } catch (e) {
      await databaseHelper.deleteAsset(id);
    }
  }

  Future<void> syncPendingAssets() async {
    try {
      if (!await _isOnline()) return;

      final pendingItems = await databaseHelper.getPendingSyncItems();
      for (final item in pendingItems) {
        try {
          final payload = jsonDecode(item['payload']);
          if (item['action'] == 'CREATE') {
            await apiClient.post('/assets', data: payload);
          } else if (item['action'] == 'UPDATE') {
            await apiClient.patch(
              '/assets/${item['resource_id']}',
              data: payload,
            );
          }
          await databaseHelper.updateSyncStatus(item['id'], 'synced');
        } catch (e) {
          // Continue with next item
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}
