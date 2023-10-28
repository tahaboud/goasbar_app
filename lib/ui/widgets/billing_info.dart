import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/widgets/dot_item.dart';
import 'package:goasbar/ui/widgets/info_item.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:goasbar/ui/widgets/previous_button.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:styled_widget/styled_widget.dart';

class BillingInfo extends StatelessWidget {
  const BillingInfo({
    Key? key,
    required this.twitter,
    required this.instagram,
    required this.facebook,
    required this.bankName,
    required this.bankAccountNumber,
    required this.iban,
    this.onTapBack,
    this.showErrorDialog,
    this.onTapSubmit,
    this.isClicked,
    required this.pageController,
  }) : super(key: key);

  final TextEditingController twitter;
  final PageController pageController;
  final TextEditingController instagram;
  final TextEditingController facebook;
  final TextEditingController bankName;
  final TextEditingController bankAccountNumber;
  final TextEditingController iban;
  final Function()? onTapBack;
  final Function? showErrorDialog;
  final Function()? onTapSubmit;
  final bool? isClicked;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: screenHeightPercentage(context, percentage: 0.85),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
        color: Colors.white,
      ),
      child: ListView(
        children: [
          verticalSpaceSmall,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.close,
                size: 30,
              ).gestures(onTap: onTapBack),
              horizontalSpaceTiny,
              const Text('BILLING INFORMATION',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      '3 - 3',
                      style: TextStyle(
                          color: kMainColor1,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ).center(),
                  ).width(40).height(40).opacity(0.6),
                  const Row(
                    children: [
                      DotItem(condition: false, color: kMainColor1),
                      horizontalSpaceTiny,
                      DotItem(condition: false, color: kMainColor1),
                      horizontalSpaceTiny,
                      DotItem(condition: true, color: kMainColor1),
                    ],
                  ),
                ],
              ),
            ],
          ),
          verticalSpaceMedium,
          const Text(
            'SOCIAL MEDIA',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          verticalSpaceSmall,
          InfoItem(
            controller: twitter,
            label: 'Twitter',
            hintText: 'www.twitter.com/account',
          ),
          verticalSpaceRegular,
          InfoItem(
            controller: instagram,
            label: 'Instagram',
            hintText: 'www.instagram.com/account',
          ),
          verticalSpaceRegular,
          InfoItem(
            controller: facebook,
            label: 'Facebook',
            hintText: 'www.facebook.com/account',
          ),
          verticalSpaceRegular,
          const Text(
            'Bank information',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          verticalSpaceSmall,
          InfoItem(
            controller: bankName,
            label: 'Bank name',
            hintText: 'Eastybay',
          ),
          verticalSpaceRegular,
          InfoItem(
            controller: bankAccountNumber,
            label: 'Bank account number',
            hintText: '******* xxx - xxxx - xxxxx',
          ),
          verticalSpaceRegular,
          InfoItem(
            controller: iban,
            label: 'IBAN',
            hintText: 'SA xxxx xxxx - xxxx - xxxxx',
          ),
          verticalSpaceMedium,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PreviousButton(onTap: () => pageController.jumpToPage(1)),
              Container(
                width: screenWidthPercentage(context, percentage: 0.4),
                height: 50,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  gradient: kMainGradient,
                ),
                child: isClicked!
                    ? const Loader().center()
                    : Center(
                        child: Text(
                          'SUBMIT'.tr(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
              ).gestures(
                onTap: () {
                  if (bankName.text.isNotEmpty &&
                      bankAccountNumber.text.isNotEmpty &&
                      iban.text.isNotEmpty) {
                    if (iban.text.replaceAll(' ', '').length != 23) {
                      MotionToast.warning(
                        title: const Text("Incorrect IBAN Format"),
                        description:
                            const Text("IBAN must be 23 digits length."),
                        animationCurve: Curves.easeIn,
                        animationDuration: const Duration(milliseconds: 200),
                      ).show(context);
                    } else {
                      onTapSubmit!();
                    }
                  } else {
                    showErrorDialog!();
                  }
                },
              ),
            ],
          ),
          verticalSpaceRegular,
        ],
      ),
    );
  }
}
