import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/trip_detail/trip_detail_view.dart';
import 'package:goasbar/ui/widgets/saved_experience_card/saved_experience_card_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class SavedExperience extends StatelessWidget {
  const SavedExperience({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SavedExperienceCardViewModel>.reactive(
      builder: (context, model, child)  {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/img${(Random().nextInt(3) + 1)}.png"),
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              width: screenWidthPercentage(context, percentage: 0.4),
              height: screenHeightPercentage(context, percentage: 0.4),
            ),
            Positioned(
              top: 20,
              right: 10,
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    model.isFav ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                    color: model.isFav ? Colors.redAccent : Colors.black, size: 20,
                  ).center()
                      .gestures(onTap: () => model.addFavorites())
              ).height(30)
                  .width(30),
            ),
            Positioned(
              bottom: 45,
              child: Row(
                children: const [
                  horizontalSpaceSmall,
                  Text('Dammam Trip', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              )
            ),
            Positioned(
              bottom: 20,
              child: Row(
                children: const [
                  horizontalSpaceSmall,
                  Text('76.00 SR / Person', style: TextStyle(color: Colors.white, fontSize: 10)),
                ],
              ),
            )
          ],
        ).center().gestures(onTap: () => model.navigateTo(view: const TripDetailView()));
      },
      viewModelBuilder: () => SavedExperienceCardViewModel(),
    );
  }
}