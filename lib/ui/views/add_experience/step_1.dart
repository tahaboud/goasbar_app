import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/add_experience/add_experience_viewmodel.dart';
import 'package:goasbar/ui/widgets/dot_item.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:styled_widget/styled_widget.dart';

class AddExperienceStep1View extends HookWidget {
  const AddExperienceStep1View(
      {super.key,
      required this.title,
      required this.model,
      required this.age,
      required this.duration,
      required this.pageController});

  final TextEditingController title;
  final TextEditingController age;
  final TextEditingController duration;
  final AddExperienceInfoViewModel model;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    final titleError = useState<String?>(null);
    final minAgeError = useState<String?>(null);
    final durationError = useState<String?>(null);

    bool validateStep1() {
      bool isValid = true;
      if (title.text.isEmpty) {
        titleError.value = "This field is required.".tr();
        isValid = false;
      }
      if (age.text.isEmpty ||
          int.parse(age.text) < 0 ||
          int.parse(age.text) > 22) {
        minAgeError.value = "Age must be between 0 and 22.".tr();
        isValid = false;
      }
      if (duration.text.isEmpty ||
          double.parse(duration.text) < 0.5 ||
          double.parse(duration.text) > 24) {
        durationError.value =
            "Duration must be between half an hour and 24 hours.".tr();
        isValid = false;
      }

      return isValid;
    }

    void handleNextStep() {
      if (validateStep1()) {
        pageController.jumpToPage(1);
        FocusManager.instance.primaryFocus?.unfocus();
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
              IconButton(
                  onPressed: model.back,
                  icon: const Icon(
                    Icons.close,
                    size: 30,
                  )),
              horizontalSpaceTiny,
              Text('EXPERIENCE INFORMATION'.tr(),
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      '1 - 6',
                      style: TextStyle(
                          color: kMainColor1,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ).center(),
                  ).width(40).height(40).opacity(0.6),
                  const Row(
                    children: [
                      DotItem(condition: true, color: kMainColor1),
                      horizontalSpaceTiny,
                      DotItem(condition: false, color: kMainColor1),
                      horizontalSpaceTiny,
                      DotItem(condition: false, color: kMainColor1),
                    ],
                  ),
                ],
              ),
            ],
          ),
          verticalSpaceMedium,
          Text(
            'Main image'.tr(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          verticalSpaceSmall,
          model.mainImage != null
              ? Container(
                  height: 100,
                  width: screenWidthPercentage(context, percentage: 0.4),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: model.isProfileImageFromLocal!
                          ? FileImage(model.mainImage!)
                          : NetworkImage('$baseUrl${model.mainImage!.path}')
                              as ImageProvider,
                      fit: BoxFit.contain,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ).gestures(
                  onTap: () => model.pickMainImage(),
                )
              : Container(
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: kTextFiledMainColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/icons/camera.png"),
                      Text("Upload identity image".tr(),
                          style: const TextStyle(
                            color: kGrayText,
                          )),
                    ],
                  ).center(),
                ).gestures(
                  onTap: () => model.pickMainImage(),
                ),
          verticalSpaceRegular,
          Container(
              decoration: BoxDecoration(
                color: kTextFiledMainColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text("Experience title".tr()),
                  ),
                  TextField(
                    controller: title,
                    onChanged: (value) {
                      titleError.value = null;
                    },
                    textDirection: TextDirection.rtl,
                    decoration: InputDecoration(
                      errorText: titleError.value,
                      hintStyle: const TextStyle(fontSize: 14),
                      fillColor: kTextFiledMainColor,
                      filled: true,
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      contentPadding:
                          const EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 1.0),
                    ),
                  ),
                ],
              )),
          verticalSpaceRegular,
          Container(
            decoration: BoxDecoration(
              color: kTextFiledMainColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpaceSmall,
                Row(
                  children: [
                    horizontalSpaceSmall,
                    Text("Gender constrains".tr()),
                  ],
                ),
                Container(
                  height: 45,
                  width: screenWidthPercentage(context, percentage: 1),
                  decoration: BoxDecoration(
                    color: kTextFiledMainColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                        value: model.genderConstraint,
                        iconSize: 24,
                        icon: (null),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        onChanged: (value) =>
                            model.updateGenderConstraint(value: value),
                        items: genderConstraints
                            .map((c) => DropdownMenuItem(
                                  value: c,
                                  onTap: () {},
                                  child: SizedBox(
                                    child: Text(
                                      c.tr(),
                                      style:
                                          const TextStyle(fontFamily: 'Cairo'),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          verticalSpaceRegular,
          Container(
              decoration: BoxDecoration(
                color: kTextFiledMainColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Minimum age".tr()),
                  TextField(
                    controller: age,
                    onChanged: (value) {
                      minAgeError.value = null;
                    },
                    textDirection: TextDirection.rtl,
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                    decoration: InputDecoration(
                      counterText: "",
                      errorText: minAgeError.value,
                      hintStyle: const TextStyle(fontSize: 14),
                      fillColor: kTextFiledMainColor,
                      filled: true,
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      contentPadding:
                          const EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 1.0),
                    ),
                  ),
                ],
              )),
          verticalSpaceRegular,
          Container(
              decoration: BoxDecoration(
                color: kTextFiledMainColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Duration (hours)".tr()),
                  TextField(
                    controller: duration,
                    onChanged: (value) {
                      durationError.value = null;
                    },
                    textDirection: TextDirection.rtl,
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                    decoration: InputDecoration(
                      counterText: "",
                      errorText: durationError.value,
                      hintStyle: const TextStyle(fontSize: 14),
                      fillColor: kTextFiledMainColor,
                      filled: true,
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      contentPadding:
                          const EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 1.0),
                    ),
                  ),
                ],
              )),
          verticalSpaceRegular,
          verticalSpaceSmall,
          Text(
            'What is your experience category?'.tr(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          verticalSpaceRegular,
          SizedBox(
            height: 45,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: categories
                  .map(
                    (category) => model.isBusy
                        ? const Loader().center()
                        : Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 12),
                            child: Text(
                              category.tr(),
                              style: TextStyle(
                                color:
                                    model.selectedExperienceCategory != null &&
                                            model.selectedExperienceCategory!
                                                .contains(category)
                                        ? Colors.white
                                        : Colors.black,
                              ),
                            ).center(),
                          )
                            .backgroundGradient(
                                model.selectedExperienceCategory != null &&
                                        model.selectedExperienceCategory!
                                            .contains(category)
                                    ? kMainGradient
                                    : kDisabledGradient,
                                animate: true)
                            .clipRRect(
                              all: 8,
                            )
                            .card(
                              margin: const EdgeInsets.only(right: 12),
                            )
                            .animate(const Duration(milliseconds: 300),
                                Curves.easeIn)
                            .gestures(
                                onTap: () =>
                                    model.updateSelectedExperienceCategory(
                                      category: category,
                                    )),
                  )
                  .toList(),
            ),
          ),
          verticalSpaceLarge,
          Container(
              width: MediaQuery.of(context).size.width - 60,
              height: 50,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                gradient: kMainGradient,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                onPressed: handleNextStep,
                child: Text(
                  'NEXT'.tr(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              )),
          verticalSpaceRegular,
        ],
      ),
    );
  }
}
