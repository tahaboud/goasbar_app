import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/ui/widgets/dot_item.dart';
import 'package:goasbar/ui/widgets/info_item.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:easy_localization/easy_localization.dart';

class GeneralInfo extends StatelessWidget {
  const GeneralInfo({
    Key? key,
    required this.name,
    required this.bio,
    required this.email,
    required this.website,
    required this.phone,
    required this.pageController,
    this.onTapBack,
    this.validateEmail,
    this.validatePhone,
    this.showErrorDialog,
  }) : super(key: key);

  final TextEditingController name;
  final TextEditingController bio;
  final TextEditingController email;
  final TextEditingController website;
  final TextEditingController phone;
  final PageController pageController;
  final Function()? onTapBack;
  final String? Function(String?)? validateEmail;
  final String? Function(String?)? validatePhone;
  final Function? showErrorDialog;

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
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          verticalSpaceSmall,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.close, size: 30,).gestures(onTap: onTapBack),
              horizontalSpaceTiny,
              Text('GENERAL INFORMATION'.tr(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('1 - 3', style: TextStyle(color: kMainColor1, fontSize: 14, fontWeight: FontWeight.bold),).center(),
                  ).width(40)
                      .height(40)
                      .opacity(0.6),
                  Row(
                    children: const [
                      DotItem(condition: true, color: kMainColor1),
                      horizontalSpaceTiny,
                      DotItem(condition: false, color: kMainColor1),
                      horizontalSpaceTiny,
                      DotItem(condition: false, color: kMainColor1),
                    ],
                  ),
                ],
              ),
            ],
          ),
          verticalSpaceMedium,
          const Text('Displayed name', style: TextStyle(fontWeight: FontWeight.bold),),
          verticalSpaceSmall,
          InfoItem(
            controller: name,
            label: 'Full name',
            hintText: 'Abdeldjalil Anes',
          ),
          verticalSpaceRegular,
          InfoItem(
            controller: bio,
            label: 'Bio'.tr(),
            hintText: 'Tell us more about yourself',
          ),
          verticalSpaceRegular,
          const Text('Contact information', style: TextStyle(fontWeight: FontWeight.bold),),
          verticalSpaceSmall,
          Container(
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
                    Text("Email".tr()),
                  ],
                ),
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    validator: validateEmail,
                    controller: email,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'exemple@email.com',
                      hintStyle: TextStyle(fontSize: 14),
                      fillColor: kTextFiledMainColor,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          verticalSpaceRegular,
          InfoItem(
            controller: website,
            label: 'Website',
            hintText: 'www.exemple.com',
          ),
          verticalSpaceRegular,
          Container(
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
                    Text("Phone Number".tr()),
                  ],
                ),
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    validator: validatePhone,
                    controller: phone,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: '+966xxxxxxxxx',
                      hintStyle: TextStyle(fontSize: 14),
                      fillColor: kTextFiledMainColor,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          verticalSpaceMedium,
          Container(
            width: MediaQuery.of(context).size.width - 60,
            height: 50,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              gradient: kMainGradient,
            ),
            child: Center(
              child: Text('NEXT'.tr(), style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500),),
            ),
          ).gestures(
            onTap: () {
              if (name.text.isNotEmpty && bio.text.isNotEmpty && email.text.isNotEmpty && phone.text.isNotEmpty) {
                pageController.jumpToPage(1);
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