import 'package:equatable/equatable.dart';

class AssetModel extends Equatable {
  final int? id;
  final String organization;
  final double? latitude;
  final double? longitude;
  final String? location;
  final String? building;
  final String? systems;
  final String? subSystems;
  final String? assetCodeLv5;
  final String? descLv5;
  final String? assetCodeLv6;
  final String? descLv6;
  final String? assetCodeLv7;
  final String? descLv7;
  final String kodeAset;
  final String? assetCategory;
  final String? merk;
  final String? serialNumber;
  final String? model;
  final DateTime? installedDate;
  final DateTime? warrantyDate;
  final String? capexOpex;
  final String? kepemilikan;
  final String? kondisi;
  final String? detailKondisi;
  final String? fungsiUtama;
  final String? photoAsset;
  final String? photoLabel;
  final int? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isDeleted;
  final String? syncStatus;

  const AssetModel({
    this.id,
    required this.organization,
    this.latitude,
    this.longitude,
    this.location,
    this.building,
    this.systems,
    this.subSystems,
    this.assetCodeLv5,
    this.descLv5,
    this.assetCodeLv6,
    this.descLv6,
    this.assetCodeLv7,
    this.descLv7,
    required this.kodeAset,
    this.assetCategory,
    this.merk,
    this.serialNumber,
    this.model,
    this.installedDate,
    this.warrantyDate,
    this.capexOpex,
    this.kepemilikan,
    this.kondisi,
    this.detailKondisi,
    this.fungsiUtama,
    this.photoAsset,
    this.photoLabel,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.isDeleted,
    this.syncStatus,
  });

