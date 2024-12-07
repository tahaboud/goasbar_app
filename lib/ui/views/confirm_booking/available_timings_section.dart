import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/confirm_booking/confirm_booking_viewmodel.dart';
import 'package:goasbar/ui/widgets/creation_aware_item.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:styled_widget/styled_widget.dart';

class AvailableTimingsSection extends HookWidget {
  const AvailableTimingsSection({super.key, required this.model});

  final ConfirmBookingViewModel model;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              horizontalSpaceSmall,
              Text(
                'Availability'.tr(),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Row(
            children: [
              Image.asset('assets/icons/birth_date.png', color: kMainColor1),
              horizontalSpaceSmall,
            ],
          ).gestures(
              onTap: () => model.showAvailableTimingsPicker(context: context)),
        ],
      ),
      model.isBusy
          ? const SizedBox()
          : model.data!.count == 0
              ? const SizedBox()
              : verticalSpaceMedium,
      model.isBusy
          ? const Loader().center()
          : model.data!.count == 0
              ? const SizedBox()
              : SizedBox(
                  height: 105,
                  child: ListView.builder(
                    itemCount: model.data!.count,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return CreationAwareListItem(
                          itemCreated: () =>
                              model.getExperiencePublicTimingsFromNextPage(
                                  index: index),
                          child: Container(
                            width: 120,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                    model.formatDate(
                                        model.data!.results![index].date!),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: index == model.selectedIndex
                                            ? Colors.white
                                            : Colors.black)),
                                Text(
                                  "${model.data!.results![index].date!.substring(8, 10)}/${model.data!.results![index].date!.substring(5, 7)}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: index == model.selectedIndex
                                          ? Colors.white
                                          : Colors.black),
                                ),
                                Text(
                                    model.data!.results![index].startTime!
                                        .substring(0, 5),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: index == model.selectedIndex
                                            ? Colors.white
                                            : kMainColor1)),
                              ],
                            ),
                          )
                              .decorated(
                                  border: Border.all(
                                      color: Colors.black38,
                                      width:
                                          model.selectedIndex == index ? 0 : 2),
                                  borderRadius: BorderRadius.circular(10),
                                  color: index == model.selectedIndex
                                      ? kMainColor1
                                      : Colors.transparent,
                                  animate: true)
                              .padding(right: 10)
                              .animate(const Duration(milliseconds: 300),
                                  Curves.easeIn)
                              .gestures(onTap: () {
                            model.changeSelection(index: index);
                          }));
                    },
                  ),
                ),
    ]);
  }
}
