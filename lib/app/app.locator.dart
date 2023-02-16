// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, implementation_imports, depend_on_referenced_packages

import 'package:goasbar/services/auth_service.dart';
import 'package:goasbar/services/experience_api_service.dart';
import 'package:goasbar/services/provider_api_service.dart';
import 'package:stacked_core/stacked_core.dart';
import 'package:stacked_services/src/bottom_sheet/bottom_sheet_service.dart';
import 'package:stacked_services/src/dialog/dialog_service.dart';
import 'package:stacked_services/src/navigation/navigation_service.dart';
import 'package:stacked_services/src/snackbar/snackbar_service.dart';

import '../services/media_service.dart';
import '../services/token_service.dart';
import '../services/url_service.dart';
import '../services/validation_service.dart';

final locator = StackedLocator.instance;

Future<void> setupLocator(
    {String? environment, EnvironmentFilter? environmentFilter}) async {
// Register environments
  locator.registerEnvironment(
      environment: environment, environmentFilter: environmentFilter);

// Register dependencies
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => SnackbarService());
  locator.registerLazySingleton(() => BottomSheetService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => ValidationService());
  locator.registerLazySingleton(() => MediaService());
  locator.registerLazySingleton(() => TokenService());
  locator.registerLazySingleton(() => UrlService());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => ProviderApiService());
  locator.registerLazySingleton(() => ExperienceApiService());
}
