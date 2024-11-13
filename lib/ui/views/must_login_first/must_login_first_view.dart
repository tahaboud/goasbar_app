import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/login/login_view.dart';
import 'package:goasbar/ui/views/must_login_first/must_login_first_viewmodel.dart';
import 'package:goasbar/ui/views/signup/signup_view.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class MustLoginFirstView extends HookWidget {
  const MustLoginFirstView({super.key, this.text});
  final String? text;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MustLoginFirstViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
          body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              verticalSpaceMedium,
              Text(
                text!,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              verticalSpaceMedium,
              Text(
                'You must login first'.tr(),
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
              verticalSpaceRegular,
              Text(
                  'When you are ready to take your experience,\njoin us and create your account'
                      .tr(),
                  style: const TextStyle(color: kMainGray)),
              verticalSpaceLarge,
              Container(
                  height: 50,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gradient: kMainGradient,
                  ),
                  child: ElevatedButton(
                    onPressed: () => model.navigateTo(view: const LoginView()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      minimumSize: Size.infinite,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    child: Text("sign_in".tr(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                  )),
              verticalSpaceMedium,
              Image.asset("assets/images/login_first.png"),
              verticalSpaceLarge,
              Text("You don't have an account yet?".tr(),
                      style: const TextStyle(color: kMainGray))
                  .center(),
              verticalSpaceRegular,
              Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.black),
                  ),
                  child: ElevatedButton(
                    onPressed: () => model.navigateTo(view: const SignUpView()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      minimumSize: Size.infinite,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    child: Text(
                      'Sign Up'.tr(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  )),
            ],
          ),
        ),
      )),
      viewModelBuilder: () => MustLoginFirstViewModel(),
    );
  }
}
