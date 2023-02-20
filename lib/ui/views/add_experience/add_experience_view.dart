import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/add_experience/add_experience_viewmodel.dart';
import 'package:goasbar/ui/widgets/dot_item.dart';
import 'package:goasbar/ui/widgets/info_item.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:styled_widget/styled_widget.dart';

class AddExperienceView extends HookWidget {
  const AddExperienceView({Key? key, required this.request, required this.completer})
      : super(key: key);

  final SheetRequest request;
  final Function(SheetResponse) completer;

  @override
  Widget build(BuildContext context) {
    var title = useTextEditingController();
    var description = useTextEditingController();
    var activities = useTextEditingController();
    var age = useTextEditingController();
    var notes = useTextEditingController();
    var duration = useTextEditingController();
    var link = useTextEditingController();
    var addPeople = useTextEditingController();
    var price = useTextEditingController();
    var pageController = usePageController();

    return ViewModelBuilder<AddExperienceInfoViewModel>.reactive(
      builder: (context, model, child) => PageView(
        scrollDirection: Axis.horizontal,
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) => model.changeIndex(index: index),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: screenHeightPercentage(context, percentage: 0.85),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18),),
              color: Colors.white,
            ),
            child: ListView(
              children: [
                verticalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.close, size: 30,).gestures(onTap: () =>model.back(),),
                    horizontalSpaceTiny,
                    const Text('EXPERIENCE INFORMATION', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text('1 - 6', style: TextStyle(color: kMainColor1, fontSize: 14, fontWeight: FontWeight.bold),).center(),
                        ).width(40)
                            .height(40)
                            .opacity(0.6),
                        Row(
                          children: const [
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
                const Text('Main image', style: TextStyle(fontWeight: FontWeight.bold),),
                verticalSpaceSmall,
                model.mainImage != null ? Container(
                  height: 100,
                  width: screenWidthPercentage(context, percentage: 0.4),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: model.mainImage == null ? const AssetImage("assets/icons/camera.png",)
                          : FileImage(model.mainImage!) as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ).gestures(onTap: () => model.pickMainImage(),) : Container(
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: kTextFiledMainColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/icons/camera.png"),
                      const Text("upload identity image", style: TextStyle(color: kGrayText,)),
                    ],
                  ).center(),
                ).gestures(onTap: () => model.pickMainImage(),),
                verticalSpaceRegular,
                InfoItem(
                  controller: title,
                  label: 'Experience Title',
                  hintText: 'Experience Title , e.g',
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
                      verticalSpaceSmall,
                      Row(
                        children: const [
                          horizontalSpaceSmall,
                          Text("Gender constrains"),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                        child: TextField(
                          readOnly: true,
                          controller: model.genderConstraints,
                          decoration: InputDecoration(
                            hintText: "No constrains",
                            hintStyle: const TextStyle(fontSize: 14),
                            suffixIcon: const Icon(Icons.arrow_drop_down)
                                .gestures(onTap: () => model.showGenderConstraintsDialog(data: 'No constrains')),
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
                ),
                verticalSpaceRegular,
                InfoItem(
                  controller: age,
                  label: 'Minimum Age',
                  hintText: '00',
                ),
                verticalSpaceRegular,
                InfoItem(
                  controller: duration,
                  label: 'Duration (hours)',
                  hintText: '0.5 H',
                ),
                verticalSpaceRegular,
                verticalSpaceSmall,
                const Text('What is your experience category?', style: TextStyle(fontWeight: FontWeight.bold),),
                verticalSpaceRegular,
                SizedBox(
                  height: 45,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: categories.map((category) => Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      child: Text(category, style: TextStyle(
                        color: model.selectedExperienceCategory == category ? Colors.white : Colors.black,
                      ),).center(),
                    ).backgroundGradient(model.selectedExperienceCategory == category ? kMainGradient : kDisabledGradient, animate: true)
                        .clipRRect(all: 8,)
                        .card(margin: const EdgeInsets.only(right: 12),)
                        .animate(const Duration(milliseconds: 300), Curves.easeIn).gestures(onTap: () => model.updateSelectedExperienceCategory(category: category,)),).toList(),
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
                  child: const Center(
                    child: Text('NEXT', style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500),),
                  ),
                ).gestures(
                  onTap: () {
                    if (title.text.isNotEmpty && age.text.isNotEmpty) {
                      if (int.parse(age.text) <= 22 && int.parse(age.text) >= 0) {
                        if (duration.text.isNotEmpty) {
                          if (double.parse(duration.text) % 0.5 == 0) {
                            pageController.jumpToPage(1);
                          } else {
                            MotionToast.warning(
                              title: const Text("Warning"),
                              description: const Text("Duration must be multiple of 0.5h."),
                              animationCurve: Curves.easeIn,
                              animationDuration: const Duration(milliseconds: 200),
                            ).show(context);
                          }
                        } else {
                          pageController.jumpToPage(1);
                        }
                      } else {
                        MotionToast.warning(
                          title: const Text("Warning"),
                          description: const Text("Minimum Age must be from 0 to 22."),
                          animationCurve: Curves.easeIn,
                          animationDuration: const Duration(milliseconds: 200),
                        ).show(context);
                      }
                    } else {
                      MotionToast.warning(
                        title: const Text("Warning"),
                        description: const Text("Title and Minimum age are required."),
                        animationCurve: Curves.easeIn,
                        animationDuration: const Duration(milliseconds: 200),
                      ).show(context);
                    }
                  },
                ),
                verticalSpaceRegular,
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: screenHeightPercentage(context, percentage: 0.85),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18),),
              color: Colors.white,
            ),
            child: ListView(
              children: [
                verticalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.close, size: 30,).gestures(onTap: () =>model.back(),),
                    horizontalSpaceTiny,
                    const Text('SHOWCASE EXPERIENCE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text('2 - 6', style: TextStyle(color: kMainColor1, fontSize: 14, fontWeight: FontWeight.bold),).center(),
                        ).width(40)
                            .height(40)
                            .opacity(0.6),
                        Row(
                          children: const [
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
                const Text('Add more images', style: TextStyle(fontWeight: FontWeight.bold),),
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
                      const Text("upload identity image", style: TextStyle(color: kGrayText,)),
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
                const Text('Link for a video of the experience', style: TextStyle(fontWeight: FontWeight.bold),),
                verticalSpaceSmall,
                InfoItem(
                  controller: link,
                  label: 'Drop link',
                  hintText: 'http:www.youtube.com/bngvdx …. ( exp)',
                ),
                verticalSpaceRegular,
                GridView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.4,
                    crossAxisSpacing: 15,
                  ),
                  children: List.generate(model.images!, (index) => Container(
                    height: 70,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    width: screenWidthPercentage(context, percentage: 0.4),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(model.additionalImages![index]!),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  )),
                ),
                verticalSpaceLarge,
                Container(
                  width: MediaQuery.of(context).size.width - 60,
                  height: 50,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gradient: kMainGradient,
                  ),
                  child: const Center(
                    child: Text('NEXT', style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500),),
                  ),
                ).gestures(
                  onTap: () {
                    if (link.text.isNotEmpty) {
                      if (!link.text.contains("www.youtube.com/")) {
                        MotionToast.warning(
                          title: const Text("Warning"),
                          description: const Text("Youtube link is not correct"),
                          animationCurve: Curves.easeIn,
                          animationDuration: const Duration(milliseconds: 200),
                        ).show(context);
                      } else {
                        pageController.jumpToPage(2);
                      }
                    } else {
                      pageController.jumpToPage(2);
                    }
                  },
                ),
                verticalSpaceRegular,
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: screenHeightPercentage(context, percentage: 0.85),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18),),
              color: Colors.white,
            ),
            child: ListView(
              children: [
                verticalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.close, size: 30,).gestures(onTap: () =>model.back(),),
                    horizontalSpaceTiny,
                    const Text('EXPERIENCE BRIEF', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text('3 - 6', style: TextStyle(color: kMainColor1, fontSize: 14, fontWeight: FontWeight.bold),).center(),
                        ).width(40)
                            .height(40)
                            .opacity(0.6),
                        Row(
                          children: const [
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
                    const Text("Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    verticalSpaceSmall,
                    SizedBox(
                      height: 150,
                      child: TextField(
                        maxLines: 10,
                        controller: description,
                        decoration: InputDecoration(
                          hintText: "Describe this experience...",
                          hintStyle: const TextStyle(fontSize: 14),
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
                    const Text("Experience activities and places", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    verticalSpaceSmall,
                    SizedBox(
                      height: 150,
                      child: TextField(
                        maxLines: 10,
                        controller: activities,
                        decoration: InputDecoration(
                          hintText: "Experience activities and places...",
                          hintStyle: const TextStyle(fontSize: 14),
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
                Container(
                  width: MediaQuery.of(context).size.width - 60,
                  height: 50,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gradient: kMainGradient,
                  ),
                  child: const Center(
                    child: Text('NEXT', style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500),),
                  ),
                ).gestures(
                  onTap: () {
                    if (description.text.isNotEmpty && activities.text.isNotEmpty) {
                      if (description.text.length >= 140) {
                        pageController.jumpToPage(3);
                      } else {
                        MotionToast.warning(
                          title: const Text("Warning"),
                          description: const Text("Description must be more than 140 characters"),
                          animationCurve: Curves.easeIn,
                          animationDuration: const Duration(milliseconds: 200),
                        ).show(context);
                      }
                    } else {
                      MotionToast.warning(
                        title: const Text("Warning"),
                        description: const Text("Description and activities are required"),
                        animationCurve: Curves.easeIn,
                        animationDuration: const Duration(milliseconds: 200),
                      ).show(context);
                    }
                  },
                ),
                verticalSpaceRegular,
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: screenHeightPercentage(context, percentage: 0.85),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18),),
              color: Colors.white,
            ),
            child: ListView(
              children: [
                verticalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.close, size: 30,).gestures(onTap: () =>model.back(),),
                    horizontalSpaceTiny,
                    const Text('PROVIDING & REQUIREMENTS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text('4 - 6', style: TextStyle(color: kMainColor1, fontSize: 14, fontWeight: FontWeight.bold),).center(),
                        ).width(40)
                            .height(40)
                            .opacity(0.6),
                        Row(
                          children: const [
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
                    const Text("What will be provided?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    verticalSpaceSmall,
                    const Text("E.g. lunch meal, coffee, some tools...", style: TextStyle(fontSize: 14, color: kGrayText)),
                    Column(
                      children: [
                        verticalSpaceSmall,
                        TextField(
                          controller: model.providedGoodsController1,
                          decoration: const InputDecoration(
                            hintText: "Providing's add-ons",
                            hintStyle: TextStyle(fontSize: 14),
                          ),
                        ),
                        verticalSpaceSmall,
                        TextField(
                          controller: model.providedGoodsController2,
                          decoration: const InputDecoration(
                            hintText: "Providing's add-ons",
                            hintStyle: TextStyle(fontSize: 14),
                          ),
                        ),
                        verticalSpaceSmall,
                        TextField(
                          controller: model.providedGoodsController3,
                          decoration: const InputDecoration(
                            hintText: "Providing's add-ons",
                            hintStyle: TextStyle(fontSize: 14),
                          ),
                        ),
                        verticalSpaceSmall,
                        TextField(
                          controller: model.providedGoodsController4,
                          decoration: const InputDecoration(
                            hintText: "Providing's add-ons",
                            hintStyle: TextStyle(fontSize: 14),
                          ),
                        ),
                        for (var i = 0; i < model.addedProviding!; i++)
                          TextField(
                            controller: model.addedProvidedGoodsControllers[i],
                            decoration: const InputDecoration(
                              hintText: "Providing's add-ons",
                              hintStyle: TextStyle(fontSize: 14),
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
                          child: const Icon(Icons.add, color: kMainColor1, size: 15,).center(),
                        ),
                        horizontalSpaceSmall,
                        const Text("Add more", style: TextStyle(color: kMainColor1),),
                      ],
                    ).gestures(onTap: () => model.addProvidings()),
                  ],
                ),
                verticalSpaceMedium,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalSpaceSmall,
                    const Text("Requirements", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    verticalSpaceSmall,
                    const Text("some notes and requirement for safe trip", style: TextStyle(fontSize: 14, color: kGrayText)),
                    Column(
                      children: [
                        verticalSpaceSmall,
                        TextField(
                          controller: model.requirementsController1,
                          decoration: const InputDecoration(
                            hintText: "Providing's add-ons",
                            hintStyle: TextStyle(fontSize: 14),
                          ),
                        ),
                        verticalSpaceSmall,
                        TextField(
                          controller: model.requirementsController2,
                          decoration: const InputDecoration(
                            hintText: "Providing's add-ons",
                            hintStyle: TextStyle(fontSize: 14),
                          ),
                        ),
                        verticalSpaceSmall,
                        TextField(
                          controller: model.requirementsController3,
                          decoration: const InputDecoration(
                            hintText: "Providing's add-ons",
                            hintStyle: TextStyle(fontSize: 14),
                          ),
                        ),
                        verticalSpaceSmall,
                        TextField(
                          controller: model.requirementsController4,
                          decoration: const InputDecoration(
                            hintText: "Providing's add-ons",
                            hintStyle: TextStyle(fontSize: 14),
                          ),
                        ),

                        for (var i = 0; i < model.addedRequirements!; i++)
                          TextField(
                            controller: model.addedRequirementsControllers[i],
                            decoration: const InputDecoration(
                              hintText: "Providing's add-ons",
                              hintStyle: TextStyle(fontSize: 14),
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
                          child: const Icon(Icons.add, color: kMainColor1, size: 15,).center(),
                        ),
                        horizontalSpaceSmall,
                        const Text("Add more", style: TextStyle(color: kMainColor1),),
                      ],
                    ).gestures(onTap: () => model.addRequirements()),
                  ],
                ),
                verticalSpaceLarge,
                Container(
                  width: MediaQuery.of(context).size.width - 60,
                  height: 50,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gradient: kMainGradient,
                  ),
                  child: const Center(
                    child: Text('NEXT', style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500),),
                  ),
                ).gestures(
                  onTap: () {
                    for (var i = 0; i < model.addedProvidedGoodsControllers.length; i++) {
                      if (model.addedProvidedGoodsControllers[i].text.isNotEmpty) {
                        model.providedGoodsText = "${model.addedProvidedGoodsControllers[i].text}\n${model.providedGoodsText}";
                      }
                    }

                    if (model.providedGoodsController1.text.isNotEmpty) model.providedGoodsText = "${model.providedGoodsController1.text}\n${model.providedGoodsText}";
                    if (model.providedGoodsController2.text.isNotEmpty) model.providedGoodsText = "${model.providedGoodsController2.text}\n${model.providedGoodsText}";
                    if (model.providedGoodsController3.text.isNotEmpty) model.providedGoodsText = "${model.providedGoodsController3.text}\n${model.providedGoodsText}";
                    if (model.providedGoodsController4.text.isNotEmpty) model.providedGoodsText = "${model.providedGoodsController4.text}\n${model.providedGoodsText}";

                    for (var i = 0; i < model.addedRequirementsControllers.length; i++) {
                      if (model.addedRequirementsControllers[i].text.isNotEmpty) {
                        model.requirementsText = "${model.addedRequirementsControllers[i].text}\n";
                      }
                    }

                    if (model.requirementsController1.text.isNotEmpty) model.requirementsText = "${model.requirementsController1.text}\n";
                    if (model.requirementsController2.text.isNotEmpty) model.requirementsText = "${model.requirementsController2.text}\n";
                    if (model.requirementsController3.text.isNotEmpty) model.requirementsText = "${model.requirementsController3.text}\n";
                    if (model.requirementsController4.text.isNotEmpty) model.requirementsText = "${model.requirementsController4.text}\n";

                    pageController.jumpToPage(4);
                  },
                ),
                verticalSpaceRegular,
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: screenHeightPercentage(context, percentage: 0.85),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18),),
              color: Colors.white,
            ),
            child: ListView(
              children: [
                verticalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.close, size: 30,).gestures(onTap: () =>model.back(),),
                    horizontalSpaceTiny,
                    const Text('EXPERIENCE LOCATION', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text('5 - 6', style: TextStyle(color: kMainColor1, fontSize: 14, fontWeight: FontWeight.bold),).center(),
                        ).width(40)
                            .height(40)
                            .opacity(0.6),
                        Row(
                          children: const [
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
                    const Text("City", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    verticalSpaceSmall,
                    Container(
                      height: 50,
                      width: screenWidthPercentage(context, percentage: 1),
                      decoration: BoxDecoration(
                        color: kTextFiledMainColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<String>(
                            value: model.city,
                            iconSize: 24,
                            icon: (null),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                            onChanged: (value) => model.updateCity(value: value),
                            items: cities.map((c) => DropdownMenuItem(
                              value: c,
                              onTap: () {},
                              child: SizedBox(
                                child: Text(c, style: const TextStyle(fontFamily: 'Cairo'),),
                              ),
                            )).toList(),
                          ),
                        ),
                      ),
                    ),
                    verticalSpaceRegular,
                    const Text("Starting point", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    verticalSpaceSmall,
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: kTextFiledMainColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("City Dammam - Rue 14"),
                          Row(
                            children: [
                              Image.asset("assets/icons/map_link.png", color: kMainColor1),
                              horizontalSpaceSmall,
                              const Text("Google maps", style: TextStyle(color: kGrayText),),
                            ],
                          )
                        ],
                      ),
                    ),
                    verticalSpaceRegular,
                    Image.asset("assets/images/map.png"),
                    verticalSpaceRegular,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        verticalSpaceSmall,
                        const Text("Description Or Notes", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        verticalSpaceSmall,
                        SizedBox(
                          height: 100,
                          child: TextField(
                            maxLines: 10,
                            controller: notes,
                            maxLength: 1024,
                            decoration: InputDecoration(
                              hintText: "Add Notes...",
                              hintStyle: const TextStyle(fontSize: 14),
                              fillColor: kTextFiledMainColor,
                              filled: true,
                              counterText: '',
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
                  ],
                ),
                verticalSpaceLarge,
                Container(
                  width: MediaQuery.of(context).size.width - 60,
                  height: 50,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gradient: kMainGradient,
                  ),
                  child: const Center(
                    child: Text('NEXT', style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500),),
                  ),
                ).gestures(
                  onTap: () {
                    pageController.jumpToPage(5);
                  },
                ),
                verticalSpaceRegular,
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: screenHeightPercentage(context, percentage: 0.85),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18),),
              color: Colors.white,
            ),
            child: ListView(
              children: [
                verticalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.close, size: 30,).gestures(onTap: () =>model.back(),),
                    horizontalSpaceTiny,
                    const Text('EXPERIENCE TIMING', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text('6 - 6', style: TextStyle(color: kMainColor1, fontSize: 14, fontWeight: FontWeight.bold),).center(),
                        ).width(40)
                            .height(40)
                            .opacity(0.6),
                        Row(
                          children: const [
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
                    const Text('When you will make the experience?', style: TextStyle(fontWeight: FontWeight.bold),),
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
                              hintText: '20 Sep 2022',
                              hintStyle: const TextStyle(fontSize: 14),
                              prefixIcon: Image.asset('assets/icons/birth_date.png').gestures(
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
                              hintText: '8:30 AM',
                              hintStyle: const TextStyle(fontSize: 14),
                              prefixIcon: const Icon(Icons.access_time).gestures(onTap: () => model.showStartTimePicker(context)),
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
                    const Text('Capacity ( people ) Trip', style: TextStyle(fontWeight: FontWeight.bold),),
                    verticalSpaceSmall,
                    SizedBox(
                      height: 50,
                      child: TextField(
                        controller: addPeople,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Add people',
                          hintStyle: TextStyle(fontSize: 14),
                          prefixIcon: Icon(Icons.person_outline_rounded),
                          fillColor: kTextFiledMainColor,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // verticalSpaceRegular,
                // Container(
                //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(30),
                //     color: kMainColor1.withOpacity(0.3),
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: const [
                //       horizontalSpaceSmall,
                //       Text("Offer new timing", style: TextStyle(color: kMainColor1)),
                //       Icon(Icons.add, color: kMainColor1, size: 25,)
                //     ],
                //   ),
                // ).gestures(onTap: () => model.showNewTimingBottomSheet(date: , experienceId: ,)),

                verticalSpaceRegular,
                const Text('Pricing', style: TextStyle(fontWeight: FontWeight.bold),),
                verticalSpaceSmall,
                SizedBox(
                  height: 50,
                  child: TextField(
                    controller: price,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: '05.00',
                      hintStyle: TextStyle(fontSize: 14),
                      suffix: Text("SR", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                      fillColor: kTextFiledMainColor,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                    ),
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
                  child: const Center(
                    child: Text('PUBLISH', style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500),),
                  ),
                ).gestures(
                  onTap: () async {
                    if (price.text.isNotEmpty && addPeople.text.isNotEmpty && model.startDate.text.isNotEmpty && model.startTime.text.isNotEmpty) {
                      if (double.parse(price.text) > 1) {
                        Map<String, dynamic>? body = {};
                        body.addAll({'title': title.text});
                        body.addAll({'min_age': age.text});
                        body.addAll({'description': description.text});
                        body.addAll({'events': activities.text});
                        body.addAll({'city': model.city});
                        body.addAll({'price': price.text});

                        if (model.mainImage != null) {
                          var pickedFile = await MultipartFile.fromFile(
                            model.mainImage!.path,
                            filename: model.mainImage!.path.substring(model.mainImage!.absolute.path.lastIndexOf('/') + 1),
                          );
                          body.addAll({'profile_image': pickedFile});
                        }

                        if (model.images! > 0) {
                          for (var i = 0; i < model.images!; i++) {
                            var pickedFile = await MultipartFile.fromFile(
                              model.additionalImages![i]!.path,
                              filename: model.additionalImages![i]!.path.substring(model.additionalImages![i]!.absolute.path.lastIndexOf('/') + 1),
                            );
                            body.addAll({'image_set[$i]image': pickedFile});
                          }
                        }

                        if (model.genderConstraints.text == "No constrains") body.addAll({'gender': 'None',});
                        if (model.genderConstraints.text == "Families") body.addAll({'gender': 'FAMILIES',});
                        if (model.genderConstraints.text == "Men Only") body.addAll({'gender': 'MEN',});
                        if (model.genderConstraints.text == "Women Only") body.addAll({'gender': 'WOMEN',});
                        if (duration.text.isNotEmpty) body.addAll({'duration': duration.text,});
                        if (notes.text.isNotEmpty) body.addAll({'location_notes': notes.text,});
                        if (model.selectedExperienceCategory != null) body.addAll({'categories': model.selectedExperienceCategory,});
                        if (link.text.isNotEmpty) body.addAll({'youtube_video': link.text});
                        if (model.providedGoodsText!.isNotEmpty) body.addAll({'provided_goods': model.providedGoodsText});
                        if (model.requirementsText!.isNotEmpty) body.addAll({'requirements': model.requirementsText});

                        model.createExperience(body: body).then((value) {
                          if (value != null) {
                            model.showPublishSuccessBottomSheet().then((value) {
                              completer(SheetResponse(confirmed: true));
                            });
                          } else {
                            MotionToast.error(
                              title: const Text("Create Experience Failed"),
                              description: const Text("An error occurred while creating the experience, please try again."),
                              animationCurve: Curves.easeIn,
                              animationDuration: const Duration(milliseconds: 200),
                            ).show(context);
                          }
                        });
                      } else {
                        MotionToast.warning(
                          title: const Text("Warning"),
                          description: const Text("Price must be more than 1.0 SR"),
                          animationCurve: Curves.easeIn,
                          animationDuration: const Duration(milliseconds: 200),
                        ).show(context);
                      }
                    } else {
                      MotionToast.warning(
                        title: const Text("Warning"),
                        description: const Text("All fields are required"),
                        animationCurve: Curves.easeIn,
                        animationDuration: const Duration(milliseconds: 200),
                      ).show(context);
                    }
                  },
                ),
                verticalSpaceRegular,
              ],
            ),
          ),
        ],
      ).height(screenHeightPercentage(context, percentage: 0.85)),
      viewModelBuilder: () => AddExperienceInfoViewModel(),
    );
  }
}