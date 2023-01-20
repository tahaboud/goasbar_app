import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/timing/timing_viewmodel.dart';
import 'package:goasbar/ui/widgets/timing_item.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/cupertino.dart';

class TimingView extends HookWidget {
  const TimingView({Key? key}) : super(key: key);

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
                    Text(model.formatMonthYear(model.selectedDate), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
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
                    ).gestures(onTap: () => model.showNewTimingBottomSheet()),
                  ],
                ),
                verticalSpaceRegular,
                CalendarDatePicker2(
                  initialValue: [
                    DateTime(2023, 1, 17),
                    DateTime.now(),
                  ],
                  config: CalendarDatePicker2Config(
                    disableYearPicker: true,
                    calendarType: CalendarDatePicker2Type.range,
                    selectedDayHighlightColor: kMainColor1,
                    lastMonthIcon: Container(),
                    nextMonthIcon: Container(),
                    controlsHeight: 0
                  ),
                  onValueChanged: (val) {

                  },
                  onDisplayedMonthChanged: (date) {
                    model.selectDate(date: date);
                  },
                ),
                verticalSpaceSmall,
                const Text('Timings', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600),).alignment(Alignment.centerLeft),
                verticalSpaceSmall,
                TimingItem(showBooking: () => model.showBookingList()),
                const Divider(thickness: 1, height: 30),
                const TimingItem(),
                const Divider(thickness: 1, height: 30),
                const TimingItem(),
                verticalSpaceMedium,
              ],
            ).padding(horizontal: 16, top: 16),
          ),
        ),
      ),
      viewModelBuilder: () => TimingViewModel(),
    );
  }
}
