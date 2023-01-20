import 'package:flutter/cupertino.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/widgets/profile_booked/profile_booked_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class ProfileBookedView extends StatelessWidget {
  const ProfileBookedView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileBookedViewModel>.reactive(
      builder: (context, model, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset("assets/images/user.png", ).gestures(onTap: () => model.showProfile()),
            horizontalSpaceSmall,
            const Text("Yahia Abdeldjalil", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),).gestures(onTap: () => model.showProfile()),
            const Spacer(),
            const Text("Completed", style: TextStyle(color: kMainColor1, fontWeight: FontWeight.bold),),
          ],
        );
      },
      viewModelBuilder: () => ProfileBookedViewModel(),
    );
  }
}