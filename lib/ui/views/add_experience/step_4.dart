import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/add_experience/add_experience_viewmodel.dart';
import 'package:goasbar/ui/widgets/dot_item.dart';
import 'package:goasbar/ui/widgets/previous_button.dart';
import 'package:styled_widget/styled_widget.dart';

class AddExperienceStep4View extends HookWidget {
  const AddExperienceStep4View(
      {super.key, required this.model, required this.pageController});

  final AddExperienceInfoViewModel model;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: screenHeightPercentage(context, percentage: 0.85),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
        color: Colors.white,
      ),
      child: ListView(
        children: [
          verticalSpaceSmall,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.close,
                size: 30,
              ).gestures(
                onTap: () => model.back(),
              ),
              horizontalSpaceTiny,
              Text('PROVIDING & REQUIREMENTS'.tr(),
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      '4 - 6',
                      style: TextStyle(
                          color: kMainColor1,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ).center(),
                  ).width(40).height(40).opacity(0.6),
                  const Row(
                    children: [
                      DotItem(condition: false, color: kMainColor1),
                      horizontalSpaceTiny,
                      DotItem(condition: true, color: kMainColor1),
                      horizontalSpaceTiny,
                      DotItem(condition: false, color: kMainColor1),
                    ],
                  ),
                ],
              ),
            ],
          ),
          verticalSpaceMedium,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpaceSmall,
              Text("What will be provided?".tr(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20)),
              verticalSpaceSmall,
              Text("E.g. lunch meal, coffee, some tools...".tr(),
                  style: const TextStyle(fontSize: 14, color: kGrayText)),
              Column(
                children: [
                  verticalSpaceSmall,
                  TextField(
                    controller: model.providedGoodsController1,
                    decoration: InputDecoration(
                      hintText: "Item 1".tr(),
                      hintStyle: const TextStyle(fontSize: 14),
                    ),
                  ),
                  verticalSpaceSmall,
                  TextField(
                    controller: model.providedGoodsController2,
                    decoration: InputDecoration(
                      hintText: "Item 2".tr(),
                      hintStyle: const TextStyle(fontSize: 14),
                    ),
                  ),
                  verticalSpaceSmall,
                  TextField(
                    controller: model.providedGoodsController3,
                    decoration: InputDecoration(
                      hintText: "Item 3".tr(),
                      hintStyle: const TextStyle(fontSize: 14),
                    ),
                  ),
                  verticalSpaceSmall,
                  TextField(
                    controller: model.providedGoodsController4,
                    decoration: InputDecoration(
                      hintText: "Item 4".tr(),
                      hintStyle: const TextStyle(fontSize: 14),
                    ),
                  ),
                  for (var i = 0; i < model.addedProviding!; i++)
                    TextField(
                      controller: model.addedProvidedGoodsControllers[i],
                      decoration: InputDecoration(
                        hintText: "Item ${i + 5}".tr(),
                        hintStyle: const TextStyle(fontSize: 14),
                      ),
                    ).padding(top: 10),
                ],
              ),
              verticalSpaceRegular,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: kMainColor1, width: 1),
                    ),
                    width: 23,
                    height: 23,
                    child: const Icon(
                      Icons.add,
                      color: kMainColor1,
                      size: 15,
                    ).center(),
                  ),
                  horizontalSpaceSmall,
                  Text(
                    "Add more".tr(),
                    style: const TextStyle(color: kMainColor1),
                  ),
                ],
              ).gestures(onTap: () => model.addProvidings(text: '')),
            ],
          ),
          verticalSpaceMedium,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpaceSmall,
              Text("Requirements".tr(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20)),
              verticalSpaceSmall,
              Text("Some notes and requirements for safe experience".tr(),
                  style: const TextStyle(fontSize: 14, color: kGrayText)),
              Column(
                children: [
                  verticalSpaceSmall,
                  TextField(
                    controller: model.requirementsController1,
                    decoration: InputDecoration(
                      hintText: "Note 1".tr(),
                      hintStyle: const TextStyle(fontSize: 14),
                    ),
                  ),
                  verticalSpaceSmall,
                  TextField(
                    controller: model.requirementsController2,
                    decoration: InputDecoration(
                      hintText: "Note 2".tr(),
                      hintStyle: const TextStyle(fontSize: 14),
                    ),
                  ),
                  verticalSpaceSmall,
                  TextField(
                    controller: model.requirementsController3,
                    decoration: InputDecoration(
                      hintText: "Note 3".tr(),
                      hintStyle: const TextStyle(fontSize: 14),
                    ),
                  ),
                  verticalSpaceSmall,
                  TextField(
                    controller: model.requirementsController4,
                    decoration: InputDecoration(
                      hintText: "Note 4".tr(),
                      hintStyle: const TextStyle(fontSize: 14),
                    ),
                  ),
                  for (var i = 0; i < model.addedRequirements!; i++)
                    TextField(
                      controller: model.addedRequirementsControllers[i],
                      decoration: InputDecoration(
                        hintText: "Note ${i + 5}".tr(),
                        hintStyle: const TextStyle(fontSize: 14),
                      ),
                    ).padding(top: 10),
                ],
              ),
              verticalSpaceRegular,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: kMainColor1, width: 1),
                    ),
                    width: 23,
                    height: 23,
                    child: const Icon(
                      Icons.add,
                      color: kMainColor1,
                      size: 15,
                    ).center(),
                  ),
                  horizontalSpaceSmall,
                  Text(
                    "Add more".tr(),
                    style: const TextStyle(color: kMainColor1),
                  ),
                ],
              ).gestures(onTap: () => model.addRequirements(text: '')),
            ],
          ),
          verticalSpaceLarge,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PreviousButton(onTap: () => pageController.jumpToPage(2)),
              Container(
                width: screenWidthPercentage(context, percentage: 0.4),
                height: 50,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  gradient: kMainGradient,
                ),
                child: Center(
                  child: Text(
                    'NEXT'.tr(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ).gestures(
                onTap: () {
                  if (model.providedGoodsController1.text.isNotEmpty) {
                    model.updateProvidedGoodsText(
                        text:
                            "${model.providedGoodsController1.text};${model.providedGoodsText}");
                  }
                  if (model.providedGoodsController2.text.isNotEmpty) {
                    model.updateProvidedGoodsText(
                        text:
                            "${model.providedGoodsController2.text};${model.providedGoodsText}");
                  }
                  if (model.providedGoodsController3.text.isNotEmpty) {
                    model.updateProvidedGoodsText(
                        text:
                            "${model.providedGoodsController3.text};${model.providedGoodsText}");
                  }
                  if (model.providedGoodsController4.text.isNotEmpty) {
                    model.updateProvidedGoodsText(
                        text:
                            "${model.providedGoodsController4.text};${model.providedGoodsText}");
                  }
                  for (var i = 0;
                      i < model.addedProvidedGoodsControllers.length;
                      i++) {
                    if (model
                        .addedProvidedGoodsControllers[i].text.isNotEmpty) {
                      model.updateProvidedGoodsText(
                          text:
                              "${model.addedProvidedGoodsControllers[i].text};${model.providedGoodsText}");
                    }
                  }

                  if (model.requirementsController1.text.isNotEmpty) {
                    model.updateRequirementsText(
                        text:
                            "${model.requirementsController1.text};${model.requirementsText}");
                  }
                  if (model.requirementsController2.text.isNotEmpty) {
                    model.updateRequirementsText(
                        text:
                            "${model.requirementsController2.text};${model.requirementsText}");
                  }
                  if (model.requirementsController3.text.isNotEmpty) {
                    model.updateRequirementsText(
                        text:
                            "${model.requirementsController3.text};${model.requirementsText}");
                  }
                  if (model.requirementsController4.text.isNotEmpty) {
                    model.updateRequirementsText(
                        text:
                            "${model.requirementsController4.text};${model.requirementsText}");
                  }
                  for (var i = 0;
                      i < model.addedRequirementsControllers.length;
                      i++) {
                    if (model.addedRequirementsControllers[i].text.isNotEmpty) {
                      model.updateRequirementsText(
                          text:
                              "${model.addedRequirementsControllers[i].text};${model.requirementsText}");
                    }
                  }

                  pageController.jumpToPage(4);
                },
              ),
            ],
          ),
          verticalSpaceRegular,
        ],
      ),
    );
  }
}
