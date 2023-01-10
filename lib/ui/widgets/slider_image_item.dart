import 'package:flutter/cupertino.dart';
import 'package:goasbar/shared/ui_helpers.dart';

class SliderImageItem extends StatelessWidget {
  const SliderImageItem({
    Key? key,
    this.path,
  }) : super(key: key);
  final String? path;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: screenWidthPercentage(context, percentage: 1),
      padding: const EdgeInsets.symmetric(horizontal: 20,),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(path!)
          )
      ),
    );
  }
}