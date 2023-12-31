import 'package:goasbar/services/booking_api_service.dart';
import 'package:goasbar/services/chat_api_service.dart';
import 'package:goasbar/services/connectivity_service.dart';
import 'package:goasbar/services/experience_api_service.dart';
import 'package:goasbar/services/media_service.dart';
import 'package:goasbar/services/review_api_service.dart';
import 'package:goasbar/ui/views/home/home_view.dart';
import 'package:goasbar/ui/views/login/login_view.dart';
import 'package:goasbar/ui/views/splash/splash_view.dart';
import 'package:goasbar/services/validation_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:goasbar/services/auth_service.dart';
import 'package:goasbar/services/provider_api_service.dart';
import 'package:goasbar/services/timing_api_service.dart';
import 'package:goasbar/services/url_service.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(
  dependencies: [
    LazySingleton(classType: DialogService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: ValidationService),
    LazySingleton(classType: MediaService),
    LazySingleton(classType: TokenService),
    LazySingleton(classType: UrlService),
    LazySingleton(classType: AuthService),
    LazySingleton(classType: ProviderApiService),
    LazySingleton(classType: ExperienceApiService),
    LazySingleton(classType: TimingApiService),
    LazySingleton(classType: BookingApiService),
    LazySingleton(classType: ReviewApiService),
    LazySingleton(classType: ChatApiService),
    LazySingleton(classType: ConnectivityService),
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