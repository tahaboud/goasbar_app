import 'package:flutter/material.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/ui/views/home/home_viewmodel.dart';
import 'package:goasbar/ui/views/must_login_first/must_login_first_view.dart';
import 'package:goasbar/ui/views/navbar/experience/experience_view.dart';
import 'package:goasbar/ui/views/navbar/saved_experiences/saved_experiences_view.dart';
import 'package:goasbar/ui/views/navbar/search/search_view.dart';
import 'package:goasbar/ui/views/navbar/settings/settings_view.dart';
import 'package:goasbar/ui/views/navbar/trips/trips_view.dart';
import 'package:stacked/stacked.dart';
import 'package:animations/animations.dart';
import 'package:goasbar/ui/widgets/loader.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key, this.isUser}) : super(key: key);
  final bool? isUser;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: model.isBusy ? const Loader() : PageTransitionSwitcher(
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
          child: getViewForIndex(index: model.currentIndex, isUser: isUser, user: model.user),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          currentIndex: model.currentIndex,
          onTap: model.setIndex,
          items: [
            BottomNavigationBarItem(
              label: 'Experience',
              icon: Image.asset("assets/icons/navbar/experience.png"),
            ),
            BottomNavigationBarItem(
              label: 'Search',
              icon: Image.asset("assets/icons/navbar/search.png"),
            ),
            BottomNavigationBarItem(
              label: 'Trips',
              icon: Image.asset("assets/icons/navbar/trips.png"),
            ),
            BottomNavigationBarItem(
              label: 'Saved',
              icon: Image.asset("assets/icons/navbar/saved.png"),
            ),
            BottomNavigationBarItem(
              label: 'Settings',
              icon: Image.asset("assets/icons/navbar/settings.png"),
            ),
          ],
        ),
      ),
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (model) => model.getUserData(),
    );
  }

  Widget getViewForIndex({int? index, bool? isUser, UserModel? user}) {
    switch (index) {
      case 0:
        return ExperienceView(isUser: isUser, user: user);
      case 1:
        return SearchView(user: user);
      case 2:
        return isUser! ? TripsView(text: "Trips", user: user) : const MustLoginFirstView(text: 'Trips');
      case 3:
        return isUser! ? SavedExperiencesView(text: 'Saved Experiences', user: user) : const MustLoginFirstView(text: 'Saved Experiences',);
      case 4:
        return SettingsView(isUser: isUser, user: user);
      default:
        return Container();
    }
  }
}
