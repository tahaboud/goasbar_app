import 'package:flutter/cupertino.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:goasbar/shared/ui_helpers.dart';

class SliderImageItem extends StatelessWidget {
  const SliderImageItem({
    Key? key,
    this.path,
    this.isAsset,
  }) : super(key: key);
  final String? path;
  final bool? isAsset;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: screenWidthPercentage(context, percentage: 1),
      padding: const EdgeInsets.symmetric(horizontal: 20,),
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: isAsset! ? AssetImage(path!) : NetworkImage('$baseUrl$path') as ImageProvider,
        ),
      ),
    );
  }
}