import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class NoteItemDot extends StatelessWidget {
  const NoteItemDot({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),)
        .height(10)
        .width(10);
  }
}