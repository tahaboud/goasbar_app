import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/request_reset/request_password_viewmodel.dart';
import 'package:goasbar/ui/views/settings_pages/security/security_view.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class RequestPasswordView extends HookWidget {
  const RequestPasswordView({super.key, this.phone});
  final String? phone;

  @override
  Widget build(BuildContext context) {
    final phoneNumber = useTextEditingController();

    return ViewModelBuilder<RequestPasswordViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(CupertinoIcons.arrow_turn_up_left)
                        .height(40)
                        .width(40)
                        .gestures(
                      onTap: () {
                        model.back();
                      },
                    ),
                    Text(
                      'Security Information'.tr(),
                      style: const TextStyle(fontSize: 21),
                    ),
                  ],
                ),
                verticalSpaceMedium,
                SizedBox(
                  height: 220,
                  child: Image.asset("assets/images/forget_password.png"),
                ),
                verticalSpaceMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Forget your Password ?'.tr(),
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                verticalSpaceMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Dont worry".tr(),
                      style: const TextStyle(fontSize: 14, color: kMainGray),
                    ),
                  ],
                ),
                verticalSpaceMedium,
                TextFormField(
                  controller: phoneNumber,
                  validator: (value) => model.validatePhoneNumber(value: value),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: 'xx x - xx x - xx x',
                    hintStyle: const TextStyle(fontSize: 14),
                    // prefixText: 'Saudi Arabia ( +966 ) | ',
                    prefixIcon: const Text(
                      ' ( +966 )  |',
                      style: TextStyle(color: kMainGray, fontSize: 14),
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
                verticalSpaceLarge,
                Container(
                    width: MediaQuery.of(context).size.width - 30,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      gradient: phoneNumber.text.isNotEmpty
                          ? kMainGradient
                          : kMainDisabledGradient,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        const Spacer(),
                        const Spacer(),
                        Text(
                          'Send Verification Code'.tr(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        const Spacer(),
                        Image.asset(
                          "assets/icons/forget_password.png",
                        ).padding(horizontal: 15),
                      ],
                    )).gestures(
                  onTap: phoneNumber.text.isNotEmpty
                      ? () {
                          model
                              .forgetPassword(
                                  context: context,
                                  phoneNumber: "+966${phoneNumber.text}")
                              .then((value) {
                            model.navigateTo(
                                view: SecurityView(
                              phoneNumber: "+966${phoneNumber.text}",
                            ));
                          });
                        }
                      : () {},
                ),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => RequestPasswordViewModel(),
    );
  }
}
