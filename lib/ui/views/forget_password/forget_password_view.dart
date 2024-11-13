import 'dart:async';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/forget_password/forget_password_viewmodel.dart';
import 'package:goasbar/ui/views/reset_password/reset_password_view.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class ForgetPasswordView extends HookWidget {
  const ForgetPasswordView({super.key, this.phone});
  final String? phone;

  @override
  Widget build(BuildContext context) {
    final phoneNumber = useState<String>("");
    final phoneNumberError = useState<String?>(null);
    final modelIsLoading = useState<bool>(false);
    final remainingSeconds = useState(0);
    final isThrottled = useState(false);
    final timer = useRef<Timer?>(null);

    useEffect(() {
      return () {
        if (timer.value != null) {
          timer.value?.cancel();
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

    int extractSecondsFromResponse(String response) {
      // Extract the seconds value from the response using regular expressions or other parsing methods
      // Replace with your specific parsing logic
      final match =
          RegExp(r'Expected available in (\d+) seconds').firstMatch(response);
      return match?.group(1) != null ? int.parse(match!.group(1)!) : 0;
    }

    handleRequestResetPassword() {
      phoneNumberError.value = null;
      final localModel = ForgetPasswordViewModel();
      modelIsLoading.value = true;
      localModel
          .forgetPassword(phoneNumber: "+213659578928", context: context)
          .then((value) {
        modelIsLoading.value = false;
        if (value == "request_reset_password_otp_sent") {
          MotionToast.success(
            title: const Text("Request Password Success"),
            description: const Text("Request was sent."),
            animationCurve: Curves.easeIn,
            animationDuration: const Duration(milliseconds: 200),
          ).show(context);
          localModel.navigateTo(
              view: ResetPasswordView(
            phoneNumber: "+966${phoneNumber.value}",
          ));
        } else if (value.contains("Request was throttled")) {
          final match =
              RegExp(r'Expected available in (\d+) seconds').firstMatch(value);
          if (match != null) {
            isThrottled.value = true;
            remainingSeconds.value = extractSecondsFromResponse(value);
          }
        } else {
          phoneNumberError.value = value;
        }
      }).catchError((error) {
        modelIsLoading.value = false;
        MotionToast.error(
          title: Text("Internal error has occured".tr()),
          description: Text("Please try again later.".tr()),
          animationCurve: Curves.easeIn,
          animationDuration: const Duration(milliseconds: 1000),
        ).show(context);
      });
    }

    return ViewModelBuilder<ForgetPasswordViewModel>.reactive(
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
                    IconButton(
                        onPressed: () {
                          model.back();
                        },
                        icon: const Icon(Icons.arrow_back_sharp)
                            .height(40)
                            .width(40)),
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
                      'Forget your\nPassword ?'.tr(),
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
                  onChanged: (value) {
                    phoneNumber.value = value;
                    phoneNumberError.value = null;
                  },
                  keyboardType: TextInputType.phone,
                  validator: (value) => model.validatePhoneNumber(value: value),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textDirection: TextDirection.ltr,
                  maxLength: 9,
                  decoration: InputDecoration(
                    errorText: phoneNumberError.value?.tr(),
                    hintText: 'xx x - xx x - xx x',
                    hintTextDirection: TextDirection.ltr,
                    hintStyle: const TextStyle(fontSize: 14),
                    // prefixText: 'Saudi Arabia ( +966 ) | ',
                    suffixIcon: const Text(
                      ' ( +966 )  |',
                      style: TextStyle(
                        color: kMainGray,
                        fontSize: 14,
                      ),
                      textDirection: TextDirection.ltr,
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
                      gradient:
                          model.validatePhoneNumber(value: phoneNumber.value) ==
                                      null ||
                                  !modelIsLoading.value ||
                                  !isThrottled.value
                              ? kMainGradient
                              : kMainDisabledGradient,
                    ),
                    child: ElevatedButton(
                      onPressed: !modelIsLoading.value || !isThrottled.value
                          ? handleRequestResetPassword
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                      child: isThrottled.value
                          ? RichText(
                              text: TextSpan(
                                text: "Try again after ".tr(),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "${remainingSeconds.value}",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  TextSpan(
                                      text: " seconds".tr(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500))
                                ],
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          : Stack(
                              children: <Widget>[
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Image.asset(
                                      "assets/icons/forget_password.png",
                                    )),
                                Align(
                                    alignment: Alignment.center,
                                    child: modelIsLoading.value
                                        ? const Loader()
                                        : Text(
                                            'Send Verification Code'.tr(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ))
                              ],
                            ),
                    ))
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => ForgetPasswordViewModel(),
    );
  }
}
