import 'package:flutter/cupertino.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:styled_widget/styled_widget.dart';

class SettingsCardItem extends StatelessWidget {
  const SettingsCardItem({
    Key? key,
    this.image,
    this.title,
    this.parameter,
    this.onTapParameter,
  }) : super(key: key);
  final String? image;
  final String? title;
  final String? parameter;
  final Function()? onTapParameter;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset("assets/icons/settings/$image.png", width: 20),
            horizontalSpaceSmall,
            Text(title!),
          ],
        ),
        Text(parameter!, style: TextStyle(color: kMainColor2.withOpacity(0.8)),).gestures(onTap: onTapParameter),
      ],
    ).padding(horizontal: 20);
  }
}