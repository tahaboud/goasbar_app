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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Icon(CupertinoIcons.clear_circled, size: 20),
              horizontalSpaceSmall,
            ],
          ).gestures(onTap: () => onDialogTap!(DialogResponse())),
          verticalSpaceSmall,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  horizontalSpaceMedium,
                  Text('Booked Places : '),
                ],
              ),
              Row(
                children: [
                  Text(dialogRequest!.data.capacity.toString(), style: const TextStyle(color: kMainColor1),),
                  const Text(" Seats",),
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
                children: const [
                  horizontalSpaceMedium,
                  Text('Available Seats : '),
                ],
              ),
              Row(
                children: [
                  Text(dialogRequest!.data.availability.toString(), style: const TextStyle(color: kMainColor1),),
                  const Text(" Seats",),
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