import 'package:flutter/cupertino.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:goasbar/shared/colors.dart';

class SeenWidgetMe extends StatelessWidget {
  const SeenWidgetMe({
    Key? key,
    this.time,
  }) : super(key: key);
  final String? time;

  @override
  Widget build(BuildContext context) {
    return Text(time!, style: const TextStyle(color: kMainGray, fontSize: 13),).padding(horizontal: 5);
  }
}