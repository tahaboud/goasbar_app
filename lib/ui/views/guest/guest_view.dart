import 'package:flutter/material.dart';
import 'package:goasbar/ui/views/guest/guest_viewmodel.dart';
import 'package:goasbar/ui/views/must_login_first/must_login_first_view.dart';
import 'package:goasbar/ui/views/navbar/experience/experience_view.dart';
import 'package:goasbar/ui/views/navbar/saved_experiences/saved_experiences_view.dart';
import 'package:goasbar/ui/views/navbar/search/search_view.dart';
import 'package:goasbar/ui/views/navbar/trips/trips_view.dart';
import 'package:stacked/stacked.dart';
import 'package:animations/animations.dart';

class GuestView extends StatelessWidget {
  const GuestView({Key? key, this.isGuest}) : super(key: key);
  final bool? isGuest;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GuestViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: PageTransitionSwitcher(
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
          child: getViewForIndex(model.currentIndex),
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
      viewModelBuilder: () => GuestViewModel(),
    );
  }

  Widget getViewForIndex(int index) {
    switch (index) {
      case 0:
        return ExperienceView(isGuest: isGuest);
      case 1:
        return const SearchView();
      case 2:
        return isGuest! ? const MustLoginFirstView(text: 'Trips',) : const TripsView(text: "Trips",);
      case 3:
        return isGuest! ? const MustLoginFirstView(text: 'Saved Experiences',) : const SavedExperiencesView(text: 'Saved Experiences',);
      case 4:
        return Container();
      default:
        return Container();
    }
  }
}
