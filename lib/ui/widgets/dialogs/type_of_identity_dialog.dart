import 'package:easy_localization/easy_localization.dart';
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
            color : dialogRequest!.data == 'National Identity'.tr() ? kMainDisabledGray : Colors.white,
            child: Text('National Identity'.tr())
                .center(),
          ).gestures(onTap: () {
            onDialogTap!(DialogResponse(data: 'National Identity'.tr(),));
          }),
          const Divider(height: 1, thickness: 2),
          // verticalSpaceRegular,
          Container(
            height: 40,
            color : dialogRequest!.data == 'Commercial Registration'.tr() ? kMainDisabledGray : Colors.white,
            child: Text('Commercial Registration'.tr())
                .center(),
          ).gestures(onTap: () {
            onDialogTap!(DialogResponse(data: 'Commercial Registration'.tr(),));
          }),
        ],
      ),
    );
  }
}