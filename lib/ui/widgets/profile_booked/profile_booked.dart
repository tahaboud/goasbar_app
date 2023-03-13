import 'package:flutter/cupertino.dart';
import 'package:goasbar/data_models/user_for_provider_timing_booking.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/widgets/profile_booked/profile_booked_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class ProfileBookedView extends StatelessWidget {
  const ProfileBookedView({
    Key? key,
    this.user,
    this.experienceId,
  }) : super(key: key);
  final UserForProviderTimingBooking? user;
  final int? experienceId;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileBookedViewModel>.reactive(
      builder: (context, model, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset("assets/images/user.png", ).gestures(onTap: () => model.showProfile(experienceId: experienceId, user: user)),
            horizontalSpaceSmall,
            Text("${user!.firstName} ${user!.lastName}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),).gestures(onTap: () => model.showProfile(user: user, experienceId: experienceId)),
            const Spacer(),
            const Text("Completed", style: TextStyle(color: kMainColor1, fontWeight: FontWeight.bold),),
          ],
        );
      },
      viewModelBuilder: () => ProfileBookedViewModel(),
    );
  }
}