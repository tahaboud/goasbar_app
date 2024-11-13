import 'dart:async';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/signup/signup_viewmodel.dart';
import 'package:goasbar/ui/views/signup_otp/signup_otp_view.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class SignUpView extends StatefulHookWidget {
  const SignUpView({super.key});

  @override
  _SignUpView createState() => _SignUpView();
}

class _SignUpView extends State<SignUpView> {
  bool isValid = false;
  TextEditingController phoneNumberController = TextEditingController(text: "");
  String? serverError;
  bool isLoading = false;
  bool isThrottled = false;
  String? phoneNumberError;
  int remainingSeconds = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    phoneNumberController.addListener(onPhoneNumberChanged);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    phoneNumberController.dispose();
    if (timer != null) {
      timer?.cancel();
    }
    super.dispose();
  }

  void onTimerChanged() {
    if (isThrottled) {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          remainingSeconds--;
          if (remainingSeconds == 0) {
            timer.cancel();
            isThrottled = false;
          }
        });
      });
    }
  }

  void onPhoneNumberChanged() {
    isValid = SignUpViewModel().validatePhoneNumber(
            value: phoneNumberController.text.split(" ").join()) ==
        null;
    if (isValid == true) {
      setState(() {
        isValid = true;
      });
    }
  }

  int extractSecondsFromResponse(String response) {
    // Extract the seconds value from the response using regular expressions or other parsing methods
    // Replace with your specific parsing logic
    final match =
        RegExp(r'Expected available in (\d+) seconds').firstMatch(response);
    return match?.group(1) != null ? int.parse(match!.group(1)!) : 0;
  }

  handleRegister() {
    final localModel = SignUpViewModel();
    setState(() {
      isLoading = true;
    });
    localModel
        .verifyPhoneNumber(phoneNumber: "+213659578928", context: context)
        .then((value) {
      setState(() {
        isLoading = false;
      });
      if (value == "OTP sent") {
        localModel.navigateTo(view: SignUpOtpView(phone: "+213659578928"));
      } else if (value.contains("Request was throttled")) {
        final match =
            RegExp(r'Expected available in (\d+) seconds').firstMatch(value);
        if (match != null) {
          setState(() {
            isThrottled = true;
            remainingSeconds = extractSecondsFromResponse(value);
          });
          onTimerChanged();
        }
      } else {
        setState(() {
          phoneNumberError = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignUpViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              children: [
                verticalSpaceMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () => model.back(),
                        icon: const Icon(Icons.arrow_back_sharp))
                  ],
                ),
                verticalSpaceRegular,
                Image.asset("assets/images/signup_img.png", height: 230),
                verticalSpaceRegular,
                Text(
                  "New \nAccount ?".tr(),
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
                verticalSpaceSmall,
                Text(
                  "Find your best experience in Saudi Arabia with GoAsbar".tr(),
                  style: const TextStyle(color: kMainGray, fontSize: 13),
                ).center(),
                verticalSpaceTiny,
                Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      maxLength: 11,
                      textDirection: TextDirection.ltr,
                      controller: phoneNumberController,
                      inputFormatters: [
                        MaskTextInputFormatter(mask: "### ### ###")
                      ],
                      keyboardType: TextInputType.phone,
                      validator: (value) => model.validatePhoneNumber(
                          value: value?.split(" ").join()),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        errorText: phoneNumberError,
                        hintText: "123 456 789",
                        hintTextDirection: TextDirection.ltr,
                        counterText: '',
                        hintStyle: const TextStyle(fontSize: 14),
                        suffixIcon: const Text(
                          ' ( +966 )  |',
                          textDirection: TextDirection.ltr,
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
                    )),
                verticalSpaceMedium,
                Container(
                    width: MediaQuery.of(context).size.width - 60,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      gradient: isValid && !isThrottled && !isLoading
                          ? kMainGradient
                          : kMainDisabledGradient,
                    ),
                    child: ElevatedButton(
                      onPressed: isValid && !isThrottled && !isLoading
                          ? handleRegister
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                      child: isLoading
                          ? const Loader().center()
                          : !isThrottled
                              ? Stack(
                                  children: <Widget>[
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Image.asset(
                                          "assets/icons/person_login.png",
                                        )),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Send Verification Code'.tr(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )
                                  ],
                                )
                              : RichText(
                                  text: TextSpan(
                                    text: "Try again after ".tr(),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "$remainingSeconds",
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
                                ),
                    )),
                verticalSpaceRegular,
              ],
            ),
          ),
        );
      },
      viewModelBuilder: () => SignUpViewModel(),
    );
  }
}
