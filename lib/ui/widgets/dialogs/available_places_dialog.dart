import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:styled_widget/styled_widget.dart';

class AvailablePlacesDialog extends HookWidget {
  final DialogRequest? dialogRequest;
  final Function(DialogResponse)? onDialogTap;
  const AvailablePlacesDialog({Key? key, this.dialogRequest, this.onDialogTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidthPercentage(context, percentage: 0.4),
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(CupertinoIcons.clear_circled, size: 20),
              horizontalSpaceSmall,
            ],
          ).gestures(onTap: () => onDialogTap!(DialogResponse())),
          verticalSpaceSmall,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  horizontalSpaceMedium,
                  Text('Booked Places : '),
                ],
              ),
              Row(
                children: [
                  Text(
                    dialogRequest!.data.capacity.toString(),
                    style: const TextStyle(color: kMainColor1),
                  ),
                  Text(
                    " ${"Seats".tr()}",
                  ),
                  horizontalSpaceMedium,
                ],
              ),
            ],
          ),
          verticalSpaceSmall,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  horizontalSpaceMedium,
                  Text('Available Seats : '.tr()),
                ],
              ),
              Row(
                children: [
                  Text(
                    dialogRequest!.data.availability.toString(),
                    style: const TextStyle(color: kMainColor1),
                  ),
                  Text(
                    " ${"Seats".tr()}",
                  ),
                  horizontalSpaceMedium,
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
