import 'package:flutter/material.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/complete_profile/complete_profile_view.dart';
import 'package:goasbar/ui/views/signup_otp/signup_otp_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pinput/pinput.dart';

class SignUpOtpView extends HookWidget {
  const SignUpOtpView({Key? key, this.phone}) : super(key: key);
  final String? phone;

  @override
  Widget build(BuildContext context) {
    final codeController = useTextEditingController();
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: const TextStyle(
        fontSize: 32,
      ),
      decoration: BoxDecoration(
        color: kMainDisabledGray,
        borderRadius: BorderRadius.circular(10),
      ),
    );


    return ViewModelBuilder<SignUpOtpViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                verticalSpaceMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.arrow_back_sharp).height(40)
                        .width(40)
                        .gestures(
                        onTap: () {
                          model.back();
                        }
                    ),
                  ],
                ),
                verticalSpaceMedium,
                const Text("Enter code", style: TextStyle(fontSize: 32),),
                verticalSpaceSmall,
                Text('We sent it to +966 $phone', style: const TextStyle(color: kMainGray),),
                const Spacer(),
                Pinput(
                  controller: codeController,
                  length: 4,
                  defaultPinTheme: defaultPinTheme,
                  onCompleted: (code) {
                    if (codeController.text.length == 4) {
                      model.navigateTo(view: const CompleteProfileView());
                    }
                  },
                  onSubmitted: (code) {
                    if (codeController.text.length == 4) {
                      model.navigateTo(view: const CompleteProfileView());
                    }
                  },
                ),
                const Spacer(),
                const Text('New code 1:24', style: TextStyle(color: kMainGray),),
                verticalSpaceMedium,
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => SignUpOtpViewModel(),
    );
  }
}
