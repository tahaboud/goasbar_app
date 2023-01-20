import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:styled_widget/styled_widget.dart';

class GenderConstraintsDialog extends HookWidget {
  final DialogRequest? dialogRequest;
  final Function(DialogResponse)? onDialogTap;
  const GenderConstraintsDialog({Key? key, this.dialogRequest, this.onDialogTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidthPercentage(context, percentage: 0.4),
      height: 125,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            height: 40,
            color : dialogRequest!.data == 'No constrains' ? kMainDisabledGray : Colors.white,
            child: const Text('No constrains')
                .center(),
          ).gestures(onTap: () {
            onDialogTap!(DialogResponse(data: 'No constrains',));
          }),
          const Divider(height: 1, thickness: 2),

          Container(
            height: 40,
            color : dialogRequest!.data == 'Men Only' ? kMainDisabledGray : Colors.white,
            child: const Text('Men Only')
                .center(),
          ).gestures(onTap: () {
            onDialogTap!(DialogResponse(data: 'Men Only',));
          }),

          const Divider(height: 1, thickness: 2),

          Container(
            height: 40,
            color : dialogRequest!.data == 'Women Only' ? kMainDisabledGray : Colors.white,
            child: const Text('Women Only')
                .center(),
          ).gestures(onTap: () {
            onDialogTap!(DialogResponse(data: 'Women Only',));
          }),
        ],
      ),
    );
  }
}