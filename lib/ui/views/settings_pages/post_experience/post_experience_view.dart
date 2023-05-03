import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/settings_pages/post_experience/post_experience_viewmodel.dart';
import 'package:goasbar/ui/views/timing/timing_view.dart';
import 'package:goasbar/ui/widgets/creation_aware_item.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:motion_toast/resources/arrays.dart';
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
                  Text('My Experience'.tr(), style: TextStyle(fontSize: 21),),
                  const Spacer(),
                  Text("Add New Experience".tr(), style: TextStyle(color: kMainColor1),).gestures(onTap: () => model.showAddExperienceInfoBottomSheet())
                ],
              ),
              verticalSpaceMedium,
              model.isBusy ? const Loader().center() : Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: model.experienceModels!.count,
                  itemBuilder: (context, index) {
                    return CreationAwareListItem(
                      itemCreated: () => model.getProviderExperiencesFromNextPage(index: index + 1),
                      child: Container(
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
                                  children: [
                                    Text(model.data![index].title!),
                                    horizontalSpaceSmall,
                                    Text('${model.data![index].status!.substring(0, 1)}${model.data![index].status!.substring(1).toLowerCase()}', style: const TextStyle(color: kMainColor1)),
                                  ],
                                ),
                                Container(
                                  height: 22,
                                  width: 22,
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 1,),
                                      borderRadius: BorderRadius.circular(30)
                                  ),
                                  child: Icon(model.isCollapsed[index]! ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 17,).center(),
                                ).gestures(onTap: () => model.collapse(index: index)),
                              ],
                            ),
                            verticalSpaceSmall,
                            Stack(
                              children: [
                                Container(
                                  height: 100,
                                  width: 500,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: model.data![index].profileImage != null
                                          ? NetworkImage("$baseUrl${model.data![index].profileImage!}")
                                          : const AssetImage("assets/images/img_post_exp.png") as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                    bottom: 15,
                                    left: 10,
                                    child: Text("City  |  ${model.data![index].city![0]}${model.data![index].city!.substring(1).replaceAll('_', ' ').toLowerCase()}", style: const TextStyle(color: Colors.white,),)
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
                                        Text("Schedule".tr(), style: TextStyle(fontSize: 14)),
                                      ],
                                    ),
                                  ).gestures(onTap: () => model.navigateTo(view: TimingView(experience: model.data![index]))),
                                ),
                              ],
                            ),
                            !model.isCollapsed[index]! ? const SizedBox() : verticalSpaceSmall,
                            !model.isCollapsed[index]! ? const SizedBox() : Text("${"Get your experience this weekend \nwith amazing trip in".tr()} ${model.data![index].city![0]}${model.data![index].city!.substring(1).replaceAll('_', ' ').toLowerCase()}", style: const TextStyle(fontSize: 20)),
                            !model.isCollapsed[index]! ? const SizedBox() : verticalSpaceSmall,
                            !model.isCollapsed[index]! ? const SizedBox() : Text(model.data![index].description!, style: const TextStyle(fontSize: 13, color: kGrayText)),
                            !model.isCollapsed[index]! ? const SizedBox() : verticalSpaceRegular,
                            !model.isCollapsed[index]! ? const SizedBox() : Row(
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
                                      Text('Delete'.tr(), style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.w500),).center(),
                                    ],
                                  ),
                                ).gestures(onTap: () {
                                  model.deleteExperience(experienceId: model.data![index].id, context: context).then((value) {
                                    if (value!) {
                                      showMotionToast(type: MotionToastType.success, context: context, title: "Deleting Success", msg: "Deleting experience has done successfully.");
                                    } else {
                                      showMotionToast(type: MotionToastType.error, context: context, title: "Deleting Failed", msg: "An error has occurred, please try again.");
                                    }
                                  });
                                }),
                                Container(
                                  width: 150,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                    gradient: kMainGradient,
                                  ),
                                  child: Text('Update'.tr(), style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),).center(),
                                ).gestures(onTap: () {
                                  model.showAddExperienceInfoBottomSheet(experience: model.experienceModels!.results![index],);
                                }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ).padding(horizontal: 16, top: 16),
        ),
      ),
      viewModelBuilder: () => PostExperienceViewModel(context: context),
    );
  }
}
