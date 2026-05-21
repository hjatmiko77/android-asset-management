class AppConstants {
  // User Roles
  static const String roleAdmin = 'admin';
  static const String roleUser = 'user';

  // Asset Status
  static const String assetStatusActive = 'active';
  static const String assetStatusInactive = 'inactive';
  static const String assetStatusMaintenance = 'maintenance';

  // Condition Types
  static const List<String> conditionTypes = [
    'Baik',
    'Cukup Baik',
    'Rusak Ringan',
    'Rusak Berat',
    'Tidak Berfungsi',
  ];

  // Capex/Opex
  static const List<String> capitalTypes = [
    'Capex',
    'Opex',
  ];

  // Asset Categories
  static const List<String> assetCategories = [
    'Hardware',
    'Software',
    'Furniture',
    'Vehicles',
    'Equipment',
    'Infrastructure',
    'Other',
  ];

  // Validation Patterns
  static const String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phonePattern = r'^[0-9]{10,12}$';

  // Storage Keys
  static const String keyAuthToken = 'auth_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserData = 'user_data';
  static const String keySyncStatus = 'sync_status';
}
