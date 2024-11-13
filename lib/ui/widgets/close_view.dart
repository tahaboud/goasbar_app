import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class CloseView extends StatelessWidget {
  const CloseView({super.key, this.onTap});
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: (const Color(0xffE3E3F1)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: IconButton(
          icon: const Icon(Icons.close),
          onPressed: onTap,
          style: IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
        )).height(40).width(40).gestures(onTap: onTap);
  }
}
