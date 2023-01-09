import 'package:flutter/cupertino.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/widgets/saved_experience_card/saved_experience_card.dart';

class SavedExperiences extends StatelessWidget {
  const SavedExperiences({
    Key? key,
    required this.text,
    this.onTap,
  }) : super(key: key);

  final String? text;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        verticalSpaceMedium,
        Text(text!, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
        verticalSpaceMedium,
        GridView(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
          ),
          children: const [
            SavedExperience(),
            SavedExperience(),
            SavedExperience(),
            SavedExperience(),
          ],
        ),
      ],
    );
  }
}