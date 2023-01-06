import 'package:flutter/material.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/faqs/faqs_view.dart';
import 'package:goasbar/ui/views/forget_password/forget_password_view.dart';
import 'package:goasbar/ui/views/guest/guest_view.dart';
import 'package:goasbar/ui/views/login/login_viewmodel.dart';
import 'package:goasbar/ui/views/signup/signup_view.dart';
import 'package:goasbar/ui/widgets/close_view.dart';
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
                  CloseView(onTap: () => model.navigateTo(view: const GuestView(isGuest: true,)),),
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
              const Text("Sign in", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),),
              verticalSpaceMedium,
              const Text("login with your account to start manage \nyour store or get inform about your product", style: TextStyle(color: Colors.black, fontSize: 15),),
              verticalSpaceMedium,
              Image.asset("assets/icons/logo.png").center(),
              verticalSpaceMedium,
              const Text("Email or user name", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15),),
              verticalSpaceSmall,
              TextField(
                controller: userName,
                decoration: InputDecoration(
                  hintText: 'User name or email',
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
              const Text("Password", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15),),
              verticalSpaceSmall,
              TextFormField(
                controller: password,
                obscureText: model.isObscure,
                validator: model.validatePassword(value: password.text),
                decoration: InputDecoration(
                  hintText: 'Password',
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
              const Text('Forgot Password?', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),)
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
                    const Text('Continue', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),),
                    const Spacer(),
                    const Spacer(),
                    Image.asset("assets/icons/person_login.png",).padding(horizontal: 15),
                  ],
                )
              ).gestures(
                onTap: userName.text.isNotEmpty && password.text.isNotEmpty ? () {
                  model.clearAndNavigateTo(view: const GuestView(isGuest: false,));
                } : () {},
              ),
              verticalSpaceRegular,
              const Text("You didn't have account yet ?", style: TextStyle(color: Color(0xff647382), fontWeight: FontWeight.w500, fontSize: 15),)
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
                      const Text('Signup', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),),
                      const Spacer(),
                      const Spacer(),
                      Image.asset("assets/icons/person_signup.png",).padding(horizontal: 15),
                    ],
                  )
              ).gestures(
                onTap: () {
                  model.navigateTo(view: const SignUpView());
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