  factory AssetModel.fromJson(Map<String, dynamic> json) {
    return AssetModel(
      id: json['id'],
      organization: json['organization'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      location: json['location'],
      building: json['building'],
      systems: json['systems'],
      subSystems: json['sub_systems'],
      assetCodeLv5: json['asset_code_lv5'],
      descLv5: json['desc_lv5'],
      assetCodeLv6: json['asset_code_lv6'],
      descLv6: json['desc_lv6'],
      assetCodeLv7: json['asset_code_lv7'],
      descLv7: json['desc_lv7'],
      kodeAset: json['kode_aset'],
      assetCategory: json['asset_category'],
      merk: json['merk'],
      serialNumber: json['serial_number'],
      model: json['model'],
      installedDate: json['installed_date'] != null ? DateTime.parse(json['installed_date']) : null,
      warrantyDate: json['warranty_date'] != null ? DateTime.parse(json['warranty_date']) : null,
      capexOpex: json['capex_opex'],
      kepemilikan: json['kepemilikan'],
      kondisi: json['kondisi'],
      detailKondisi: json['detail_kondisi'],
      fungsiUtama: json['fungsi_utama'],
      photoAsset: json['photo_asset'],
      photoLabel: json['photo_label'],
      createdBy: json['created_by'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      isDeleted: (json['is_deleted'] as int? ?? 0) == 1,
      syncStatus: json['sync_status'] ?? 'pending',
    );
  }

  factory AssetModel.fromMap(Map<String, dynamic> map) {
    return AssetModel(
      id: map['id'],
      organization: map['organization'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      location: map['location'],
      building: map['building'],
      systems: map['systems'],
      subSystems: map['sub_systems'],
      assetCodeLv5: map['asset_code_lv5'],
      descLv5: map['desc_lv5'],
      assetCodeLv6: map['asset_code_lv6'],
      descLv6: map['desc_lv6'],
      assetCodeLv7: map['asset_code_lv7'],
      descLv7: map['desc_lv7'],
      kodeAset: map['kode_aset'],
      assetCategory: map['asset_category'],
      merk: map['merk'],
      serialNumber: map['serial_number'],
      model: map['model'],
      installedDate: map['installed_date'] != null ? DateTime.parse(map['installed_date']) : null,
      warrantyDate: map['warranty_date'] != null ? DateTime.parse(map['warranty_date']) : null,
      capexOpex: map['capex_opex'],
      kepemilikan: map['kepemilikan'],
      kondisi: map['kondisi'],
      detailKondisi: map['detail_kondisi'],
      fungsiUtama: map['fungsi_utama'],
      photoAsset: map['photo_asset'],
      photoLabel: map['photo_label'],
      createdBy: map['created_by'],
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
      isDeleted: (map['is_deleted'] as int? ?? 0) == 1,
      syncStatus: map['sync_status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization': organization,
      'latitude': latitude,
      'longitude': longitude,
      'location': location,
      'building': building,
      'systems': systems,
      'sub_systems': subSystems,
      'asset_code_lv5': assetCodeLv5,
      'desc_lv5': descLv5,
      'asset_code_lv6': assetCodeLv6,
      'desc_lv6': descLv6,
      'asset_code_lv7': assetCodeLv7,
      'desc_lv7': descLv7,
      'kode_aset': kodeAset,
      'asset_category': assetCategory,
      'merk': merk,
      'serial_number': serialNumber,
      'model': model,
      'installed_date': installedDate?.toIso8601String(),
      'warranty_date': warrantyDate?.toIso8601String(),
      'capex_opex': capexOpex,
      'kepemilikan': kepemilikan,
      'kondisi': kondisi,
      'detail_kondisi': detailKondisi,
      'fungsi_utama': fungsiUtama,
      'photo_asset': photoAsset,
      'photo_label': photoLabel,
      'created_by': createdBy,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_deleted': (isDeleted ?? false) ? 1 : 0,
      'sync_status': syncStatus,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'organization': organization,
      'latitude': latitude,
      'longitude': longitude,
      'location': location,
      'building': building,
      'systems': systems,
      'sub_systems': subSystems,
      'asset_code_lv5': assetCodeLv5,
      'desc_lv5': descLv5,
      'asset_code_lv6': assetCodeLv6,
      'desc_lv6': descLv6,
      'asset_code_lv7': assetCodeLv7,
      'desc_lv7': descLv7,
      'kode_aset': kodeAset,
      'asset_category': assetCategory,
      'merk': merk,
      'serial_number': serialNumber,
      'model': model,
      'installed_date': installedDate?.toIso8601String(),
      'warranty_date': warrantyDate?.toIso8601String(),
      'capex_opex': capexOpex,
      'kepemilikan': kepemilikan,
      'kondisi': kondisi,
      'detail_kondisi': detailKondisi,
      'fungsi_utama': fungsiUtama,
      'photo_asset': photoAsset,
      'photo_label': photoLabel,
      'created_by': createdBy,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_deleted': (isDeleted ?? false) ? 1 : 0,
      'sync_status': syncStatus,
    };
  }

  AssetModel copyWith({
    int? id,
    String? organization,
    double? latitude,
    double? longitude,
    String? location,
    String? building,
    String? systems,
    String? subSystems,
    String? assetCodeLv5,
    String? descLv5,
    String? assetCodeLv6,
    String? descLv6,
    String? assetCodeLv7,
    String? descLv7,
    String? kodeAset,
    String? assetCategory,
    String? merk,
    String? serialNumber,
    String? model,
    DateTime? installedDate,
    DateTime? warrantyDate,
    String? capexOpex,
    String? kepemilikan,
    String? kondisi,
    String? detailKondisi,
    String? fungsiUtama,
    String? photoAsset,
    String? photoLabel,
    int? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    String? syncStatus,
  }) {
    return AssetModel(
      id: id ?? this.id,
      organization: organization ?? this.organization,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      location: location ?? this.location,
      building: building ?? this.building,
      systems: systems ?? this.systems,
      subSystems: subSystems ?? this.subSystems,
      assetCodeLv5: assetCodeLv5 ?? this.assetCodeLv5,
      descLv5: descLv5 ?? this.descLv5,
      assetCodeLv6: assetCodeLv6 ?? this.assetCodeLv6,
      descLv6: descLv6 ?? this.descLv6,
      assetCodeLv7: assetCodeLv7 ?? this.assetCodeLv7,
      descLv7: descLv7 ?? this.descLv7,
      kodeAset: kodeAset ?? this.kodeAset,
      assetCategory: assetCategory ?? this.assetCategory,
      merk: merk ?? this.merk,
      serialNumber: serialNumber ?? this.serialNumber,
      model: model ?? this.model,
      installedDate: installedDate ?? this.installedDate,
      warrantyDate: warrantyDate ?? this.warrantyDate,
      capexOpex: capexOpex ?? this.capexOpex,
      kepemilikan: kepemilikan ?? this.kepemilikan,
      kondisi: kondisi ?? this.kondisi,
      detailKondisi: detailKondisi ?? this.detailKondisi,
      fungsiUtama: fungsiUtama ?? this.fungsiUtama,
      photoAsset: photoAsset ?? this.photoAsset,
      photoLabel: photoLabel ?? this.photoLabel,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  @override
  List<Object?> get props => [id, kodeAset, serialNumber];
}
