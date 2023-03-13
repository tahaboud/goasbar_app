import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/widgets/dialogs/booking_list/booking_list_viewmodel.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:goasbar/ui/widgets/profile_booked/profile_booked.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:styled_widget/styled_widget.dart';

class BookingListDialog extends HookWidget {
  final DialogRequest? dialogRequest;
  final Function(DialogResponse)? onDialogTap;
  const BookingListDialog({Key? key, this.dialogRequest, this.onDialogTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BookingListViewModel>.reactive(
      builder: (context, model, child) {
        return Dialog(
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
                const Text(
                  "Booking List",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                verticalSpaceMedium,
                !model.dataReady ? const Loader().center() : Expanded(
                  child: ListView.builder(
                    itemCount: model.data!.length,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ProfileBookedView(user: model.data![index]!.user, experienceId: dialogRequest!.customData),
                          const Divider(height: 30, thickness: 1,),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ).height(60 + 62 * 7);
      },
      viewModelBuilder: () => BookingListViewModel(context: context, timingId: dialogRequest!.data,),
    );
  }
}