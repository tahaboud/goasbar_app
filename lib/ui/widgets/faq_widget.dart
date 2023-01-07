import 'package:flutter/cupertino.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';

class FAQWidget extends StatelessWidget {
  const FAQWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidthPercentage(context, percentage: 0.8),
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: kMainGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          horizontalSpaceMedium,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 8,
                width: 30,
                decoration: BoxDecoration(
                  color: const Color(0xffCE9A33),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              horizontalSpaceSmall,
              const Text('Getting Started', style: TextStyle(fontWeight: FontWeight.bold),),
            ],
          ),
          verticalSpaceSmall,
          Container(
            width: screenWidthPercentage(context, percentage: 0.6),
            height: 47,
            padding: const EdgeInsets.only(left: 40),
            child: const Text(
              "Lorem Ipsum Dolor Sit Amet, Consetetur Sadipscing Elitr, Sed Diam Nonumy Eirmod Tempor Invidunt Ut Labore Et Dolore Magna.",
              style: TextStyle(
                fontSize: 14,
              ),
              overflow: TextOverflow.clip,
            ),
          ),
        ],
      ),
    );
  }
}