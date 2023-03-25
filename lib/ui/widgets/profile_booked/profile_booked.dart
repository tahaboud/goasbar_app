import 'package:flutter/material.dart';
import 'package:goasbar/data_models/experience_response.dart';
import 'package:goasbar/data_models/provider_timing_booking_response.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/widgets/profile_booked/profile_booked_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class ProfileBookedView extends StatelessWidget {
  const ProfileBookedView({
    Key? key,
    this.booking,
    this.experience,
    this.index,
  }) : super(key: key);
  final ProviderTimingBookingResults? booking;
  final ExperienceResults? experience;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileBookedViewModel>.reactive(
      builder: (context, model, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: booking!.user!.image == null ? const AssetImage("assets/images/user.png")
                      : NetworkImage('$baseUrl${booking!.user!.image}') as ImageProvider,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(50),
              ),
            ).gestures(onTap: () => model.showProfile(experience: experience, booking: booking, index: index,)),
            horizontalSpaceSmall,
            Text("${booking!.user!.firstName} ${booking!.user!.lastName}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),).gestures(onTap: () => model.showProfile(booking: booking, experience: experience, index: index,)),
            const Spacer(),
            Text(booking!.status!, style: TextStyle(color: booking!.status == "CONFIRMED" ? kMainColor1 : Colors.redAccent, fontWeight: FontWeight.bold),),
          ],
        );
      },
      viewModelBuilder: () => ProfileBookedViewModel(),
    );
  }
}