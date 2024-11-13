import 'dart:async';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/complete_profile/complete_profile_view.dart';
import 'package:goasbar/ui/views/signup_otp/signup_otp_viewmodel.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:pinput/pinput.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class SignUpOtpView extends HookWidget {
  SignUpOtpView({super.key, this.phone});
  final String? phone;
  Map<String, dynamic> body = {};

  @override
  Widget build(BuildContext context) {
    final codeController = useTextEditingController();
    final remainingSeconds = useState(0);
    final isThrottled = useState(false);
    final timer = useRef<Timer?>(null);
    final pinError = useState<String?>(null);
    final newCodeTimer = useRef<Timer?>(null);
    final remainingNewCodeSeconds = useState(30);
    final canSendNewCode = useState(false);

    useEffect(() {
      return () {
        if (timer.value != null) {
          timer.value?.cancel();
        }
        if (newCodeTimer.value != null) {
          newCodeTimer.value?.cancel();
        }
      };
    }, []);

    useEffect(() {
      if (isThrottled.value) {
        timer.value = Timer.periodic(const Duration(seconds: 1), (timer) {
          remainingSeconds.value--;
          if (remainingSeconds.value == 0) {
            timer.cancel();
            isThrottled.value = false;
          }
        });
      }
      return null;
    }, [isThrottled.value]);

    useEffect(() {
      if (!canSendNewCode.value) {
        newCodeTimer.value =
            Timer.periodic(const Duration(seconds: 1), (timer) {
          remainingNewCodeSeconds.value--;
          if (remainingNewCodeSeconds.value == 0) {
            timer.cancel();
            canSendNewCode.value = true;
          }
        });
      }
      return null;
    }, [canSendNewCode.value]);

    int extractSecondsFromResponse(String response) {
      // Extract the seconds value from the response using regular expressions or other parsing methods
      // Replace with your specific parsing logic
      final match =
          RegExp(r'Expected available in (\d+) seconds').firstMatch(response);
      return match?.group(1) != null ? int.parse(match!.group(1)!) : 0;
    }

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

    handleSendNewCode() {
      final localModel = SignUpOtpViewModel();
      localModel.resendCode(phoneNumber: phone, context: context);
      remainingNewCodeSeconds.value = 30;
      canSendNewCode.value = false;
    }

    String? handleValidatePin(String? value) {
      body["phone_number"] = phone;
      body["verification_code"] = value ?? "";
      final localModel = SignUpOtpViewModel();
      if (!isThrottled.value) {
        localModel
            .checkVerificationCode(body: body, context: context)
            .then((response) {
          if (response == "validOTP") {
            localModel.navigateTo(view: CompleteProfileView(body: body));
          } else if (response.contains("Request was throttled")) {
            final match = RegExp(r'Expected available in (\d+) seconds')
                .firstMatch(response);
            if (match != null) {
              isThrottled.value = true;
              remainingSeconds.value = extractSecondsFromResponse(response);
              pinError.value = "throttled";
            }
          } else if (response == "invalidOTP") {
            pinError.value = "invalid otp";
          } else {
            MotionToast.error(
              title: Text("Internal error has occured".tr()),
              description: Text("Please try again later.".tr()),
              animationCurve: Curves.easeIn,
              animationDuration: const Duration(milliseconds: 1000),
            ).show(context);
          }
        });
      }
      return null;
    }

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
                    IconButton(
                        onPressed: () => model.back(),
                        icon: const Icon(Icons.arrow_back_sharp))
                  ],
                ),
                verticalSpaceMedium,
                Text(
                  "Enter code".tr(),
                  style: const TextStyle(fontSize: 32),
                ),
                verticalSpaceSmall,
                Text(
                  "We sent it to:".tr(),
                  style: const TextStyle(color: kMainGray),
                ),
                Text(
                  "$phone",
                  style: const TextStyle(color: kMainGray),
                  textDirection: TextDirection.ltr,
                ),
                const Spacer(),
                Directionality(
                    textDirection: TextDirection.ltr,
                    child: Pinput(
                      controller: codeController,
                      length: 5,
                      defaultPinTheme: defaultPinTheme,
                      validator: (value) => pinError.value,
                      onCompleted: (value) => handleValidatePin(value),
                      errorBuilder: (errorText, pin) {
                        return errorText == "throttled"
                            ? RichText(
                                text: TextSpan(
                                  text: "Try again after ".tr(),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "${remainingSeconds.value}",
                                      style: const TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    TextSpan(
                                        text: " seconds".tr(),
                                        style: const TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500))
                                  ],
                                  style: const TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ).center()
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  errorText != null ? errorText.tr() : "",
                                  style:
                                      const TextStyle(color: Colors.redAccent),
                                ).center());
                      },
                      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                      errorPinTheme: defaultPinTheme.copyBorderWith(
                        border: Border.all(color: Colors.redAccent),
                      ),
                    )),
                const Spacer(),
                TextButton(
                    onPressed: canSendNewCode.value ? handleSendNewCode : null,
                    child: canSendNewCode.value
                        ? Text("Send new code".tr())
                        : Text(
                            "${'New code in '.tr()}${remainingNewCodeSeconds.value}${' seconds'.tr()}")),
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
