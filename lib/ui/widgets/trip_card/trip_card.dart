import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/confirm_booking/confirm_booking_view.dart';
import 'package:goasbar/ui/views/trip_detail/trip_detail_view.dart';
import 'package:goasbar/ui/widgets/trip_card/trip_card_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class TripItem extends StatelessWidget {
  const TripItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TripCardViewModel>.reactive(
      builder: (context, model, child)  {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/image${(Random().nextInt(3) + 1)}.png"),
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              width: screenWidthPercentage(context, percentage: 1) - 60,
              height: screenHeightPercentage(context, percentage: 0.3),
            ).center(),
            Positioned(
              top: 10,
              right: 30,
              child: Row(
                children: [
                  Container(
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
                  horizontalSpaceSmall,
                  const Chip(
                    backgroundColor: kMainColor1,
                    label: Text('4.8', style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                    avatar: Icon(Icons.star, color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 25,
              left: 5,
              child: Container(
                height: screenHeightPercentage(context, percentage: 0.13),
                width: screenWidthPercentage(context, percentage: 0.7) - 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 1,
                      offset: Offset(0, 0),
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    verticalSpaceSmall,
                    Row(
                      children: [
                        horizontalSpaceSmall,
                        const Text('Dammam Trip', style: TextStyle(fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Row(
                          children: const [
                            Text('76.00 SR', style: TextStyle(color: kMainColor1, fontSize: 9)),
                            Text(' / Person', style: TextStyle(color: kMainGray, fontSize: 9)),
                          ],
                        ),
                        horizontalSpaceSmall,
                      ],
                    ),
                    verticalSpaceSmall,
                    Row(
                      children: [
                        horizontalSpaceSmall,
                        Image.asset("assets/icons/location.png"),
                        horizontalSpaceTiny,
                        const Text("Dammam , 1 Hour", style: TextStyle(color: kMainGray, fontSize: 11))
                      ],
                    ),
                    verticalSpaceSmall,
                    Row(
                      children: [
                        horizontalSpaceSmall,
                        Random().nextInt(100) > 50
                            ? const Text('Lorem ipsum dolor sit amet', style: TextStyle(color: kMainGray, fontSize: 10))
                            : SizedBox(width: 90, child: Stack(
                          children: [
                            Image.asset("assets/images/user.png", height: 25),
                            Positioned(
                              left: 20,
                              child: Image.asset("assets/images/user.png", height: 25),
                            ),
                            Positioned(
                              left: 40,
                              child: Image.asset("assets/images/user.png", height: 25),
                            ),
                            Positioned(
                              left: 60,
                              child: Image.asset("assets/images/user.png", height: 25),
                            ),
                          ],
                        ),),
                        const Spacer(),
                        Container(
                          width: 70,
                          height: 25,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                            gradient: kMainGradient,
                          ),
                          child: const Text('Book Now', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),).center(),
                        ).gestures(onTap: () {
                          model.navigateTo(view: const ConfirmBookingView());
                        }),
                        horizontalSpaceSmall,
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ).gestures(onTap: () => model.navigateTo(view: const TripDetailView()));
      },
      viewModelBuilder: () => TripCardViewModel(),
    );
  }
}