import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/data_models/experience_response.dart';
import 'package:goasbar/data_models/timing_response.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:styled_widget/styled_widget.dart';

class TimingItem extends StatelessWidget {
  const TimingItem({
    super.key,
    this.showBooking,
    this.experience,
    this.timing,
    this.bookings,
    this.deleteTiming,
  });

  final Function()? showBooking;
  final Function()? deleteTiming;
  final ExperienceResults? experience;
  final TimingResponse? timing;
  final int? bookings;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            horizontalSpaceRegular,
            Text(
              "${'Date'.tr()}: ${timing!.date}",
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w500, color: kGrayText),
            ),
            horizontalSpaceSmall,
            Text(
              "${'At'.tr()} ${timing!.startTime!.substring(0, 5)}",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Text(
              timing!.status!.tr(),
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: timing!.status! == "OPEN"
                      ? kMainColor1
                      : Colors.redAccent),
            )
          ],
        ),
        verticalSpaceSmall,
        Row(
          children: [
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: kMainColor1,
              ),
            ),
            horizontalSpaceSmall,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: kTextFiledGrayColor,
              ),
              child: Row(
                children: [
                  Image.asset("assets/icons/booking_places.png",
                      color: kMainColor1),
                  horizontalSpaceSmall,
                  Text(
                    "$bookings ${'Booking'.tr()}",
                    style: const TextStyle(color: kGrayText),
                  )
                ],
              ),
            ).gestures(onTap: showBooking),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 3),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Color(0x33FF8A80),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/icons/delete.png",
                      color: Colors.redAccent, height: 18),
                ],
              ),
            ).gestures(
              onTap: deleteTiming,
            ),
          ],
        ),
      ],
    );
  }
}
