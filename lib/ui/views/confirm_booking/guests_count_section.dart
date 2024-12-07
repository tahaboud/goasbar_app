import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/enum/incdecrease.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/confirm_booking/confirm_booking_viewmodel.dart';
import 'package:goasbar/ui/widgets/incdecrease_button.dart';

class GuestsCountSection extends HookWidget {
  const GuestsCountSection({super.key, required this.model});

  final ConfirmBookingViewModel model;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            horizontalSpaceSmall,
            Text(
              'Number of Guests'.tr(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        Row(
          children: [
            IncDecreaseButton(
              incDecrease: IncDecrease.increase,
              model: model,
            ),
            horizontalSpaceSmall,
            Text(
                model.numberOfGuests! < 10
                    ? '0${model.numberOfGuests}'
                    : '${model.numberOfGuests}',
                style: const TextStyle(fontSize: 20)),
            horizontalSpaceSmall,
            IncDecreaseButton(incDecrease: IncDecrease.decrease, model: model),
            horizontalSpaceSmall,
          ],
        ),
      ],
    );
  }
}
