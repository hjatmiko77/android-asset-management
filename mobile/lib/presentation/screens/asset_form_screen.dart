import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:asset_management/data/models/asset_model.dart';
import 'package:asset_management/presentation/providers/asset_provider.dart';
import 'package:asset_management/core/constants/app_constants.dart';

class AssetFormScreen extends ConsumerStatefulWidget {
  final int? assetId;

  const AssetFormScreen({Key? key, this.assetId}) : super(key: key);

  @override
  ConsumerState<AssetFormScreen> createState() => _AssetFormScreenState();
}

class _AssetFormScreenState extends ConsumerState<AssetFormScreen> {
  late TextEditingController organizationController;
  late TextEditingController locationController;
  late TextEditingController buildingController;
  late TextEditingController kodeAsetController;
  late TextEditingController merkController;
  late TextEditingController serialNumberController;
  late TextEditingController modelController;
  late TextEditingController kondisiController;

  String? selectedCategory;
  String? selectedCapexOpex;
  String? selectedCondition;
  double? latitude;
  double? longitude;
  String? photoAssetPath;
  String? photoLabelPath;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    organizationController = TextEditingController();
    locationController = TextEditingController();
    buildingController = TextEditingController();
    kodeAsetController = TextEditingController();
    merkController = TextEditingController();
    serialNumberController = TextEditingController();
    modelController = TextEditingController();
    kondisiController = TextEditingController();
  }

  @override
  void dispose() {
    organizationController.dispose();
    locationController.dispose();
    buildingController.dispose();
    kodeAsetController.dispose();
    merkController.dispose();
    serialNumberController.dispose();
    modelController.dispose();
    kondisiController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location captured')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _pickImage(bool isAssetPhoto) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          if (isAssetPhoto) {
            photoAssetPath = image.path;
          } else {
            photoLabelPath = image.path;
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _saveAsset() async {
    if (kodeAsetController.text.isEmpty || organizationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill required fields')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final asset = AssetModel(
        organization: organizationController.text,
        location: locationController.text.isEmpty ? null : locationController.text,
        building: buildingController.text.isEmpty ? null : buildingController.text,
        kodeAset: kodeAsetController.text,
        assetCategory: selectedCategory,
        merk: merkController.text.isEmpty ? null : merkController.text,
        serialNumber: serialNumberController.text.isEmpty ? null : serialNumberController.text,
        model: modelController.text.isEmpty ? null : modelController.text,
        kondisi: selectedCondition,
        capexOpex: selectedCapexOpex,
        latitude: latitude,
        longitude: longitude,
        photoAsset: photoAssetPath,
        photoLabel: photoLabelPath,
      );

      if (widget.assetId != null) {
        await ref.read(updateAssetUsecaseProvider)(widget.assetId!, asset);
      } else {
        await ref.read(createAssetUsecaseProvider)(asset);
      }

      ref.refresh(assetsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Asset saved successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.assetId != null ? 'Edit Asset' : 'New Asset'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location Data Section
            _SectionTitle('Location Data'),
            TextField(
              controller: organizationController,
              decoration: InputDecoration(
                labelText: 'Organization *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(
                      text: latitude != null ? latitude!.toStringAsFixed(6) : '',
                    ),
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: 'Latitude',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: TextEditingController(
                      text: longitude != null ? longitude!.toStringAsFixed(6) : '',
                    ),
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: 'Longitude',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.location_on),
                  onPressed: _getCurrentLocation,
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: buildingController,
              decoration: InputDecoration(
                labelText: 'Building',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Asset Detail Section
            _SectionTitle('Asset Details'),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: AppConstants.assetCategories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => selectedCategory = value);
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: kodeAsetController,
              decoration: InputDecoration(
                labelText: 'Kode Aset *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: merkController,
              decoration: InputDecoration(
                labelText: 'Brand/Merk',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: serialNumberController,
              decoration: InputDecoration(
                labelText: 'Serial Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: modelController,
              decoration: InputDecoration(
                labelText: 'Model',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedCondition,
              decoration: InputDecoration(
                labelText: 'Kondisi',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: AppConstants.conditionTypes.map((condition) {
                return DropdownMenuItem(
                  value: condition,
                  child: Text(condition),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => selectedCondition = value);
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedCapexOpex,
              decoration: InputDecoration(
                labelText: 'Capex/Opex',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: AppConstants.capitalTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => selectedCapexOpex = value);
              },
            ),
            const SizedBox(height: 24),
            // Photos Section
            _SectionTitle('Photos'),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickImage(true),
                    icon: const Icon(Icons.camera),
                    label: const Text('Asset Photo'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickImage(false),
                    icon: const Icon(Icons.camera),
                    label: const Text('Label Photo'),
                  ),
                ),
              ],
            ),
            if (photoAssetPath != null)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text('Asset photo: ${photoAssetPath?.split('/').last}'),
              ),
            if (photoLabelPath != null)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text('Label photo: ${photoLabelPath?.split('/').last}'),
              ),
            const SizedBox(height: 24),
            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _saveAsset,
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : const Text('Save Asset'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
