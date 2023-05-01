import 'package:flutter/cupertino.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:styled_widget/styled_widget.dart';

class AddPaymentMethodCard extends StatelessWidget {
  const AddPaymentMethodCard({
    Key? key,
    this.image,
    this.isSelected,
    this.onTap,
  }) : super(key: key);
  final String? image;
  final bool? isSelected;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(width: isSelected! ? 2 : 1, color: isSelected! ? kMainColor2.withOpacity(0.8) : kGrayText,),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Image.asset('assets/icons/$image.png', width: image == 'mada_method' ? 70 : 50).center(),
    ).gestures(onTap: onTap);
  }
}