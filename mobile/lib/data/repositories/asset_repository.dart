import 'package:asset_management/data/datasources/local/database_helper.dart';
import 'package:asset_management/data/datasources/remote/api_client.dart';
import 'package:asset_management/data/models/asset_model.dart';

class AssetRepository {
  final ApiClient apiClient;
  final DatabaseHelper databaseHelper;

  AssetRepository({
    required this.apiClient,
    required this.databaseHelper,
  });

  Future<int> createAsset(AssetModel asset) async {
    try {
      try {
        // Try to upload to server
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
      } catch (e) {
        // If server error, save locally
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
      try {
        // Try to update on server
        await apiClient.patch(
          '/assets/$id',
          data: asset.toJson(),
        );
        // Update locally
        await databaseHelper.updateAsset(id, {
          ...asset.toMap(),
          'sync_status': 'synced',
        });
      } catch (e) {
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
      try {
        await apiClient.delete('/assets/$id');
      } catch (e) {
        // Continue even if server delete fails
      }
      await databaseHelper.deleteAsset(id);
    } catch (e) {
      await databaseHelper.deleteAsset(id);
    }
  }
}
