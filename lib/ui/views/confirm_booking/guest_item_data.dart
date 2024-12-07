import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/confirm_booking/confirm_booking_viewmodel.dart';
import 'package:styled_widget/styled_widget.dart';

class GuestItemData extends HookWidget {
  const GuestItemData({super.key, required this.model, required this.index});

  final ConfirmBookingViewModel model;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        verticalSpaceSmall,
        Text(
          "${'Guest'.tr()} ${index + 1}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        verticalSpaceSmall,
        TextField(
          controller: model.firstNames[index],
          decoration: InputDecoration(
            hintText: 'Guest First Name'.tr(),
            hintStyle: const TextStyle(fontSize: 14),
            // prefixText: 'Saudi Arabia ( +966 ) | ',
            fillColor: kTextFiledGrayColor,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: kTextFiledGrayColor),
            ),
          ),
        ),
        verticalSpaceRegular,
        TextField(
          controller: model.lastNames[index],
          decoration: InputDecoration(
            hintText: 'Guest Last Name'.tr(),
            hintStyle: const TextStyle(fontSize: 14),
            // prefixText: 'Saudi Arabia ( +966 ) | ',
            fillColor: kTextFiledGrayColor,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: kTextFiledGrayColor),
            ),
          ),
        ),
        verticalSpaceRegular,
        TextFormField(
          keyboardType: TextInputType.number,
          controller: model.age[index],
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) => model.validateIsNumeric(value: value),
          decoration: InputDecoration(
            hintText: 'Guest Age'.tr(),
            hintStyle: const TextStyle(fontSize: 14),
            fillColor: kTextFiledGrayColor,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: kTextFiledGrayColor),
            ),
          ),
        ),
        verticalSpaceRegular,
        SizedBox(
            height: 60,
            child: DropdownButtonHideUnderline(
              child: DropdownButtonFormField<String>(
                  value: model.genders[index].text,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  decoration: InputDecoration(
                    hintText: "",
                    fillColor: kTextFiledGrayColor,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: Colors.black),
                  onChanged: (String? value) {
                    model.genders[index].text = value ?? "";
                  },
                  items: [
                    DropdownMenuItem<String>(
                      value: "",
                      enabled: false,
                      child: Text(
                        'Guest Gender'.tr(),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                    DropdownMenuItem<String>(
                      value: "M",
                      child: Text("Male".tr()),
                    ),
                    DropdownMenuItem<String>(
                      value: "F",
                      child: Text("Female".tr()),
                    ),
                  ]),
            )),
        verticalSpaceRegular,
        TextFormField(
          controller: model.phones[index],
          validator: (value) => model.validatePhoneNumber(value: value),
          textDirection: TextDirection.ltr,
          keyboardType: TextInputType.number,
          maxLength: 9,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            hintText: 'xx x - xx x - xx x',
            hintTextDirection: TextDirection.ltr,
            hintStyle: const TextStyle(
              fontSize: 14,
            ),
            counterText: '',
            // prefixText: 'Saudi Arabia ( +966 ) | ',
            suffixIcon: const Text(
              '( +966 ) |',
              style: TextStyle(color: kMainGray, fontSize: 14),
              textDirection: TextDirection.ltr,
            ).padding(vertical: 20, horizontal: 10),
            fillColor: kTextFiledGrayColor,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: kTextFiledGrayColor),
            ),
          ),
        ),
        verticalSpaceRegular,
      ],
    );
  }
}
