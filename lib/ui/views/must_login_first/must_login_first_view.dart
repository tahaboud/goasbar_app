import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/complete_profile/complete_profile_view.dart';
import 'package:goasbar/ui/views/login/login_view.dart';
import 'package:goasbar/ui/views/must_login_first/must_login_first_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class MustLoginFirstView extends HookWidget {
  const MustLoginFirstView({Key? key, this.text}) : super(key: key);
  final String? text;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MustLoginFirstViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        bottomNavigationBar: const BottomAppBar(),
        body: SafeArea(
            child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpaceMedium,
                Text(
                  text!,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                verticalSpaceMedium,
                const Text(
                  'You must login first',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                verticalSpaceRegular,
                const Text(
                    'When you are ready to take your experience,\njoin us and create your account',
                    style: TextStyle(color: kMainGray)),
                verticalSpaceLarge,
                Container(
                  height: 50,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gradient: kMainGradient,
                  ),
                  child: Center(
                    child: Text(
                      'sign_in'.tr(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ).gestures(
                  onTap: () {
                    model.navigateTo(view: const LoginView());
                  },
                ),
                verticalSpaceMedium,
                Image.asset("assets/images/login_first.png"),
                verticalSpaceLarge,
                const Text("You don't have an account yet?",
                        style: TextStyle(color: kMainGray))
                    .center(),
                verticalSpaceRegular,
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.black),
                  ),
                  child: const Center(
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ).gestures(
                  onTap: () {
                    model.navigateTo(view: const CompleteProfileView());
                  },
                ),
              ],
            ),
          ),
        )),
      ),
      viewModelBuilder: () => MustLoginFirstViewModel(),
    );
  }
}
