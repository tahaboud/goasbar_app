import 'package:flutter/material.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/navbar/trips/trips_viewmodel.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:goasbar/ui/widgets/trip_card/trip_card.dart';

class Trips extends StatelessWidget {
  const Trips({
    Key? key,
    required this.text,
    this.model,
  }) : super(key: key);

  final String? text;
  final TripsViewModel? model;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        verticalSpaceMedium,
        Text(text!, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
        verticalSpaceMedium,
        SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              categoryItem(model: model, image: "all.png", index: 1, text: "All"),
              horizontalSpaceSmall,
              categoryItem(model: model, index: 2, text: "Upcoming"),
              horizontalSpaceSmall,
              categoryItem(model: model, index: 3, text: "Completed"),
            ],
          ),
        ),
        verticalSpaceMedium,
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: const [
              TripItem(),
              verticalSpaceRegular,
              TripItem(),
              verticalSpaceRegular,
              TripItem(),
            ],
          ),
        ),
      ],
    );
  }

  Widget categoryItem({TripsViewModel? model, int? index, String? image, String? text}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 10),
      child: Row(
        children: [
          index == 1 ? Image.asset("assets/icons/categories/$image", color: model!.index == index ? Colors.white : kMainGray) : Container(),
          horizontalSpaceTiny,
          Text(text!, style: TextStyle(color: model!.index == index ? Colors.white : kMainGray,)),
        ],
      ),
    ).backgroundGradient(model.index == index ? kMainGradient : kDisabledGradient, animate: true)
        .clipRRect(all: 10)
        .animate(const Duration(milliseconds: 200), Curves.easeIn)
        .gestures(onTap: () {
      model.selectCategory(ind: index);
    });
  }
}