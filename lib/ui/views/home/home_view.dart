import 'package:animations/animations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/ui/views/home/home_viewmodel.dart';
import 'package:goasbar/ui/views/must_login_first/must_login_first_view.dart';
import 'package:goasbar/ui/views/navbar/experience/experience_view.dart';
import 'package:goasbar/ui/views/navbar/saved_experiences/saved_experiences_view.dart';
import 'package:goasbar/ui/views/navbar/search/search_view.dart';
import 'package:goasbar/ui/views/navbar/settings/settings_view.dart';
import 'package:goasbar/ui/views/navbar/trips/trips_view.dart';
import 'package:goasbar/ui/views/settings_pages/post_experience/post_experience_view.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key, this.isUser, this.index = 0});
  final bool? isUser;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          body: !model.thereIsConnection!
              ? const Text('No Internet Connection, please check your internet')
                  .center()
                  .gestures(onTap: () => model.getConnectivityStatus())
              : model.isBusy
                  ? const Loader()
                  : PageTransitionSwitcher(
                      duration: const Duration(milliseconds: 300),
                      reverse: model.reverse,
                      transitionBuilder: (
                        Widget child,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation,
                      ) {
                        return SharedAxisTransition(
                          animation: animation,
                          secondaryAnimation: secondaryAnimation,
                          transitionType: SharedAxisTransitionType.horizontal,
                          child: child,
                        );
                      },
                      child: getViewForIndex(
                        index: model.currentIndex,
                        isUser: isUser,
                        user: model.user,
                      ),
                    ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            currentIndex: model.currentIndex,
            onTap: (index) {
              if (isUser == true) {
                model.getUserData(context: context);
              }
              model.setIndex(index);
            },
            items: [
              BottomNavigationBarItem(
                label: 'Experience'.tr(),
                icon: SizedBox(
                  height: 35,
                  child: Image.asset("assets/icons/navbar/experience.ico"),
                ),
              ),
              BottomNavigationBarItem(
                label: 'Search'.tr(),
                icon: SizedBox(
                    height: 35,
                    child: Image.asset("assets/icons/navbar/search.png")),
              ),
              BottomNavigationBarItem(
                label: 'Trips'.tr(),
                icon: SizedBox(
                    height: 35,
                    child: Image.asset("assets/icons/navbar/trips.png")),
              ),
              BottomNavigationBarItem(
                label: 'Saved'.tr(),
                icon: SizedBox(
                    height: 35,
                    child: Image.asset("assets/icons/navbar/saved.png")),
              ),
              if (model.user?.isProvider == true)
                BottomNavigationBarItem(
                  label: 'My Experience'.tr(),
                  icon: SizedBox(
                    height: 35,
                    child: Image.asset("assets/icons/navbar/trips.png"),
                  ),
                ),
              BottomNavigationBarItem(
                label: 'Settings'.tr(),
                icon: SizedBox(
                    height: 35,
                    child: Image.asset("assets/icons/navbar/settings.png")),
              ),
            ],
          ),
        );
      },
      viewModelBuilder: () => HomeViewModel(),
      onViewModelReady: (model) =>
          !isUser! ? {} : model.getConnectivityStatus(context: context),
    );
  }

  Widget getViewForIndex({int? index, bool? isUser, UserModel? user}) {
    switch (index) {
      case 0:
        return ExperienceView(isUser: isUser, user: user);
      case 1:
        return SearchView(
          user: user,
          isUser: isUser,
        );
      case 2:
        return isUser!
            ? TripsView(text: "Trips".tr(), user: user)
            : MustLoginFirstView(text: 'Trips'.tr());
      case 3:
        return isUser!
            ? SavedExperiencesView(
                isUser: isUser, text: 'Saved Experiences'.tr(), user: user)
            : MustLoginFirstView(
                text: 'Saved Experiences'.tr(),
              );
      case 4:
        return user != null && user.isProvider == true
            ? const PostExperienceView()
            : SettingsView(isUser: isUser, user: user);
      case 5:
        return SettingsView(isUser: isUser, user: user);
      default:
        return Container();
    }
  }
}
