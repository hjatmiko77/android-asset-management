import 'package:asset_management/data/repositories/asset_repository.dart';
import 'package:asset_management/data/models/asset_model.dart';

class CreateAssetUsecase {
  final AssetRepository repository;

  CreateAssetUsecase(this.repository);

  Future<int> call(AssetModel asset) async {
    return await repository.createAsset(asset);
  }
}

class GetAssetsUsecase {
  final AssetRepository repository;

  GetAssetsUsecase(this.repository);

  Future<List<AssetModel>> call({String? search}) async {
    return await repository.getAssets(search: search);
  }
}

class GetAssetByIdUsecase {
  final AssetRepository repository;

  GetAssetByIdUsecase(this.repository);

  Future<AssetModel?> call(int id) async {
    return await repository.getAssetById(id);
  }
}

class GetAssetBySerialNumberUsecase {
  final AssetRepository repository;

  GetAssetBySerialNumberUsecase(this.repository);

  Future<AssetModel?> call(String serialNumber) async {
    return await repository.getAssetBySerialNumber(serialNumber);
  }
}

class UpdateAssetUsecase {
  final AssetRepository repository;

  UpdateAssetUsecase(this.repository);

  Future<void> call(int id, AssetModel asset) async {
    return await repository.updateAsset(id, asset);
  }
}

class DeleteAssetUsecase {
  final AssetRepository repository;

  DeleteAssetUsecase(this.repository);

  Future<void> call(int id) async {
    return await repository.deleteAsset(id);
  }
}
