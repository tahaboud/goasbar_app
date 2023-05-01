import 'package:flutter/cupertino.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:styled_widget/styled_widget.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    Key? key,
    this.onTap,
  }) : super(key: key);
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset("assets/icons/logo_notification.png",),
        horizontalSpaceSmall,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('We have an update for you',),
            verticalSpaceSmall,
            Text('New experinces from Elsalam egency', style: TextStyle(color: kMainDisabledGray, fontSize: 12),)
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const [
            Text('2 min ago', style: TextStyle(color: kMainDisabledGray,),),
            verticalSpaceSmall,
          ],
        ),
      ],
    ).padding(bottom: 20).gestures(onTap: onTap);
  }
}