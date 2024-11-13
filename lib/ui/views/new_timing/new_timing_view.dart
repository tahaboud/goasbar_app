import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/data_models/timing_response.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/new_timing/new_timing_viewmodel.dart';
import 'package:goasbar/ui/views/timing/timing_viewmodel.dart';
import 'package:styled_widget/styled_widget.dart';

class NewTimingView extends HookWidget {
  const NewTimingView(
      {super.key,
      required this.model,
      required this.experienceTitle,
      required this.experienceId,
      this.timing});

  final TimingViewModel model;
  final String experienceTitle;
  final int experienceId;
  final TimingResponse? timing;

  @override
  Widget build(BuildContext context) {
    var numOfPeople = useTextEditingController();
    var startDate = useTextEditingController();
    var startTime = useTextEditingController();
    final numOfPeopleError = useState<String?>(null);
    final startDateError = useState<String?>(null);
    final startTimeError = useState<String?>(null);

    if (timing != null) {
      numOfPeople.text = timing!.capacity.toString();
      startDate.text = timing?.date ?? "";
      startTime.text = timing?.startTime ?? "";
    }

    bool validateCreateTiming() {
      bool isValid = true;
      if (numOfPeople.text.isEmpty || int.parse(numOfPeople.text) < 1) {
        numOfPeopleError.value = "Number of people must be greater than 1.";
        isValid = false;
      }
      if (DateFormat("yyyy-MM-dd")
              .parse(startDate.text)
              .compareTo(DateTime.now()) <=
          0) {
        startDateError.value = "Date must be greater than today.";
        isValid = false;
      }
      if (startTime.text.isEmpty) {
        startTimeError.value = "This field is required.";
        isValid = false;
      }
      return isValid;
    }

    void handleCreateTiming() {
      final isValid = validateCreateTiming();
      if (isValid) {
        var body = {};
        body.addAll({
          "date": startDate.text,
          "start_time": startTime.text,
          "capacity": numOfPeople.text,
        });

        if (timing == null) {
          NewTimingViewModel()
              .createTiming(
            context: context,
            body: body,
            experienceId: experienceId,
          )
              .then((value) {
            model.back();
            model.getTimingsList();
          });
        } else {
          NewTimingViewModel()
              .updateTiming(context: context, body: body, timingId: timing?.id)
              .then((value) {
            model.back();
            model.getTimingsList();
          });
        }
      }
    }

    return Scaffold(
        body: Container(
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
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          verticalSpaceSmall,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.close,
                size: 30,
              ).gestures(onTap: () => model.back()),
              Text('NEW TIMING'.tr(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              horizontalSpaceLarge,
            ],
          ),
          verticalSpaceLarge,
          Text(
            experienceTitle,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          const Divider(thickness: 1.2, height: 40),
          verticalSpaceRegular,
          const Text(
            'Experience Date',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          verticalSpaceSmall,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 58,
                width: screenWidthPercentage(context, percentage: 0.42),
                child: TextField(
                  controller: startDate,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: '20 Sep 2022',
                    errorText: startDateError.value,
                    hintStyle: const TextStyle(fontSize: 14),
                    prefixIcon:
                        Image.asset('assets/icons/birth_date.png').gestures(
                      onTap: () => NewTimingViewModel()
                          .showStartDatePicker(context, startDate),
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
                height: 58,
                width: screenWidthPercentage(context, percentage: 0.42),
                child: TextField(
                  controller: startTime,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: '8:30',
                    errorText: startTimeError.value,
                    hintStyle: const TextStyle(fontSize: 14),
                    prefixIcon: const Icon(Icons.access_time).gestures(
                      onTap: () => NewTimingViewModel()
                          .showStartTimePicker(context, startTime),
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
              ).gestures(
                onTap: () => NewTimingViewModel()
                    .showStartTimePicker(context, startTime),
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
            height: 58,
            child: TextField(
              controller: numOfPeople,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Add people',
                errorText: numOfPeopleError.value,
                hintStyle: const TextStyle(fontSize: 14),
                prefixIcon: const Icon(Icons.person_outline_rounded),
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
          verticalSpaceMedium,
          Container(
            width: MediaQuery.of(context).size.width - 60,
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
              handleCreateTiming();
            },
          ),
          verticalSpaceRegular,
        ],
      ),
    ).height(screenHeightPercentage(context, percentage: 0.85)));
  }
}
