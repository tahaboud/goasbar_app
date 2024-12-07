import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/confirm_booking/confirm_booking_viewmodel.dart';

class AvailableSeatsSection extends HookWidget {
  const AvailableSeatsSection({super.key, required this.model});

  final ConfirmBookingViewModel model;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            horizontalSpaceSmall,
            SizedBox(
              width: screenWidthPercentage(context, percentage: 1) - 50,
              child: Text(
                model.selectedIndex == null
                    ? '${"Available Seats".tr()} : ${"Pick a timing first".tr()}'
                    : '${"Available Seats".tr()} : ${model.data!.results![model.selectedIndex!].availability} / ${model.data!.results![model.selectedIndex!].capacity}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
