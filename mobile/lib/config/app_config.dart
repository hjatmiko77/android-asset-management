class AppConfig {
  static const String appName = 'Asset Management Enterprise';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const String apiBaseUrl = 'http://localhost:8000/api';
  static const String apiBaseUrlProduction = 'https://api.example.com';

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration syncInterval = Duration(minutes: 5);

  // Database
  static const String databaseName = 'asset_management.db';
  static const int databaseVersion = 1;

  // Feature Flags
  static const bool enableOfflineMode = true;
  static const bool enableAutoSync = true;
  static const bool enableDarkMode = true;

  // Logging
  static const bool enableLogging = true;
  static const bool enableAnalytics = false;
}
