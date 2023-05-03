import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/data_models/timing_response.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/new_timing/new_timing_viewmodel.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:easy_localization/easy_localization.dart';

class NewTimingView extends HookWidget {
  NewTimingView({Key? key, required this.request, required this.completer})
      : super(key: key);

  final SheetRequest request;
  final Function(SheetResponse) completer;
  bool? once = true;

  @override
  Widget build(BuildContext context) {
    var addPeople = useTextEditingController();

    return ViewModelBuilder<NewTimingViewModel>.reactive(
      builder: (context, model, child) {
        if (!model.isBusy && once!) {
          model.startDate.text = request.data;
          if (request.customData is TimingResponse) {
            model.startTime.text = request.customData.startTime;
            addPeople.text = request.customData.capacity.toString();
          }
          if (request.customData is Map)  {
            model.startTime.text = request.customData['timing'].startTime;
            addPeople.text = request.customData['timing'].capacity.toString();
          }
          once = false;
        }

        return Container(
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
                  const Icon(Icons.close, size: 30,).gestures(onTap: () => model.back()),
                  Text(request.customData is TimingResponse || request.customData is Map ? 'UPDATE TIMING'.tr() : 'NEW TIMING'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  horizontalSpaceLarge,
                ],
              ),
              verticalSpaceLarge,
              Text(request.customData is TimingResponse || request.customData is Map ? request.customData['experience'].title : request.customData!.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
              const Divider(thickness: 1.2, height: 40),
              verticalSpaceRegular,
              const Text('Experience Date', style: TextStyle(fontWeight: FontWeight.bold),),
              verticalSpaceSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 58,
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
                    height: 58,
                    width: screenWidthPercentage(context, percentage: 0.42),
                    child: TextField(
                      controller: model.startTime,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: '8:30 AM',
                        hintStyle: const TextStyle(fontSize: 14),
                        prefixIcon: const Icon(Icons.access_time).gestures(onTap: () => model.showStartTimePicker(context),),
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
                  ).gestures(onTap: () => model.showStartTimePicker(context),),
                ],
              ),
              verticalSpaceRegular,
              Text('Capacity ( people )'.tr(), style: TextStyle(fontWeight: FontWeight.bold),),
              verticalSpaceSmall,
              SizedBox(
                height: 58,
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

              verticalSpaceMedium,
              Container(
                width: MediaQuery.of(context).size.width - 60,
                height: 50,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  gradient: kMainGradient,
                ),
                child: Center(
                  child: Text('NEXT'.tr(), style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500),),
                ),
              ).gestures(
                onTap: () {
                  if (model.startDate.text.isNotEmpty && model.startTime.text.isNotEmpty && addPeople.text.isNotEmpty) {
                    var body = {};
                    if (request.customData is TimingResponse || request.customData is Map) {
                      TimingResponse? timingResponse;
                      if (request.customData is Map) {
                        timingResponse = request.customData['timing'];
                      } else {
                        timingResponse = request.customData;
                      }

                      if (model.pickedTimeForRequest != null) {
                        body.addAll({"start_time": model.pickedTimeForRequest});
                      }
                      if (model.startDate.text != request.data) {
                        body.addAll({"date": model.startDate.text});
                      }
                      if (addPeople.text != timingResponse!.capacity.toString()) {
                        body.addAll({"date": model.startDate.text});
                      }
                      if (model.startTime.text != timingResponse.startTime
                          || addPeople.text != timingResponse.capacity.toString()
                          || model.startDate.text != request.data) {

                        model.updateTiming(context: context, body: body, timingId: timingResponse.id,).then((value) {
                          if (value == null) {
                            showMotionToast(context: context, title: 'Timing Update Failed', msg: "Timing could not be updated", type: MotionToastType.error);
                          } else {
                            completer(SheetResponse(confirmed: true));
                          }
                        });
                      } else {
                        showMotionToast(context: context, title: 'Warning', msg: "Update the timing first", type: MotionToastType.warning);
                      }
                    } else {
                      body.addAll({
                        "date": model.startDate.text,
                        "start_time": model.pickedTimeForRequest,
                        "capacity": addPeople.text,
                      });

                      model.createTiming(context: context, body: body, experienceId: request.customData.id,).then((value) {
                        if (value == null) {
                          showMotionToast(context: context, type: MotionToastType.error, title: "Timing Creation Failed", msg: "An error has occurred, please try again.");
                        } else {
                          completer(SheetResponse(confirmed: true));
                        }
                      });
                    }
                  } else {
                    showMotionToast(context: context, type: MotionToastType.warning, title: "Warning", msg: "All files are mandatory.");
                  }
                },
              ),
              verticalSpaceRegular,
            ],
          ),
        ).height(screenHeightPercentage(context, percentage: 0.85));
      },
      viewModelBuilder: () => NewTimingViewModel(),
    );
  }
}