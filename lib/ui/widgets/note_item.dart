import 'package:flutter/cupertino.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/widgets/note_item_dot.dart';
import 'package:goasbar/ui/widgets/note_item_text.dart';

class NoteItem extends StatelessWidget {
  const NoteItem({
    Key? key,
    this.text,
  }) : super(key: key);
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        horizontalSpaceSmall,
        const NoteItemDot(),
        horizontalSpaceSmall,
        NoteItemText(text: text!),
      ],
    );
  }
}