import 'package:flutter/material.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:styled_widget/styled_widget.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({
    Key? key,
    this.onTap,
  }) : super(key: key);
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset("assets/images/message_pic.png"),
        horizontalSpaceSmall,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('E-salam Agency',),
            verticalSpaceSmall,
            Text('Photo', style: TextStyle(color: kMainDisabledGray, fontSize: 12),)
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text('5 min ago', style: TextStyle(color: kMainDisabledGray,),),
            verticalSpaceSmall,
            SizedBox(
              width: 20,
              height: 20,
              child: const Text('4', style: TextStyle(color: Colors.white)).center(),
            ).decorated(borderRadius: BorderRadius.circular(5), color: Colors.black),
          ],
        ),
      ],
    ).padding(bottom: 20).gestures(onTap: onTap);
  }
}