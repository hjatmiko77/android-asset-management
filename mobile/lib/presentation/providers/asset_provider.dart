import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:asset_management/data/datasources/local/database_helper.dart';
import 'package:asset_management/data/repositories/asset_repository.dart';
import 'package:asset_management/data/models/asset_model.dart';
import 'package:asset_management/domain/usecases/asset_usecases.dart';
import 'package:asset_management/presentation/providers/auth_provider.dart';

final databaseHelperProvider = Provider((ref) => DatabaseHelper());

final connectivityProvider = Provider((ref) => Connectivity());

final assetRepositoryProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final database = ref.watch(databaseHelperProvider);
  final connectivity = ref.watch(connectivityProvider);
  return AssetRepository(
    apiClient: apiClient,
    databaseHelper: database,
    connectivity: connectivity,
  );
});

final createAssetUsecaseProvider = Provider((ref) {
  final repository = ref.watch(assetRepositoryProvider);
  return CreateAssetUsecase(repository);
});

final getAssetsUsecaseProvider = Provider((ref) {
  final repository = ref.watch(assetRepositoryProvider);
  return GetAssetsUsecase(repository);
});

final getAssetByIdUsecaseProvider = Provider((ref) {
  final repository = ref.watch(assetRepositoryProvider);
  return GetAssetByIdUsecase(repository);
});

final getAssetBySerialNumberUsecaseProvider = Provider((ref) {
  final repository = ref.watch(assetRepositoryProvider);
  return GetAssetBySerialNumberUsecase(repository);
});

final updateAssetUsecaseProvider = Provider((ref) {
  final repository = ref.watch(assetRepositoryProvider);
  return UpdateAssetUsecase(repository);
});

final deleteAssetUsecaseProvider = Provider((ref) {
  final repository = ref.watch(assetRepositoryProvider);
  return DeleteAssetUsecase(repository);
});

final syncPendingAssetsUsecaseProvider = Provider((ref) {
  final repository = ref.watch(assetRepositoryProvider);
  return SyncPendingAssetsUsecase(repository);
});

final assetsProvider = FutureProvider<List<AssetModel>>((ref) async {
  final usecase = ref.watch(getAssetsUsecaseProvider);
  return await usecase();
});

final searchAssetsProvider = FutureProvider.family<List<AssetModel>, String>((ref, query) async {
  final usecase = ref.watch(getAssetsUsecaseProvider);
  return await usecase(search: query);
});
