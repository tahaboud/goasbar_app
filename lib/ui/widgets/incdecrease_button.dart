import 'package:flutter/cupertino.dart';
import 'package:goasbar/enum/incdecrease.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/ui/views/confirm_booking/confirm_booking_viewmodel.dart';
import 'package:styled_widget/styled_widget.dart';

class IncDecreaseButton extends StatelessWidget {
  const IncDecreaseButton({
    Key? key,
    this.incDecrease,
    this.model,
  }) : super(key: key);
  final IncDecrease? incDecrease;
  final ConfirmBookingViewModel? model;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      // padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(incDecrease == IncDecrease.increase ? '+' : '-', style: const TextStyle(color: kMainColor1, fontSize: 25),).center(),
    ).gestures(onTap: () => model!.incDecrease(value: incDecrease == IncDecrease.increase ? 1 : -1));
  }
}