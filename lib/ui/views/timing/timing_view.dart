import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/data_models/experience_response.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/timing/timing_viewmodel.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:goasbar/ui/widgets/timing_item.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/cupertino.dart';

class TimingView extends HookWidget {
  const TimingView({Key? key, this.experience}) : super(key: key);
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
                    const Icon(CupertinoIcons.arrow_turn_up_left).height(40)
                        .width(40)
                        .gestures(
                        onTap: () {
                          model.back();
                        }
                    ),
                    const Text('My Experience', style: TextStyle(fontSize: 21),),
                  ],
                ),
                verticalSpaceMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(model.formatMonthYear(model.selectedFormattedMonthYearDate), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: kMainColor1.withOpacity(0.3),
                      ),
                      child: Row(
                        children: const [
                          Text("Offer new timing", style: TextStyle(color: kMainColor1)),
                          Icon(Icons.add, color: kMainColor1, size: 25,)
                        ],
                      ),
                    ).gestures(onTap: () => model.showNewTimingBottomSheet(date: model.selectedFormattedDate
                        ?? model.formatSelectedDate(date: model.selectedDate))),
                  ],
                ),
                verticalSpaceRegular,
                CalendarDatePicker2(
                  initialValue: [
                    model.selectedDate,
                  ],
                  config: CalendarDatePicker2Config(
                    disableYearPicker: true,
                    firstDate: DateTime.now(),
                    calendarType: CalendarDatePicker2Type.single,
                    selectedDayHighlightColor: kMainColor1,
                    lastMonthIcon: Container(),
                    nextMonthIcon: Container(),
                    controlsHeight: 0
                  ),
                  onValueChanged: (date) {
                    model.selectDate(date: date[0]);
                  },
                  onDisplayedMonthChanged: (date) {
                    model.selectFormatMonthYear(date: date);
                  },
                ),
                verticalSpaceSmall,
                const Text('Timings', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600),).alignment(Alignment.centerLeft),
                verticalSpaceSmall,

                model.isBusy ? const Loader().center() : model.timingListModel!.count! == 0
                    ? const Text('No Timing Yet') : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: model.timingListModel!.count,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        TimingItem(launchMaps: experience!.latitude == null ? () {
                          MotionToast.warning(
                            title: const Text("Maps Cannot Be launched"),
                            description: const Text("The provider did not set the location yet."),
                            animationCurve: Curves.easeIn,
                            animationDuration: const Duration(milliseconds: 200),
                          ).show(context);
                        } : () => model.launchMaps(lat: experience!.latitude, long: experience!.longitude),
                          timing: model.timingListModel!.results![index], experience: experience!,
                          showBooking: () => model.showBookingList(),
                          deleteTiming: () => model.deleteTiming(experienceId: experience!.id, timingId: model.timingListModel!.results![index].id).then((value) {
                            if (value!) {
                              MotionToast.success(
                                title: const Text("Deleting Success"),
                                description: const Text("Deleting timing has done successfully."),
                                animationCurve: Curves.easeIn,
                                animationDuration: const Duration(milliseconds: 200),
                              ).show(context);
                            } else {
                              MotionToast.error(
                                title: const Text("Deleting Failed"),
                                description: const Text("An error has occurred, please try again."),
                                animationCurve: Curves.easeIn,
                                animationDuration: const Duration(milliseconds: 200),
                              ).show(context);
                            }
                          }),
                        ).gestures(onTap: () => model.showNewTimingBottomSheet(timing: model.timingListModel!.results![index],
                            date: model.selectedFormattedDate
                                ?? model.formatSelectedDate(date: model.selectedDate,))),
                        const Divider(thickness: 1, height: 30),
                      ],
                    );
                  },
                ),

              ],
            ).padding(horizontal: 16, top: 16),
          ),
        ),
      ),
      viewModelBuilder: () => TimingViewModel(experienceId: experience!.id, context: context),
    );
  }
}
