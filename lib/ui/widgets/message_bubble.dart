import 'package:goasbar/shared/colors.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/shared/ui_helpers.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key? key,
    this.message,
    this.isSender,
  }) : super(key: key);
  final String? message;
  final bool? isSender;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidthPercentage(context, percentage: 0.8),
      child: Text(
        message!,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: isSender! ? Colors.black : Colors.white),
        textAlign: isSender! ? TextAlign.left : TextAlign.right,
      ).padding(horizontal: 20, vertical: 10),
    ).decorated(
      color: isSender! ? kAgencyColor : kMainColor1,
      borderRadius: BorderRadius.only(
        topRight: isSender! ? const Radius.circular(20) : const Radius.circular(5),
        bottomRight: isSender! ? const Radius.circular(20) : const Radius.circular(5),
        topLeft: isSender! ? const Radius.circular(5) : const Radius.circular(20),
        bottomLeft: isSender! ? const Radius.circular(5) : const Radius.circular(20),
      ),
    );
  }
}