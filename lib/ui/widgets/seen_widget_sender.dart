import 'package:flutter/cupertino.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';

class SeenWidgetSender extends StatelessWidget {
  const SeenWidgetSender({
    Key? key,
    this.time,
  }) : super(key: key);
  final String? time;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(time!, style: const TextStyle(color: kMainGray, fontSize: 13),),
        horizontalSpaceSmall,
        Image.asset("assets/icons/sms.png"),
      ],
    );
  }
}