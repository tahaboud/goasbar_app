import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/forget_password/forget_password_view.dart';
import 'package:goasbar/ui/views/home/home_view.dart';
import 'package:goasbar/ui/views/login/login_viewmodel.dart';
import 'package:goasbar/ui/views/signup/signup_view.dart';
import 'package:goasbar/ui/widgets/close_view.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class LoginView extends HookWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    var email = useTextEditingController();
    var password = useTextEditingController();
    final emailError = useState<String?>(null);
    final passwordError = useState<String?>(null);
    final remainingSeconds = useState(0);
    final isThrottled = useState(false);
    final timer = useRef<Timer?>(null);
    var body = {"phone_number": "+213659578928", "verification_code": "23887"};

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

    bool emailValidator(String? value) {
      if (value == null ||
          !RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z0-9]+$")
              .hasMatch(value)) {
        emailError.value = "Invalid email".tr();
        return false;
      }
      return true;
    }

    handleLogin(dynamic Function(bool value) updateIsClicked) {
      final localModel = LoginViewModel();
      if (emailValidator(email.text)) {
        localModel.login(body: {
          "email": email.text,
          "password": password.text,
        }, context: context).then((value) {
          if (value == "login success") {
            localModel.clearAndNavigateTo(view: const HomeView(isUser: true));
          } else if (value.contains("Request was throttled")) {
            final match = RegExp(r'Expected available in (\d+) seconds')
                .firstMatch(value);
            if (match != null) {
              isThrottled.value = true;
              remainingSeconds.value = extractSecondsFromResponse(value);
            }
          } else {
            emailError.value = value.tr();
            passwordError.value = value.tr();
          }
        });
      }
    }

    return ViewModelBuilder<LoginViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            children: [
              verticalSpaceMedium,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CloseView(
                    onTap: () async =>
                        model.navigateTo(view: const HomeView(isUser: false)),
                  ),
                  // Container(
                  //   padding:
                  //       const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(5),
                  //     color: Colors.transparent,
                  //     border: Border.all(color: kMainGray),
                  //   ),
                  //   child: const Text('FAQs'),
                  // ).gestures(onTap: () {
                  //   model.navigateTo(view: const FAQsView());
                  // }),
                ],
              ),
              verticalSpaceLarge,
              Text(
                "sign_in".tr(),
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
              verticalSpaceMedium,
              Text(
                "login_text".tr(),
                style: const TextStyle(color: Colors.black, fontSize: 15),
              ),
              verticalSpaceMedium,
              Image.asset("assets/icons/logo.png").center(),
              verticalSpaceMedium,
              Text(
                "Email".tr(),
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
              verticalSpaceSmall,
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: email,
                onChanged: (text) {
                  emailError.value = null;
                  passwordError.value = null;
                  model.changedEmail(text);
                },
                decoration: InputDecoration(
                    hintText: "Email".tr(),
                    hintStyle: const TextStyle(fontSize: 14),
                    prefixIcon: const Icon(
                      Icons.alternate_email_outlined,
                      size: 16,
                    ),
                    fillColor: kTextFiledGrayColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: kTextFiledGrayColor),
                    ),
                    errorText: emailError.value),
              ),
              verticalSpaceMedium,
              Text(
                "password".tr(),
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
              verticalSpaceSmall,
              TextFormField(
                controller: password,
                obscureText: model.isObscure,
                onChanged: (text) {
                  emailError.value = null;
                  passwordError.value = null;
                  model.changedPass(text);
                },
                decoration: InputDecoration(
                    hintText: 'password'.tr(),
                    hintStyle: const TextStyle(fontSize: 14),
                    prefixIcon: const Icon(
                      Icons.shield_outlined,
                      size: 16,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                          model.isObscure
                              ? Icons.visibility_off_outlined
                              : Icons.remove_red_eye_outlined,
                          size: 17),
                      onPressed: () {
                        model.changeObscure();
                      },
                    ),
                    fillColor: kTextFiledGrayColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: kTextFiledGrayColor),
                    ),
                    errorText: passwordError.value),
              ),
              verticalSpaceRegular,
              Text(
                'Forgot Password?'.tr(),
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    decoration: TextDecoration.underline),
              ).alignment(Alignment.centerRight).gestures(onTap: () {
                model.navigateTo(view: const ForgetPasswordView());
              }),
              verticalSpaceRegular,
              Container(
                width: MediaQuery.of(context).size.width - 60,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  gradient: model.email!.isNotEmpty &&
                          model.password!.isNotEmpty &&
                          !isThrottled.value
                      ? kMainGradient
                      : kMainDisabledGradient,
                ),
                child: ElevatedButton(
                  onPressed: model.email!.isNotEmpty &&
                          model.password!.isNotEmpty &&
                          !isThrottled.value
                      ? () {
                          handleLogin(model.updateIsClicked);
                        }
                      : () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  child: model.isClicked!
                      ? const Loader().center()
                      : !isThrottled.value
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
                                    'Continue'.tr(),
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
                            ),
                ),
              ),
              verticalSpaceRegular,
              Container(
                width: MediaQuery.of(context).size.width - 60,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.black,
                    )),
                child: ElevatedButton(
                    onPressed: () {
                      model.navigateTo(view: const SignUpView());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    child: model.isClicked!
                        ? const Loader().center()
                        : Stack(
                            children: <Widget>[
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Image.asset(
                                    "assets/icons/person_signup.png",
                                  )),
                              Align(
                                alignment: Alignment.center,
                                child: Text('Sign Up'.tr(),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    )),
                              )
                            ],
                          )),
              ),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => LoginViewModel(),
    );
  }
}
