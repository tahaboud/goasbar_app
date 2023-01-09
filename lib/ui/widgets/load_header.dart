import 'package:flutter/cupertino.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:styled_widget/styled_widget.dart';

class LoadHeader extends StatelessWidget {
  const LoadHeader({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String? text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        verticalSpaceMedium,
        Text(text!, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
        verticalSpaceLarge,
        const Loader().center(),
      ],
    );
  }
}