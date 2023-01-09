import 'package:flutter/cupertino.dart';
import 'package:goasbar/shared/ui_helpers.dart';

class NoteItemText extends StatelessWidget {
  const NoteItemText({
    Key? key,
    this.text,
  }) : super(key: key);
  final String? text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidthPercentage(context, percentage: 0.8),
      child: Text(
        text!,
      ),
    );
  }
}