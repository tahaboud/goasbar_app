import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class DotItem extends StatelessWidget {
  const DotItem({
    Key? key,
    this.condition,
    this.color = Colors.white,
  }) : super(key: key);
  final bool? condition;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),)
        .height(8)
        .width(8)
        .opacity(condition! ? 1 : 0.6, animate: true)
        .animate(const Duration(milliseconds: 200), Curves.easeIn);
  }
}