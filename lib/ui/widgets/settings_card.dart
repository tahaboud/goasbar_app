import 'package:flutter/material.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/widgets/settings_card_item.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:easy_localization/easy_localization.dart';

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
    this.additionalParameterOnTap,
    this.onItem1Tap,
    this.onItem2Tap,
    this.isUser,
  }) : super(key: key);
  final String? item1Image;
  final String? item1Title;
  final String? item1Parameter;
  final String? item2Image;
  final String? item2Title;
  final String? item2Parameter;
  final Function()? onTapParameter;
  final Function()? onItem1Tap;
  final Function()? onItem2Tap;
  final Function()? additionalParameterOnTap;
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
          isUser! ? SettingsCardItem(image: "wallet", title: "Add a payment method".tr(), parameter: "Add more".tr(), onTapParameter: additionalParameterOnTap,) : Container(),
          isUser! ? verticalSpaceRegular : Container(),
          !isUser! ? Container() : item1Image == "hosted" ? const SettingsCardItem(image: "hosted", title: "Bookings History", parameter: "",).gestures(onTap: additionalParameterOnTap) : Container(),
          !isUser! ? Container() : item1Image == "hosted" ? verticalSpaceRegular : Container(),
          SettingsCardItem(image: item1Image, title: item1Title, parameter: item1Parameter, onTapParameter: onTapParameter).gestures(onTap: onItem1Tap),
          verticalSpaceRegular,
          SettingsCardItem(image: item2Image, title: item2Title, parameter: item2Parameter).gestures(onTap: onItem2Tap),
        ],
      ),
    );
  }
}