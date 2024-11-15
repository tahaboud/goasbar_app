import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/add_experience/add_experience_viewmodel.dart';
import 'package:goasbar/ui/widgets/dot_item.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:goasbar/ui/widgets/previous_button.dart';
import 'package:styled_widget/styled_widget.dart';

typedef PublishExperienceCallback = void Function(
    AddExperienceInfoViewModel model);

class AddExperienceStep6View extends HookWidget {
  const AddExperienceStep6View({
    super.key,
    required this.model,
    required this.pageController,
    required this.capacity,
    required this.price,
    required this.handlePublishExperience,
  });

  final AddExperienceInfoViewModel model;
  final PageController pageController;
  final TextEditingController capacity;
  final TextEditingController price;
  final PublishExperienceCallback handlePublishExperience;

  @override
  Widget build(BuildContext context) {
    var capacityError = useState<String?>(null);
    var priceError = useState<String?>(null);
    var meetingPointError = useState<String?>(null);

    bool validateStep6() {
      bool isValid = true;

      if (capacity.text.isEmpty || capacity.text == "0") {
        capacityError.value = "Capacity must be greater than 0";
        isValid = false;
      }

      if (price.text.isEmpty || double.parse(price.text) < 1) {
        priceError.value = "Price must be greater than 1 SR";
        isValid = false;
      }

      if (model.latLon == null) {
        meetingPointError.value = "Meeting point must be set on the map";
        isValid = false;
      }

      return isValid;
    }

    void handleNextStep() {
      var isValid = validateStep6();
      if (isValid) {
        handlePublishExperience(model);
      }
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
              Text('EXPERIENCE TIMING'.tr(),
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      '6 - 6',
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
                      DotItem(condition: false, color: kMainColor1),
                      horizontalSpaceTiny,
                      DotItem(condition: true, color: kMainColor1),
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
              Text(
                'When you will make the experience?'.tr(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              verticalSpaceSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 50,
                    width: screenWidthPercentage(context, percentage: 0.42),
                    child: TextField(
                      controller: model.startDate,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(fontSize: 14),
                        prefixIcon:
                            Image.asset('assets/icons/birth_date.png').gestures(
                          onTap: () => model.showStartDatePicker(context),
                        ),
                        fillColor: kTextFiledMainColor,
                        filled: true,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    width: screenWidthPercentage(context, percentage: 0.42),
                    child: TextField(
                      controller: model.startTime,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(fontSize: 14),
                        prefixIcon: const Icon(Icons.access_time).gestures(
                            onTap: () => model.showStartTimePicker(context)),
                        fillColor: kTextFiledMainColor,
                        filled: true,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              verticalSpaceRegular,
              Text(
                'Capacity ( people )'.tr(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              verticalSpaceSmall,
              SizedBox(
                height: 50,
                child: TextField(
                  controller: capacity,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(fontSize: 14),
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                    fillColor: kTextFiledMainColor,
                    errorText: capacityError.value,
                    filled: true,
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
                ),
              ),
            ],
          ),
          verticalSpaceRegular,
          Text(
            'Pricing'.tr(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          verticalSpaceSmall,
          SizedBox(
            height: 50,
            child: TextField(
              controller: price,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintStyle: const TextStyle(fontSize: 14),
                suffix: Text("SR".tr(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                fillColor: kTextFiledMainColor,
                filled: true,
                errorText: priceError.value,
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
            ),
          ),
          verticalSpaceLarge,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PreviousButton(onTap: () => pageController.jumpToPage(4)),
              Container(
                width: screenWidthPercentage(context, percentage: 0.4),
                height: 50,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  gradient: kMainGradient,
                ),
                child: model.isClicked!
                    ? const Loader().center()
                    : Center(
                        child: Text(
                          'PUBLISH'.tr(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
              ).gestures(onTap: handleNextStep)
            ],
          ),
          verticalSpaceRegular,
        ],
      ),
    );
  }
}
