import 'package:goasbar/shared/colors.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/shared/ui_helpers.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key? key,
    this.message,
    this.isReciever,
  }) : super(key: key);
  final String? message;
  final bool? isReciever;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          // width: screenWidthPercentage(context, percentage: 0.8),
          child: Text(
            message!,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: isReciever! ? Colors.black : Colors.white),
            textAlign: isReciever! ? TextAlign.left : TextAlign.right,
          ).padding(horizontal: 20, vertical: 10),
        ).decorated(
          color: isReciever! ? kAgencyColor : kMainColor1,
          borderRadius: BorderRadius.only(
            topRight: isReciever! ? const Radius.circular(20) : const Radius.circular(5),
            bottomRight: isReciever! ? const Radius.circular(20) : const Radius.circular(5),
            topLeft: isReciever! ? const Radius.circular(5) : const Radius.circular(20),
            bottomLeft: isReciever! ? const Radius.circular(5) : const Radius.circular(20),
          ),
        ),
      ],
    );
  }
}