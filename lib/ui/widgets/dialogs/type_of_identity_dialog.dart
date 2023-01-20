import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:styled_widget/styled_widget.dart';

class TypeOfIdentityDialog extends HookWidget {
  final DialogRequest? dialogRequest;
  final Function(DialogResponse)? onDialogTap;
  const TypeOfIdentityDialog({Key? key, this.dialogRequest, this.onDialogTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidthPercentage(context, percentage: 0.4),
      height: 81,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            height: 40,
            color : dialogRequest!.data == 'Passport' ? kMainDisabledGray : Colors.white,
            child: const Text('Passport')
                .center(),
          ).gestures(onTap: () {
            onDialogTap!(DialogResponse(data: 'Passport',));
          }),
          const Divider(height: 1, thickness: 2),
          // verticalSpaceRegular,
          Container(
            height: 40,
            color : dialogRequest!.data == 'National Card ID' ? kMainDisabledGray : Colors.white,
            child: const Text('National Card ID')
                .center(),
          ).gestures(onTap: () {
            onDialogTap!(DialogResponse(data: 'National Card ID',));
          }),
        ],
      ),
    );
  }
}