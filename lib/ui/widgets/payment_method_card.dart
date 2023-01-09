import 'package:flutter/cupertino.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';

class PaymentMethodCard extends StatelessWidget {
  const PaymentMethodCard({
    Key? key,
    this.text,
    this.method,
  }) : super(key: key);
  final String? text;
  final String? method;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kMainColor2.withOpacity(0.8), width: 1),
      ),
      child: Row(
        children: [
          Image.asset('assets/icons/$method.png'),
          horizontalSpaceRegular,
          Text(text!, style: const TextStyle(fontWeight: FontWeight.bold),)
        ],
      ),
    );
  }
}