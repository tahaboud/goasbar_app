import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/complete_profile/complete_profile_view.dart';
import 'package:goasbar/ui/views/faqs/faqs_view.dart';
import 'package:goasbar/ui/views/forget_password/forget_password_view.dart';
import 'package:goasbar/ui/views/home/home_view.dart';
import 'package:goasbar/ui/views/login/login_viewmodel.dart';
import 'package:goasbar/ui/widgets/close_view.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LoginView extends HookWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userName = useTextEditingController();
    var password = useTextEditingController();

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
                  CloseView(onTap: () async => model.navigateTo(view: const HomeView(isUser: false)),),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.transparent,
                      border: Border.all(color: kMainGray),
                    ),
                    child: const Text('FAQs'),
                  ).gestures(onTap: () {
                    model.navigateTo(view: const FAQsView());
                  }),
                ],
              ),
              verticalSpaceLarge,
              Text("sign_in".tr(), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),),
              verticalSpaceMedium,
              Text("login_text".tr(), style: const TextStyle(color: Colors.black, fontSize: 15),),
              verticalSpaceMedium,
              Image.asset("assets/icons/logo.png").center(),
              verticalSpaceMedium,
              Text("Email".tr(), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15),),
              verticalSpaceSmall,
              TextField(
                controller: userName,
                decoration: InputDecoration(
                  hintText: "Email".tr(),
                  hintStyle: const TextStyle(fontSize: 14),
                  prefixIcon: const Icon(Icons.alternate_email_outlined, size: 16, ),
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
              Text("password".tr(), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15),),
              verticalSpaceSmall,
              TextFormField(
                controller: password,
                obscureText: model.isObscure,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => model.validatePassword(value: value),
                decoration: InputDecoration(
                  hintText: 'password'.tr(),
                  hintStyle: const TextStyle(fontSize: 14),
                  prefixIcon: const Icon(Icons.shield_outlined, size: 16, ),
                  suffixIcon: const Icon(Icons.remove_red_eye_outlined, size: 17)
                      .gestures(
                    onTap: () {
                      model.changeObscure();
                    }
                  ),
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
              verticalSpaceRegular,
              Text('Forgot Password?'.tr(), style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),)
                  .alignment(Alignment.centerRight).gestures(onTap: () {
                    model.navigateTo(view: const ForgetPasswordView());
              }),
              verticalSpaceRegular,
              Container(
                width: MediaQuery.of(context).size.width - 60,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  gradient: userName.text.isNotEmpty && password.text.isNotEmpty ? kMainGradient : kMainDisabledGradient,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    const Spacer(),
                    const Spacer(),
                    model.isClicked! ? const Loader().center() : Text('Continue'.tr(), style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),),
                    const Spacer(),
                    const Spacer(),
                    Image.asset("assets/icons/person_login.png",).padding(horizontal: 15),
                  ],
                )
              ).gestures(
                onTap: userName.text.isNotEmpty && password.text.isNotEmpty ? () {
                  model.login(body: {
                    "email": userName.text,
                    "password": password.text,
                  }, context: context).then((value) {
                    model.updateIsClicked(value: false);
                    if (value) {
                      model.clearAndNavigateTo(view: const HomeView(isUser: true));
                    } else {

                    }
                  });
                } : () {},
              ),
              verticalSpaceRegular,
               Text("You didn't have account yet ?".tr(), style: TextStyle(color: Color(0xff647382), fontWeight: FontWeight.w500, fontSize: 15),)
                  .center(),
              verticalSpaceRegular,

              Container(
                  width: MediaQuery.of(context).size.width - 60,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.black,
                    )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      const Spacer(),
                      const Spacer(),
                      Text('Sign Up'.tr(), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),),
                      const Spacer(),
                      const Spacer(),
                      Image.asset("assets/icons/person_signup.png",).padding(horizontal: 15),
                    ],
                  )
              ).gestures(
                onTap: () {
                  model.navigateTo(view: const CompleteProfileView());
                },
              ),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => LoginViewModel(),
    );
  }
}
