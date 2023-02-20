import 'package:goasbar/data_models/experience_response.dart';
import 'package:goasbar/data_models/timing_response.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';

class TimingItem extends StatelessWidget {
  const TimingItem({
    Key? key,
    this.showBooking,
    this.experience,
    this.timing,
    this.launchMaps,
    this.deleteTiming,
  }) : super(key: key);

  final Function()? showBooking;
  final Function()? launchMaps;
  final Function()? deleteTiming;
  final ExperienceResults? experience;
  final TimingResponse? timing;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            horizontalSpaceRegular,
            Text("Date : ${timing!.date}", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: kGrayText),),
            horizontalSpaceSmall,
            Text("At ${timing!.startTime!.substring(0, 5)}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500,),),
            const Spacer(),
            Text(timing!.status!, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: timing!.status! == "OPEN" ? kMainColor1 : Colors.redAccent),)
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
                  Image.asset("assets/icons/map_link.png", color: kMainColor1),
                  horizontalSpaceSmall,
                  const Text("Google maps", style: TextStyle(color: kGrayText),)
                ],
              ),
            ).gestures(onTap: launchMaps),
            horizontalSpaceSmall,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: kTextFiledGrayColor,
              ),
              child: Row(
                children: [
                  Image.asset("assets/icons/booking_places.png", color: kMainColor1),
                  horizontalSpaceSmall,
                  const Text("05 Booking", style: TextStyle(color: kGrayText),)
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
                  Image.asset("assets/icons/delete.png", color: Colors.redAccent, height: 18),
                ],
              ),
            ).gestures(onTap: deleteTiming,),
          ],
        ),
      ],
    );
  }
}