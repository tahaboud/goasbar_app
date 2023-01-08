import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/ui/widgets/dot_item.dart';
import 'package:goasbar/ui/widgets/info_item.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/shared/ui_helpers.dart';

class BillingInfo extends StatelessWidget {
  const BillingInfo({
    Key? key,
    required this.twitter,
    required this.instagram,
    required this.facebook,
    required this.bankEbay,
    required this.bankAccountNumber,
    required this.iban,
    this.onTapBack,
    this.showErrorDialog,
    this.onTapSubmit,
  }) : super(key: key);

  final TextEditingController twitter;
  final TextEditingController instagram;
  final TextEditingController facebook;
  final TextEditingController bankEbay;
  final TextEditingController bankAccountNumber;
  final TextEditingController iban;
  final Function()? onTapBack;
  final Function? showErrorDialog;
  final Function? onTapSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: screenHeightPercentage(context, percentage: 0.85),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18),),
        color: Colors.white,
      ),
      child: ListView(
        children: [
          verticalSpaceSmall,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.close, size: 30,).gestures(onTap: onTapBack),
              horizontalSpaceTiny,
              const Text('BILLING INFORMATION', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('3 - 3', style: TextStyle(color: kMainColor1, fontSize: 14, fontWeight: FontWeight.bold),).center(),
                  ).width(40)
                      .height(40)
                      .opacity(0.6),
                  Row(
                    children: const [
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
          const Text('SOCIAL MEDIA', style: TextStyle(fontWeight: FontWeight.bold),),
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
          const Text('Bank information', style: TextStyle(fontWeight: FontWeight.bold),),
          verticalSpaceSmall,
          InfoItem(
            controller: bankEbay,
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
            hintText: '******* xxx - xxxx - xxxxx',
          ),
          verticalSpaceMedium,
          Container(
            width: MediaQuery.of(context).size.width - 60,
            height: 50,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              gradient: kMainGradient,
            ),
            child: const Center(
              child: Text('SUBMIT', style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500),),
            ),
          ).gestures(
            onTap: () {
              if (twitter.text.isNotEmpty && instagram.text.isNotEmpty && facebook.text.isNotEmpty && bankEbay.text.isNotEmpty && bankAccountNumber.text.isNotEmpty && iban.text.isNotEmpty) {
                onTapSubmit!();
              } else {
                showErrorDialog!();
              }
            },
          ),
          verticalSpaceRegular,
        ],
      ),
    );
  }
}