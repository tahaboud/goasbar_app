import 'package:flutter/material.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/messages_notifications/messages_notifications_view.dart';
import 'package:goasbar/ui/views/navbar/experience/experience_viewmodel.dart';
import 'package:goasbar/ui/widgets/trip_card/trip_card.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ExperienceView extends HookWidget {
  const ExperienceView({Key? key, this.isUser}) : super(key: key);
  final bool? isUser;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ExperienceViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                verticalSpaceMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.transparent,
                        border: Border.all(color: kMainDisabledGray),
                      ),
                      child: Row(
                        children: isUser! ? [
                          Image.asset("assets/images/user.png",),
                          horizontalSpaceTiny,
                          const Text('Hi , Oussama !'),
                        ] : [
                          Image.asset("assets/icons/person_login.png", color: kMainColor1),
                          horizontalSpaceTiny,
                          const Text('welcome ,Guest'),
                        ],
                      ),
                    ).gestures(onTap: isUser! ? () {} : () => model.back(),),
                    const Spacer(),
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: kTextFiledGrayColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset("assets/icons/messages.png",),
                    ).gestures(onTap: () => model.navigateTo(view: const MessagesNotificationsView()),),
                    horizontalSpaceSmall,
                  ],
                ),
                verticalSpaceMedium,
                SizedBox(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      categoryItem(model: model, index: 1, image: 'all.png', text: "All"),
                      horizontalSpaceSmall,
                      categoryItem(model: model, index: 2, image: 'family.png', text: "Families only"),
                      horizontalSpaceSmall,
                      categoryItem(model: model, index: 3, image: 'men.png', text: "Men only"),
                      horizontalSpaceSmall,
                      categoryItem(model: model, index: 4, image: 'women.png', text: "Women only"),
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
            ),
          )
        ),
      ),
      viewModelBuilder: () => ExperienceViewModel(),
    );
  }

  Widget categoryItem({ExperienceViewModel? model, int? index, String? image, String? text}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 10),
      child: Row(
        children: [
          index == 4 ? Image.asset("assets/icons/categories/$image")
              : Image.asset("assets/icons/categories/$image", color: model!.index == index ? Colors.white : kMainGray),
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