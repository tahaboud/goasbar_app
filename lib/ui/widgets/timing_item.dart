import 'package:styled_widget/styled_widget.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';

class TimingItem extends StatelessWidget {
  const TimingItem({
    Key? key,
    this.showBooking
  }) : super(key: key);

  final Function()? showBooking;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            horizontalSpaceRegular,
            Text("Date : 20 - 06 - 2022", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: kGrayText),),
            horizontalSpaceSmall,
            Text("At 1:00 PM", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,),),
            Spacer(),
            Text('CLOSED...', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.redAccent),)
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
            ).gestures(onTap: () {
            }),
          ],
        ),
      ],
    );
  }
}