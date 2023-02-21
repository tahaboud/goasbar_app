import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/data_models/timing_response.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/new_timing/new_timing_viewmodel.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:styled_widget/styled_widget.dart';

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
                  Text(request.customData is TimingResponse ? 'UPDATE TIMING' : 'NEW TIMING', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  horizontalSpaceLarge,
                ],
              ),
              verticalSpaceLarge,
              const Text('DAMMAM TRIP', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
              const Divider(thickness: 1.2, height: 40),
              verticalSpaceRegular,
              const Text('Date start', style: TextStyle(fontWeight: FontWeight.bold),),
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
                        prefixIcon: Image.asset('assets/icons/birth_date.png'),
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

              verticalSpaceMedium,
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
                  if (model.startDate.text.isNotEmpty && model.startTime.text.isNotEmpty && addPeople.text.isNotEmpty) {
                    var body = {};
                    if (request.customData is TimingResponse) {
                      if (model.pickedTimeForRequest != null) {
                        body.addAll({"start_time": model.pickedTimeForRequest});
                      }
                      if (model.startDate.text != request.data) {
                        body.addAll({"date": model.startDate.text});
                      }
                      if (model.startTime.text != request.customData.startTime
                          || addPeople.text != request.customData.capacity.toString()
                          || model.startDate.text != request.data) {
                        var body = {
                          "date": model.startDate.text,
                          "start_time": model.pickedTimeForRequest,
                          "capacity": addPeople.text,
                        };

                        print(body);

                        model.updateTiming(body: body, timingId: request.customData.id,).then((value) {
                          if (value == null) {
                            MotionToast.error(
                              title: const Text("Timing Update Failed"),
                              description: const Text("An error has occurred, please try again."),
                              animationCurve: Curves.easeIn,
                              animationDuration: const Duration(milliseconds: 200),
                            ).show(context);
                          } else {
                            completer(SheetResponse(confirmed: true));
                          }
                        });
                      }
                    } else {
                      var body = {
                        "date": model.startDate.text,
                        "start_time": model.pickedTimeForRequest,
                        "capacity": addPeople.text,
                      };

                      model.createTiming(body: body, experienceId: request.customData,).then((value) {
                        if (value == null) {
                          MotionToast.error(
                            title: const Text("Timing Creation Failed"),
                            description: const Text("An error has occurred, please try again."),
                            animationCurve: Curves.easeIn,
                            animationDuration: const Duration(milliseconds: 200),
                          ).show(context);
                        } else {
                          completer(SheetResponse(confirmed: true));
                        }
                      });
                    }
                  } else {
                    MotionToast.warning(
                      title: const Text("Warning"),
                      description: const Text("All files are mandatory."),
                      animationCurve: Curves.easeIn,
                      animationDuration: const Duration(milliseconds: 200),
                    ).show(context);
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