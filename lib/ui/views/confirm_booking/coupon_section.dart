import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/confirm_booking/confirm_booking_viewmodel.dart';

class CouponSection extends HookWidget {
  const CouponSection({super.key, required this.model, required this.coupon});

  final ConfirmBookingViewModel model;
  final TextEditingController coupon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            horizontalSpaceSmall,
            Text(
              'Trip Coupon'.tr(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: screenWidthPercentage(context, percentage: 0.3),
              height: 40,
              child: TextField(
                controller: coupon,
                decoration: InputDecoration(
                  hintText: 'trips 05',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                  ),
                  fillColor: Colors.transparent,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: kTextFiledGrayColor),
                  ),
                ),
              ),
            ),
            horizontalSpaceSmall,
          ],
        ),
      ],
    );
  }
}
