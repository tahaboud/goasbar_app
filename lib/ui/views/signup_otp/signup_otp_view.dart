import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/enum/status_code.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/complete_profile/complete_profile_view.dart';
import 'package:goasbar/ui/views/signup_otp/signup_otp_viewmodel.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:pinput/pinput.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class SignUpOtpView extends HookWidget {
  SignUpOtpView({Key? key, this.phone}) : super(key: key);
  final String? phone;
  Map<String, dynamic> body = {};

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
                    const Icon(Icons.arrow_back_sharp)
                        .height(40)
                        .width(40)
                        .gestures(onTap: () {
                      model.back();
                    }),
                  ],
                ),
                verticalSpaceMedium,
                Text(
                  "Enter code".tr(),
                  style: const TextStyle(fontSize: 32),
                ),
                verticalSpaceSmall,
                Text(
                  '${"We sent it to:".tr()} \n +966$phone',
                  style: const TextStyle(color: kMainGray),
                ),
                const Spacer(),
                Directionality(
                    textDirection: TextDirection.ltr,
                    child: Pinput(
                      controller: codeController,
                      length: 5,
                      defaultPinTheme: defaultPinTheme,
                      onCompleted: (code) {
                        if (codeController.text.length == 5) {
                          body["phone_number"] = "+966$phone";
                          body["verification_code"] = code;

                          model
                              .checkVerificationCode(
                                  body: body, context: context)
                              .then((value) {
                            if (value == StatusCode.throttled) {
                              MotionToast.error(
                                title: const Text("Register Failed"),
                                description:
                                    const Text("Request was throttled."),
                                animationCurve: Curves.easeIn,
                                animationDuration:
                                    const Duration(milliseconds: 200),
                              ).show(context);
                            } else if (value == StatusCode.other) {
                            } else {
                              model.navigateTo(
                                  view: CompleteProfileView(body: body));
                            }
                          });
                        }
                      },
                    )),
                const Spacer(),
                Text(
                  'New code ${model.startStr}',
                  style: TextStyle(
                      color: model.start == 90 ? Colors.black : kMainGray),
                ).gestures(onTap: () {
                  model.resendCode(phoneNumber: "+966$phone", context: context);
                }),
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
