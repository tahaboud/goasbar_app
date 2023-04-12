import 'package:flutter/material.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:styled_widget/styled_widget.dart';

class PreviousButton extends StatelessWidget {
  const PreviousButton({
    Key? key,
    this.onTap,
  }) : super(key: key);
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidthPercentage(context, percentage: 0.4),
      height: 50,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: kMainColor1, width: 1.5)
      ),
      child: const Center(
        child: Text('PREVIOUS', style: TextStyle(color: kMainColor1, fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500),),
      ),
    ).gestures(
      onTap: () => onTap!(),
    );
  }
}