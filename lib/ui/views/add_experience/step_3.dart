import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/add_experience/add_experience_viewmodel.dart';
import 'package:goasbar/ui/widgets/dot_item.dart';
import 'package:goasbar/ui/widgets/previous_button.dart';
import 'package:pinput/pinput.dart';
import 'package:styled_widget/styled_widget.dart';

class AddExperienceStep3View extends HookWidget {
  const AddExperienceStep3View(
      {super.key,
      required this.model,
      required this.description,
      required this.activities,
      required this.pageController});

  final AddExperienceInfoViewModel model;
  final PageController pageController;
  final TextEditingController activities;
  final TextEditingController description;

  @override
  Widget build(BuildContext context) {
    final descriptionError = useState<String?>(null);
    final activitiesError = useState<String?>(null);

    bool validateStep3() {
      bool isValid = true;
      if (description.length < 140) {
        descriptionError.value =
            "Description must be over 140 chars long.".tr();
        isValid = false;
      }
      if (activities.text.isEmpty) {
        activitiesError.value = "This field is required.".tr();
        isValid = false;
      }
      return isValid;
    }

    void handleNextStep() {
      bool isValid = validateStep3();
      if (isValid) pageController.jumpToPage(3);
    }

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
              Text('EXPERIENCE BRIEF'.tr(),
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      '3 - 6',
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
              Text("Description".tr(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20)),
              verticalSpaceSmall,
              SizedBox(
                height: 150,
                child: TextField(
                  maxLines: 10,
                  controller: description,
                  decoration: InputDecoration(
                    hintText: "Describe this experience...".tr(),
                    hintStyle: const TextStyle(fontSize: 14),
                    errorText: descriptionError.value,
                    fillColor: kTextFiledMainColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
                ),
              ),
            ],
          ),
          verticalSpaceMedium,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpaceSmall,
              Text("Experience activities and places".tr(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20)),
              verticalSpaceSmall,
              SizedBox(
                height: 150,
                child: TextField(
                  maxLines: 10,
                  controller: activities,
                  decoration: InputDecoration(
                    hintText: "Experience activities and places".tr(),
                    hintStyle: const TextStyle(fontSize: 14),
                    errorText: activitiesError.value,
                    fillColor: kTextFiledMainColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
                ),
              ),
            ],
          ),
          verticalSpaceLarge,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PreviousButton(onTap: () => pageController.jumpToPage(1)),
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
                  handleNextStep();
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
