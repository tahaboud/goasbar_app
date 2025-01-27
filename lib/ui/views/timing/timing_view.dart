import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/data_models/experience_response.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/new_timing/new_timing_view.dart';
import 'package:goasbar/ui/views/timing/timing_viewmodel.dart';
import 'package:goasbar/ui/widgets/creation_aware_item.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:goasbar/ui/widgets/timing_item.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class TimingView extends HookWidget {
  const TimingView({super.key, this.experience});
  final ExperienceResults? experience;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TimingViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(CupertinoIcons.arrow_turn_up_right)
                        .height(40)
                        .width(40)
                        .gestures(onTap: () {
                      model.back();
                    }),
                    Text(
                      'My Experience'.tr(),
                      style: const TextStyle(fontSize: 21),
                    ),
                  ],
                ),
                verticalSpaceMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      model.formatMonthYear(
                          model.selectedFormattedMonthYearDate),
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: kMainColor1.withOpacity(0.3),
                      ),
                      child: Row(
                        children: [
                          Text("Offer new timing".tr(),
                              style: const TextStyle(color: kMainColor1)),
                          const Icon(
                            Icons.add,
                            color: kMainColor1,
                            size: 25,
                          )
                        ],
                      ),
                    ).gestures(
                        onTap: () => {
                              model.navigateTo(
                                  view: NewTimingView(
                                      model: model,
                                      experienceTitle: experience?.title ?? "",
                                      experienceId: experience?.id ?? 1))
                            })
                  ],
                ),
                verticalSpaceRegular,
                CalendarDatePicker2(
                  value: [
                    model.selectedDate,
                  ],
                  config: CalendarDatePicker2Config(
                      disableModePicker: true,
                      firstDate: DateTime.now(),
                      calendarType: CalendarDatePicker2Type.single,
                      selectedDayHighlightColor: kMainColor1,
                      lastMonthIcon: Container(),
                      nextMonthIcon: Container(),
                      controlsHeight: 0),
                  onValueChanged: (date) {
                    model.selectDate(date: date[0]);
                  },
                  onDisplayedMonthChanged: (date) {
                    model.selectFormatMonthYear(date: date);
                  },
                ),
                verticalSpaceSmall,
                Text(
                  'Timings'.tr(),
                  style: const TextStyle(
                      fontSize: 21, fontWeight: FontWeight.w600),
                ).alignment(Alignment.centerRight),
                verticalSpaceSmall,
                model.isBusy
                    ? const Loader().center()
                    : model.timingListModel!.count! == 0
                        ? Text('No Timing Yet'.tr())
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: model.timingListModel!.count,
                            itemBuilder: (context, index) {
                              return CreationAwareListItem(
                                itemCreated: () =>
                                    model.getTimingsListFromNextPage(
                                        index: index + 1),
                                child: Column(
                                  children: [
                                    TimingItem(
                                      timing: model
                                          .timingListModel!.results![index],
                                      experience: experience!,
                                      bookings: model
                                                  .timingListModel!
                                                  .results![index]
                                                  .availability !=
                                              null
                                          ? model.timingListModel!
                                                  .results![index].capacity! -
                                              model.timingListModel!
                                                  .results![index].availability!
                                          : 0,
                                      showBooking: () => model.showBookingList(
                                        timingId: model.timingListModel!
                                            .results![index].id,
                                      ),
                                      deleteTiming: () => model
                                          .deleteTiming(
                                              experienceId: experience!.id,
                                              timingId: model.timingListModel!
                                                  .results![index].id)
                                          .then((value) {
                                        if (value!) {
                                          showMotionToast(
                                              title: "Deleting Success",
                                              context: context,
                                              msg:
                                                  "Deleting timing has done successfully.",
                                              type: MotionToastType.success);
                                        } else {}
                                      }),
                                    ).gestures(
                                        onTap: () => model.navigateTo(
                                                view: NewTimingView(
                                              model: model,
                                              experienceTitle:
                                                  experience?.title ?? "",
                                              experienceId: experience?.id ?? 1,
                                              timing: model.timingListModel!
                                                  .results![index],
                                            ))),
                                    const Divider(thickness: 1, height: 30),
                                  ],
                                ),
                              );
                            },
                          ),
              ],
            ).padding(horizontal: 16, top: 16),
          ),
        ),
      ),
      viewModelBuilder: () =>
          TimingViewModel(experience: experience!, context: context),
    );
  }
}
