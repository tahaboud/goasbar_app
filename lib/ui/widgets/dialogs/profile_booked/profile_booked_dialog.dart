import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/widgets/dialogs/profile_booked/profile_booked_dialog_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:styled_widget/styled_widget.dart';

class ProfileBookedDialog extends HookWidget {
  final DialogRequest? dialogRequest;
  final Function(DialogResponse)? onDialogTap;
  const ProfileBookedDialog({Key? key, this.dialogRequest, this.onDialogTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileBookedDialogViewModel>.reactive(
      builder: (context, model, child) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      dialogRequest!.customData!['index'] < 9 ? "#0${dialogRequest!.customData!['index'] + 1}" : "#${dialogRequest!.customData!['index'] + 1}",
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    horizontalSpaceRegular,
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: dialogRequest!.data!.status == "CONFIRMED" ? kMainColor1 : Colors.redAccent,
                      ),
                      child: Text(dialogRequest!.data!.status!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),).center(),
                    ),
                  ],
                ),
                verticalSpaceMedium,
                Text("${dialogRequest!.data.user!.firstName} ${dialogRequest!.data.user!.lastName}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),).alignment(Alignment.centerLeft),
                verticalSpaceSmall,
                const Text("- - - - - - - - - - - - - - - - - - - - - - -", style: TextStyle(color: kGrayText, fontSize: 20, fontWeight: FontWeight.bold),).alignment(Alignment.centerLeft),
                verticalSpaceMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Issue number", style: TextStyle(color: kGrayText, fontWeight: FontWeight.bold),),
                            verticalSpaceTiny,
                            Text("${dialogRequest!.data.experienceTiming.date} ${dialogRequest!.data.experienceTiming.startTime.toString().substring(0, 5)}"),
                          ],
                        ),
                        verticalSpaceMedium,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("City", style: TextStyle(color: kGrayText, fontWeight: FontWeight.bold),),
                            verticalSpaceTiny,
                            Text(dialogRequest!.data.user!.city),
                          ],
                        ),
                        verticalSpaceMedium,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Email", style: TextStyle(color: kGrayText, fontWeight: FontWeight.bold),),
                            verticalSpaceTiny,
                            Text(dialogRequest!.data.user!.email),
                          ],
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Age", style: TextStyle(color: kGrayText, fontWeight: FontWeight.bold),),
                            verticalSpaceTiny,
                            Text(dialogRequest!.data.user!.age.toString()),
                          ],
                        ),
                        verticalSpaceMedium,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Phone Number", style: TextStyle(color: kGrayText, fontWeight: FontWeight.bold),),
                            verticalSpaceTiny,
                            Text(dialogRequest!.data.user!.phoneNumber),
                          ],
                        ),
                        verticalSpaceMedium,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Affiliate", style: TextStyle(color: kGrayText, fontWeight: FontWeight.bold),),
                            verticalSpaceTiny,
                            Text(dialogRequest!.data.affiliateSet.isEmpty ? "No" : "Yes", style: TextStyle(color: dialogRequest!.data.affiliateSet.isEmpty ? Colors.redAccent : kMainColor1),),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                verticalSpaceMedium,
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: kMainGray, width: 1.2)
                  ),
                  child: const Text('View More Additional Booking', style: TextStyle(color: kGrayText),).center(),
                ).gestures(onTap: () {
                  model.back();
                  model.back();
                }),
                verticalSpaceMedium,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: 50,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gradient: kMainGradient,
                  ),
                  child: const Center(
                    child: Text('ADD NEW BOOKING', style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500),),
                  ),
                ).gestures(
                  onTap: () async {
                    model.back();
                    model.back();
                    model.showNewTimingBottomSheet(experience: dialogRequest!.customData!['experience']);
                  },
                ),
              ],
            ),
          ),
        ).height(screenHeightPercentage(context, percentage: 0.65));
      },
      viewModelBuilder: () => ProfileBookedDialogViewModel(),
    );
  }
}