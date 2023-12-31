import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/reset_password/reset_password_viewmodel.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class ResetPasswordView extends HookWidget {
  const ResetPasswordView({Key? key, this.phoneNumber}) : super(key: key);
  final String? phoneNumber;

  @override
  Widget build(BuildContext context) {
    final password = useTextEditingController();
    final rePassword = useTextEditingController();
    final code = useTextEditingController();

    return ViewModelBuilder<ResetPasswordViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                verticalSpaceMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.arrow_back_sharp)
                        .height(40)
                        .width(40)
                        .gestures(onTap: () {
                      model.back();
                    }),
                  ],
                ),
                verticalSpaceMedium,
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    "assets/images/forget_password.png",
                  ),
                ),
                verticalSpaceMedium,
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Reset \nPassword ?',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                verticalSpaceMedium,
                TextFormField(
                  controller: password,
                  validator: (value) => model.validatePassword(value: value),
                  obscureText: model.isObscure,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: const TextStyle(fontSize: 14),
                    prefixIcon: const Icon(
                      Icons.shield_outlined,
                      size: 16,
                    ),
                    suffixIcon:
                        const Icon(Icons.remove_red_eye_outlined, size: 17)
                            .gestures(onTap: () {
                      model.changeObscure();
                    }),
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
                verticalSpaceSmall,
                TextFormField(
                  controller: rePassword,
                  validator: (value) => model.validateRePassword(
                      password: password.text, rePassword: value),
                  obscureText: model.isObscure,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: 'Re-Password'.tr(),
                    hintStyle: const TextStyle(fontSize: 14),
                    prefixIcon: const Icon(
                      Icons.shield_outlined,
                      size: 16,
                    ),
                    suffixIcon:
                        const Icon(Icons.remove_red_eye_outlined, size: 17)
                            .gestures(onTap: () {
                      model.changeObscure();
                    }),
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
                verticalSpaceMedium,
                const Row(
                  children: [horizontalSpaceSmall, Text("Code")],
                ),
                verticalSpaceSmall,
                TextField(
                  controller: code,
                  maxLength: 5,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Code',
                    hintStyle: const TextStyle(fontSize: 14),
                    fillColor: kTextFiledMainColor,
                    filled: true,
                    counterText: "",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: kTextFiledGrayColor),
                    ),
                  ),
                ),
                verticalSpaceMedium,
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'B+',
                          style: TextStyle(
                              color: Color(0xff339999),
                              fontWeight: FontWeight.bold),
                        ),
                        verticalSpaceTiny,
                        Text(
                          'Character',
                          style: TextStyle(fontSize: 8),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Aa',
                          style: TextStyle(
                              color: Color(0xff3D3D3D),
                              fontWeight: FontWeight.bold),
                        ),
                        verticalSpaceTiny,
                        Text(
                          'Capital Letter',
                          style: TextStyle(fontSize: 8),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Aa',
                          style: TextStyle(
                              color: Color(0xff339999),
                              fontWeight: FontWeight.bold),
                        ),
                        verticalSpaceTiny,
                        Text(
                          'Small Letter',
                          style: TextStyle(fontSize: 8),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '123',
                          style: TextStyle(
                              color: Color(0xff65BCFF),
                              fontWeight: FontWeight.bold),
                        ),
                        verticalSpaceTiny,
                        Text(
                          'Numbers',
                          style: TextStyle(fontSize: 8),
                        )
                      ],
                    ),
                  ],
                ),
                verticalSpaceMedium,
                Container(
                    width: MediaQuery.of(context).size.width - 30,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      gradient:
                          password.text.isNotEmpty && rePassword.text.isNotEmpty
                              ? kMainGradient
                              : kMainDisabledGradient,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        const Spacer(),
                        const Spacer(),
                        const Text(
                          'Reset Your Password',
                          style: TextStyle(
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
                  onTap: password.text.isNotEmpty && rePassword.text.isNotEmpty
                      ? () {
                          if (code.text.length == 5) {
                            model
                                .resetPassword(
                                    context: context,
                                    phoneNumber: phoneNumber,
                                    code: code.text,
                                    password: password.text)
                                .then((value) {
                              if (value!) {
                                model.back();
                                model.back();
                              } else {}
                            });
                          } else {
                            MotionToast.warning(
                              title: const Text("Warning"),
                              description:
                                  const Text("Code must be 5 numbers!!"),
                              animationCurve: Curves.easeIn,
                              animationDuration:
                                  const Duration(milliseconds: 200),
                            ).show(context);
                          }
                        }
                      : () {},
                ),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => ResetPasswordViewModel(),
    );
  }
}
