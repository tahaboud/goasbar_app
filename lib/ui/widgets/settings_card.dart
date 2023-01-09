import 'package:flutter/material.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/widgets/settings_card_item.dart';

class SettingsCard extends StatelessWidget {
  const SettingsCard({
    Key? key,
    this.item1Image,
    this.item1Parameter,
    this.item1Title,
    this.item2Image,
    this.item2Parameter,
    this.item2Title,
    this.onTapParameter,
    this.onTapPaymentParameter,
    this.isUser,
  }) : super(key: key);
  final String? item1Image;
  final String? item1Title;
  final String? item1Parameter;
  final String? item2Image;
  final String? item2Title;
  final String? item2Parameter;
  final Function()? onTapParameter;
  final Function()? onTapPaymentParameter;
  final bool? isUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 0,
            offset: Offset(0, 1),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          isUser! ? SettingsCardItem(image: "wallet", title: "Add payment method", parameter: "Add more", onTapParameter: onTapPaymentParameter,) : Container(),
          isUser! ? verticalSpaceRegular : Container(),
          SettingsCardItem(image: item1Image, title: item1Title, parameter: item1Parameter, onTapParameter: onTapParameter),
          verticalSpaceRegular,
          SettingsCardItem(image: item2Image, title: item2Title, parameter: item2Parameter),
        ],
      ),
    );
  }
}