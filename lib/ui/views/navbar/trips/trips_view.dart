import 'package:flutter/material.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/ui/views/navbar/trips/trips_viewmodel.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/widgets/creation_aware_item.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:goasbar/ui/widgets/trip_card/trip_card.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:styled_widget/styled_widget.dart';

class TripsView extends HookWidget {
  const TripsView({Key? key, this.text, this.user}) : super(key: key);
  final String? text;
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TripsViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        bottomNavigationBar: const BottomAppBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Container(
              height: double.maxFinite,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  verticalSpaceMedium,
                  Text(text!, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),).alignment(Alignment.centerLeft),
                  verticalSpaceMedium,
                  SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        categoryItem(model: model, index: 1, image: 'hosted', text: "All"),
                        horizontalSpaceSmall,
                        categoryItem(model: model, index: 2, text: "Completed"),
                        horizontalSpaceSmall,
                        categoryItem(model: model, index: 3, text: "Not Completed"),
                      ],
                    ),
                  ),
                  verticalSpaceMedium,
                  model.isBusy ? const Loader().center()
                      : !model.dataReady ? const Text('No trips right now').center() : model.experienceModels!.count == 0
                      ? const Text('No trips right now').center() : model.data!.isEmpty
                      ? const Text('No trips right now').center() : Expanded(child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: model.experienceModels!.count,
                    itemBuilder: (context, index) {
                      return CreationAwareListItem(
                        itemCreated: () => model.getPublicExperiencesFromNextPage(index: index + 1),
                        child: TripItem(experience: model.experienceModels!.results![index], user: user,),
                      );
                    },)
                  ),
                ],
              ),
            ),
          )
        ),
      ),
      viewModelBuilder: () => TripsViewModel(),
    );
  }

  Widget categoryItem({TripsViewModel? model, int? index, String? image, String? text}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 10),
      child: Row(
        children: [
          image != null ? Image.asset("assets/icons/settings/$image.png", color: index == 0 ? Colors.white : Colors.black,)
              : Container(),
          image != null ? horizontalSpaceTiny : Container(),
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