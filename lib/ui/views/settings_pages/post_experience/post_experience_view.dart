import 'package:flutter/material.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/settings_pages/post_experience/post_experience_viewmodel.dart';
import 'package:goasbar/ui/views/timing/timing_view.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/cupertino.dart';

class PostExperienceView extends HookWidget {
  const PostExperienceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PostExperienceViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(CupertinoIcons.arrow_turn_up_left).height(40)
                      .width(40)
                      .gestures(
                      onTap: () {
                        model.back();
                      }
                  ),
                  const Text('My Experience', style: TextStyle(fontSize: 21),),
                  const Spacer(),
                  const Text("Add New Experience", style: TextStyle(color: kMainColor1),).gestures(onTap: () => model.showAddExperienceInfoBottomSheet())
                ],
              ),
              verticalSpaceMedium,
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: List.generate(5, (index) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 0,
                            offset: Offset(0, 1),
                            blurRadius: 8,
                          ),
                        ],
                        color: Colors.white
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Text('Dammam Trip'),
                                horizontalSpaceSmall,
                                Text('Pending review', style: TextStyle(color: kMainColor1)),
                              ],
                            ),
                            Container(
                              height: 22,
                              width: 22,
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1,),
                                  borderRadius: BorderRadius.circular(30)
                              ),
                              child: Icon(model.isCollapsed! ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 17,).center(),
                            ).gestures(onTap: () => model.collapse()),
                          ],
                        ),
                        verticalSpaceSmall,
                        Stack(
                          children: [
                            Container(
                              height: 100,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/images/img_post_exp.png"),
                                ),
                              ),
                            ),
                            const Positioned(
                                bottom: 15,
                                left: 10,
                                child: Text("New  |  05 Booking", style: TextStyle(color: Colors.white,),)
                            ),
                            Positioned(
                              bottom: 10,
                              right: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    Image.asset("assets/icons/birth_date.png", color: Colors.black, height: 20),
                                    horizontalSpaceSmall,
                                    const Text("View timing", style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ).gestures(onTap: () => model.navigateTo(view: const TimingView())),
                            ),
                          ],
                        ),
                        !model.isCollapsed! ? const SizedBox() : verticalSpaceSmall,
                        !model.isCollapsed! ? const SizedBox() : const Text("Get your experience this weekend with amazing trip in Dammam", style: TextStyle(fontSize: 20)),
                        !model.isCollapsed! ? const SizedBox() : verticalSpaceSmall,
                        !model.isCollapsed! ? const SizedBox() : const Text("Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut f labore et dolore magna aliquyam erat, sed diam dg", style: TextStyle(fontSize: 13, color: kGrayText)),
                        !model.isCollapsed! ? const SizedBox() : verticalSpaceRegular,
                        !model.isCollapsed! ? const SizedBox() : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 150,
                              height: 40,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                  color: Colors.transparent
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset("assets/icons/delete.png", color: Colors.redAccent, height: 25),
                                  horizontalSpaceSmall,
                                  const Text('Delete', style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.w500),).center(),
                                ],
                              ),
                            ).gestures(onTap: () {

                            }),
                            Container(
                              width: 150,
                              height: 40,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                gradient: kMainGradient,
                              ),
                              child: const Text('Update', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),).center(),
                            ).gestures(onTap: () {

                            }),
                          ],
                        ),
                      ],
                    ),
                  )).toList(),
                ),
              ),
            ],
          ).padding(horizontal: 16, top: 16),
        ),
      ),
      viewModelBuilder: () => PostExperienceViewModel(),
    );
  }
}
