import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asset_management/presentation/screens/login_screen.dart';
import 'package:asset_management/presentation/screens/home_screen.dart';
import 'package:asset_management/presentation/screens/asset_form_screen.dart';
import 'package:asset_management/presentation/screens/barcode_scanner_screen.dart';
import 'package:asset_management/presentation/screens/assets_list_screen.dart';
import 'package:asset_management/presentation/screens/asset_detail_screen.dart';
import 'package:asset_management/presentation/providers/auth_provider.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(currentUserProvider);

    return MaterialApp(
      title: 'Asset Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: authState.when(
        loading: () => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        data: (user) {
          if (user != null) {
            return const HomeScreen();
          }
          return const LoginScreen();
        },
        error: (error, stack) => const LoginScreen(),
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/asset-form': (context) => const AssetFormScreen(),
        '/scan-barcode': (context) => const BarcodeScannerScreen(),
        '/assets': (context) => const AssetsListScreen(),
        '/asset-detail': (context) {
          final assetId = ModalRoute.of(context)?.settings.arguments as int?;
          if (assetId != null) {
            return AssetDetailScreen(assetId: assetId);
          }
          return const AssetsListScreen();
        },
      },
    );
  }
}
