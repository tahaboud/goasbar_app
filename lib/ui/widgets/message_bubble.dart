import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:styled_widget/styled_widget.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.isSender,
    required this.createdAt,
  });
  final String message;
  final bool isSender;
  final DateTime createdAt;

  String formatDate(String dateString) {
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat("MMM d, yyyy, h:mm a").format(dateTime.toLocal());
    } catch (_) {
      return dateString; // Return original string if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isSender ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment:
              isSender ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: screenWidth(context) - 40,
              ),
              child: SizedBox(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.right,
                ).padding(horizontal: 20, vertical: 10),
              ).decorated(
                color: isSender ? Colors.green : kMainColor1,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
            ),
            Text(formatDate(createdAt.toString()),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                ))
          ],
        )
      ],
    );
  }
}
