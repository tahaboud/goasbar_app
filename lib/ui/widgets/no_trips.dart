import 'package:flutter/material.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:styled_widget/styled_widget.dart';

class NoTrips extends StatelessWidget {
  const NoTrips({
    Key? key,
    required this.text,
    this.onTap,
  }) : super(key: key);

  final String? text;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        verticalSpaceMedium,
        Text(text!, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
        const Divider(height: 40, thickness: 1),
        const Text('No upcoming trips yet !', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),),
        verticalSpaceSmall,
        const Text('Start explorer new trips in your weekend & share new memories', style: TextStyle(color: kMainGray)),
        verticalSpaceMedium,
        Container(
          width: 130,
          padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,
            border: Border.all(color: kMainDisabledGray),
          ),
          child: Row(
            children: [
              Image.asset("assets/icons/navbar/search.png",),
              horizontalSpaceSmall,
              const Text('Discover', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
            ],
          ),
        ).gestures(onTap: onTap!,),
        verticalSpaceMedium,
        Image.asset('assets/images/no_trips.png'),
      ],
    );
  }
}