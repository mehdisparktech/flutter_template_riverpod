// ignore_for_file: depend_on_referenced_packages, must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template_riverpod/app.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'providers/providers_logger.dart';
import 'providers/services_providers.dart';
import 'services/device_info/device_info_service.dart';
import 'services/storage/hive_storage_service.dart';

/// Function first called when running the project
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // To load the .env file contents into dotenv
  await dotenv.load();

  /// Removes hash from the Web routes
  usePathUrlStrategy();

  /// Initialize EasyLocalization
  await EasyLocalization.ensureInitialized();

  /// Initialize Hive
  await Hive.initFlutter();
  final hiveStorageService = HiveStorageService();
  await hiveStorageService.openBox('template_app');

  final deviceInfoService = DeviceInfoService();
  await deviceInfoService.initProperInfo();

  /// Initialize Firebase
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  /// Run the `RiverpodTemplateApp` app
  runApp(
    ProviderScope(
      observers: [ProvidersLogger()],
      overrides: [
        storageServiceProvider.overrideWithValue(hiveStorageService),
        deviceInfoServiceProvider.overrideWithValue(deviceInfoService),
      ],
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('hr')],
        path: 'assets/translations',
        useOnlyLangCode: true,
        fallbackLocale: const Locale('en'),
        child: RiverpodTemplateApp(),
      ),
    ),
  );
}
