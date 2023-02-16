import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/textfield_formatters/iban_formatter.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/shared/textfield_formatters/card_expiration_formatter.dart';
import 'package:goasbar/shared/textfield_formatters/card_number_formatter.dart';

class InfoItem extends StatelessWidget {
  const InfoItem({
    Key? key,
    required this.controller,
    this.label,
    this.hintText,
    this.validator,
  }) : super(key: key);

  final TextEditingController controller;
  final String? label;
  final String? hintText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kTextFiledMainColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          verticalSpaceSmall,
          Row(
            children: [
              horizontalSpaceSmall,
              Text(label!),
            ],
          ),
          SizedBox(
            height: 40,
            child: TextFormField(
              onChanged: (value) {
                if (label == "Expiry Date") {

                }
              },
              inputFormatters: label == "Expiry Date" ? [
                LengthLimitingTextInputFormatter(5),
                CardExpirationFormatter(),
              ] : label == "CVV" ? [
                LengthLimitingTextInputFormatter(3),
              ] : label == "Card Number" ? [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(16),
                CardNumberInputFormatter(),
              ] : label == "IBAN" ? [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(21),
                IbanFormatter(),
              ] : [],
              controller: controller,
              maxLength: label == "Identity number" ? 10 : null,
              keyboardType: label == "Identity number" || label == "IBAN" || label == "Duration (hours)" || label == "Card Number" || label == "Expiry Date" || label == "CVV" || label == "Minimum Age" ? TextInputType.number : TextInputType.text,
              decoration: InputDecoration(
                hintText: hintText!,
                hintStyle: const TextStyle(fontSize: 14),
                fillColor: kTextFiledMainColor,
                filled: true,
                counterText: label == "Identity number" ? "" : null,
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}