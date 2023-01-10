import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/confirm_booking/confirm_booking_view.dart';
import 'package:goasbar/ui/views/trip_detail/trip_detail_viewmodel.dart';
import 'package:goasbar/ui/widgets/note_item.dart';
import 'package:goasbar/ui/widgets/slider_image_item.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:goasbar/ui/widgets/dot_item.dart';

class TripDetailView extends HookWidget {
  const TripDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var pageController = usePageController();

    return ViewModelBuilder<TripDetailViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        extendBodyBehindAppBar: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            SizedBox(
              height: 265,
              child: Stack(
                children: [
                  SizedBox(
                    height: 265,
                    child: PageView(
                      scrollDirection: Axis.horizontal,
                      controller: pageController,
                      onPageChanged: (index) => model.changeIndex(index: index),
                      children: const [
                        SliderImageItem(path: 'assets/images/trip_detail.png'),
                        SliderImageItem(path: 'assets/images/trip_detail.png'),
                        SliderImageItem(path: 'assets/images/trip_detail.png'),
                        SliderImageItem(path: 'assets/images/trip_detail.png'),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20,),
                    child: Column(
                      children: [
                        verticalSpaceLarge,
                        verticalSpaceMedium,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.arrow_back).center(),
                            ).height(40)
                                .width(40)
                                .gestures(onTap: () => model.back()),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("Share"),
                                      horizontalSpaceTiny,
                                      const Icon(Icons.share_outlined,).center(),
                                    ],
                                  ),
                                ).height(40)
                                    .width(100),
                                horizontalSpaceSmall,
                                Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      model.isFav ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                                      color: model.isFav ? Colors.redAccent : Colors.black, size: 30,
                                    ).center()
                                        .gestures(onTap: () => model.addFavorites())
                                ).height(40)
                                    .width(40),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.star, color: kStarColor,),
                                  horizontalSpaceTiny,
                                  Text('4.0', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                                ],
                              ),
                            ).height(40)
                                .width(100),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xff222222),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text('${model.pageIndex + 1} / 04', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),).center(),
                                ).width(60)
                                    .height(40)
                                    .opacity(0.6),
                                horizontalSpaceRegular,
                                Row(
                                  children: [
                                    DotItem(condition: model.pageIndex + 1 == 1),
                                    horizontalSpaceSmall,
                                    DotItem(condition: model.pageIndex + 1 == 2),
                                    horizontalSpaceSmall,
                                    DotItem(condition: model.pageIndex + 1 == 3),
                                    horizontalSpaceSmall,
                                    DotItem(condition: model.pageIndex + 1 == 4),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                        verticalSpaceMedium,
                      ],
                    ),
                  ),
                ],
              ),
            ),
            verticalSpaceRegular,
            const Text('Get your experience this weekend \nwith amazing trip in Dammam', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),)
                .padding(horizontal: 20),
            verticalSpaceRegular,
            Row(
              children: [
                const Text('3 reviews'),
                Image.asset("assets/icons/location.png"),
                horizontalSpaceTiny,
                const Text("Dammam , Duration : 2 days", style: TextStyle(color: kMainGray, fontSize: 11)),
                const Text(" | Start at 9 : 00 AM", style: TextStyle(color: kMainGray, fontSize: 11)),
              ],
            ).padding(horizontal: 20),
            verticalSpaceRegular,
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  const Divider(height: 1, color: kMainDisabledGray, thickness: 1).padding(horizontal: 20),
                  verticalSpaceTiny,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Hosted Experience by', style: TextStyle(fontSize: 22)),
                      Image.asset("assets/images/by_user.png").borderRadius(all: 50).height(50).width(50),
                    ],
                  ).padding(horizontal: 20),
                  verticalSpaceTiny,
                  const Divider(height: 10, color: kMainDisabledGray, thickness: 1).padding(horizontal: 20),
                  verticalSpaceRegular,
                  Row(
                    children: [
                      Image.asset("assets/icons/description_quote.png",),
                      horizontalSpaceSmall,
                      const Text('Description', ),
                    ],
                  ).padding(horizontal: 20),
                  verticalSpaceRegular,
                  const Text("Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum")
                      .padding(horizontal: 20),
                  verticalSpaceRegular,
                  Row(
                    children: [
                      Image.asset("assets/icons/gender.png",),
                      horizontalSpaceSmall,
                      const Text('Gender', ),
                      horizontalSpaceMedium,
                      const Text('Valid for All', style: TextStyle(color: kMainDisabledGray),)
                    ],
                  ).padding(horizontal: 20),
                  verticalSpaceRegular,
                  Row(
                    children: [
                      Image.asset("assets/icons/communication.png",),
                      horizontalSpaceSmall,
                      const Text('Have great communication',),
                      const Spacer(),
                      const Text('Start Chat', style: TextStyle(color: kMainColor1,),)
                    ],
                  ).padding(horizontal: 20),
                  verticalSpaceRegular,
                  Row(
                    children: [
                      Image.asset("assets/icons/starting_point.png",),
                      horizontalSpaceSmall,
                      const Text('Starting Point',),
                    ],
                  ).padding(horizontal: 20),
                  verticalSpaceRegular,
                  Image.asset("assets/images/map.png").padding(horizontal: 20),
                  verticalSpaceRegular,
                  Row(
                    children: [
                      Image.asset("assets/icons/notes.png",),
                      horizontalSpaceSmall,
                      const Text('Notes & Requirement',),
                    ],
                  ).padding(horizontal: 20),
                  verticalSpaceRegular,
                  const NoteItem(text: 'Lorem ipsum dolor sit amet, consetetur sadipscing , sed diam nonumy eirmod tempor invidunt ut labore',)
                      .padding(horizontal: 20),
                  verticalSpaceSmall,
                  const NoteItem(text: 'Lorem ipsum dolor sit amet, consetetur sadipscing , sed diam nonumy eirmod tempor invidunt ut labore',)
                      .padding(horizontal: 20),
                  verticalSpaceSmall,
                  const NoteItem(text: 'Lorem ipsum dolor sit amet, consetetur sadipscing , sed diam nonumy eirmod tempor invidunt ut labore',)
                      .padding(horizontal: 20),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Text('100.00 SR', style: TextStyle(color: kMainColor1, fontSize: 18)),
                        Text(' / Person', style: TextStyle(color: kMainGray, fontSize: 18)),
                      ],
                    ),
                    verticalSpaceTiny,
                    const Text('20 - 23 November . 2022', style: TextStyle(fontSize: 13, color: kGrayText),)
                  ],
                ),
                Container(
                  width: 110,
                  height: 40,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    gradient: kMainGradient,
                  ),
                  child: const Text('Book Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),)
                      .center()
                      .gestures(onTap: () {
                        model.navigateTo(view: const ConfirmBookingView());
                  }),
                ),
              ],
            ).padding(horizontal: 20, vertical: 15),
          ],
        ),
      ),
      viewModelBuilder: () => TripDetailViewModel(),
    );
  }
}