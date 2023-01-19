import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/add_experience/add_experience_viewmodel.dart';
import 'package:goasbar/ui/widgets/dot_item.dart';
import 'package:goasbar/ui/widgets/info_item.dart';
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
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
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
                ).gestures(onTap: () => model.pickImage(),),
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
                          Text("Gender"),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                        child: TextField(
                          readOnly: true,
                          controller: model.gender,
                          decoration: InputDecoration(
                            hintText: 'Male',
                            hintStyle: const TextStyle(fontSize: 14),
                            suffixIcon: const Icon(Icons.arrow_drop_down)
                                .gestures(onTap: () => model.showSelectionDialog(gen: 'Male')),
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
                verticalSpaceSmall,
                const Text('What is your experience category?', style: TextStyle(fontWeight: FontWeight.bold),),
                verticalSpaceRegular,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      decoration: BoxDecoration(
                        color: kTextFiledMainColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('LANDSCAPE').center(),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      decoration: BoxDecoration(
                        color: kTextFiledMainColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('LANDSCAPE').center(),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      decoration: BoxDecoration(
                        color: kTextFiledMainColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('LANDSCAPE').center(),
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
                    pageController.jumpToPage(1);
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
                ).gestures(onTap: () => model.pickImage(),),
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
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.4,
                    crossAxisSpacing: 15,
                  ),
                  children: List.generate(model.images!, (index) => Container(
                    height: 70,
                    width: screenWidthPercentage(context, percentage: 0.4),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: model.file == null ? const AssetImage("assets/images/profile_image.png",)
                            : FileImage(model.file!) as ImageProvider,
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
                    pageController.jumpToPage(2);
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
                    pageController.jumpToPage(3);
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
                      children: model.providings,
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
                      children: model.requirements,
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
                            value: model.city,
                            iconSize: 24,
                            icon: (null),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                            onChanged: (value) => model.updateCity(value: value),
                            items: [
                              DropdownMenuItem(
                                value: 'Riyadh',
                                onTap: () {

                                },
                                child: const SizedBox(
                                  child: Text(
                                    'Riyadh',
                                    style: TextStyle(fontFamily: 'Cairo'),
                                  ),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'Jeddah',
                                onTap: () {

                                },
                                child: const SizedBox(
                                  child: Text(
                                    'Jeddah',
                                    style: TextStyle(fontFamily: 'Cairo'),
                                  ),
                                ),
                              ),
                            ]
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
                            decoration: InputDecoration(
                              hintText: "Add Notes...",
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
                    const Text('EXPERIENCE LOCATION', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                              prefixIcon: Image.asset('assets/icons/birth_date.png').gestures(onTap: () {
                                model.showStartDatePicker(context);
                              }),
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
                verticalSpaceRegular,
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: kMainColor1.withOpacity(0.3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      horizontalSpaceSmall,
                      Text("Offer new timing", style: TextStyle(color: kMainColor1)),
                      Icon(Icons.add, color: kMainColor1, size: 25,)
                    ],
                  ),
                ).gestures(onTap: () => model.showNewTimingBottomSheet()),

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
                  onTap: () {
                    model.back();
                    model.showPublishSuccessBottomSheet();
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