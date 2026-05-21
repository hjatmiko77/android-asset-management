import 'package:asset_management/data/repositories/asset_repository.dart';
import 'package:asset_management/data/models/asset_model.dart';

class CreateAssetUsecase {
  final AssetRepository repository;

  CreateAssetUsecase(this.repository);

  Future<int> call(AssetModel asset) {
    return repository.createAsset(asset);
  }
}

class GetAssetsUsecase {
  final AssetRepository repository;

  GetAssetsUsecase(this.repository);

  Future<List<AssetModel>> call({String? search}) {
    return repository.getAssets(search: search);
  }
}

class GetAssetByIdUsecase {
  final AssetRepository repository;

  GetAssetByIdUsecase(this.repository);

  Future<AssetModel?> call(int id) {
    return repository.getAssetById(id);
  }
}

class GetAssetBySerialNumberUsecase {
  final AssetRepository repository;

  GetAssetBySerialNumberUsecase(this.repository);

  Future<AssetModel?> call(String serialNumber) {
    return repository.getAssetBySerialNumber(serialNumber);
  }
}

class UpdateAssetUsecase {
  final AssetRepository repository;

  UpdateAssetUsecase(this.repository);

  Future<void> call(int id, AssetModel asset) {
    return repository.updateAsset(id, asset);
  }
}

class DeleteAssetUsecase {
  final AssetRepository repository;

  DeleteAssetUsecase(this.repository);

  Future<void> call(int id) {
    return repository.deleteAsset(id);
  }
}

class SyncPendingAssetsUsecase {
  final AssetRepository repository;

  SyncPendingAssetsUsecase(this.repository);

  Future<void> call() {
    return repository.syncPendingAssets();
  }
}
