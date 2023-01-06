import 'package:goasbar/ui/views/home/home_view.dart';
import 'package:goasbar/ui/views/login/login_view.dart';
import 'package:goasbar/ui/views/splash/splash_view.dart';
import 'package:goasbar/services/validation_service.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(
  dependencies: [
    LazySingleton(classType: DialogService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: ValidationService),
  ],
  routes: [
    MaterialRoute(
      page: SplashView,
      name: 'splashView',
      initial: true,
    ),
    MaterialRoute(
      page: HomeView,
      name: 'homeView',
    ),
    MaterialRoute(
      page: LoginView,
      name: 'loginView',
    ),
  ],
)
class App {
  /** This class has no puporse besides housing the annotation that generates the required functionality **/
}