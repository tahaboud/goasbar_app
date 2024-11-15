import 'dart:io';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/add_experience/add_experience_viewmodel.dart';
import 'package:goasbar/ui/widgets/dot_item.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:goasbar/ui/widgets/previous_button.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:styled_widget/styled_widget.dart';

class AddExperienceStep2View extends HookWidget {
  AddExperienceStep2View(
      {super.key,
      required this.model,
      required this.link,
      required this.pageController});

  final TextEditingController link;
  final AddExperienceInfoViewModel model;
  final PageController pageController;
  final RegExp youtubeRegExp = RegExp(
    r'^((?:https?:)?\/\/)?((?:www|m)\.)?((?:youtube(?:-nocookie)?\.com|youtu.be))(\/(?:[\w\-]+\?v=|embed\/|live\/|v\/)?)([\w\-]+)(\S+)?$',
  );

  @override
  Widget build(BuildContext context) {
    final linkError = useState<String?>(null);

    void handleNextStep() {
      if (link.text.isNotEmpty) {
        if (!youtubeRegExp.hasMatch(link.text)) {
          linkError.value = "Invalid youtube url.".tr();
        } else {
          pageController.jumpToPage(2);
        }
      } else {
        pageController.jumpToPage(2);
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
              Text('SHOWCASE EXPERIENCE'.tr(),
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      '2 - 6',
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
            'Add more images'.tr(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          verticalSpaceSmall,
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: kTextFiledMainColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/icons/camera.png"),
                Text("Add images".tr(),
                    style: const TextStyle(
                      color: kGrayText,
                    )),
              ],
            ).center(),
          ).gestures(onTap: () {
            if (model.images! < 8) {
              model.pickImage();
            } else {
              MotionToast.warning(
                title: const Text("Warning"),
                description: const Text("Maximum additional images is 8."),
                animationCurve: Curves.easeIn,
                animationDuration: const Duration(milliseconds: 200),
              ).show(context);
            }
          }),
          verticalSpaceRegular,
          Text(
            'Link for a video of the experience'.tr(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          verticalSpaceSmall,
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
                    child: Text('Drop link'.tr()),
                  ),
                  TextField(
                    controller: link,
                    textDirection: TextDirection.ltr,
                    decoration: InputDecoration(
                      errorText: linkError.value,
                      hintStyle: const TextStyle(fontSize: 14),
                      hintTextDirection: TextDirection.ltr,
                      fillColor: kTextFiledMainColor,
                      filled: true,
                      hintText: 'https://youtube.com/abcde...',
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
          model.isBusy
              ? const Loader().center()
              : GridView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.4,
                    crossAxisSpacing: 15,
                  ),
                  children: List.generate(
                      model.images!,
                      (index) => Container(
                            height: 70,
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            width:
                                screenWidthPercentage(context, percentage: 0.4),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: model.additionalImages![index]!.id !=
                                        null
                                    ? NetworkImage(
                                            '$baseUrl${model.additionalImages![index]!.image!}')
                                        as ImageProvider
                                    : FileImage(File(model
                                        .additionalImages![index]!.image!)),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: model.additionalImages![index]!.id != null
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            right: 8, top: 8),
                                        padding: const EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.9),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Image.asset(
                                          "assets/icons/delete.png",
                                          color: Colors.redAccent,
                                          height: 20,
                                        ),
                                      ),
                                    ],
                                  ).gestures(
                                    onTap: () => model.deleteExperienceImage(
                                        context: context,
                                        image: model.additionalImages![index]!))
                                : const SizedBox(),
                          )),
                ),
          verticalSpaceLarge,
          const Row(children: [
            Expanded(
              flex: 1,
              child: Column(),
            )
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PreviousButton(onTap: () => pageController.jumpToPage(0)),
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
