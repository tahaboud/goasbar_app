import 'package:flutter/material.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/login/login_view.dart';
import 'package:goasbar/ui/views/must_login_first/must_login_first_viewmodel.dart';
import 'package:goasbar/ui/views/signup/signup_view.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
                  Text(text!, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                  verticalSpaceMedium,
                  const Text('You must to login first', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),),
                  verticalSpaceRegular,
                  const Text('When you be ready for take your experience \nJoin with us and create your account', style: TextStyle(color: kMainGray)),
                  verticalSpaceLarge,
                  Container(
                    width: MediaQuery.of(context).size.width - 60,
                    height: 50,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      gradient: kMainGradient,
                    ),
                    child: const Center(
                      child: Text('Sign In', style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500),),
                    ),
                  ).gestures(
                    onTap: () {
                      model.navigateTo(view: const LoginView());
                    },
                  ),
                  verticalSpaceMedium,
                  Image.asset("assets/images/login_first.png"),
                  verticalSpaceLarge,
                  const Text("You didn't have account yet ?", style: TextStyle(color: kMainGray)).center(),
                  verticalSpaceRegular,
                  Container(
                    width: MediaQuery.of(context).size.width - 60,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Colors.black),
                    ),
                    child: const Center(
                      child: Text('Sign Up', style: TextStyle(color: Colors.black, fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500),),
                    ),
                  ).gestures(
                    onTap: () {
                      model.navigateTo(view: const SignUpView());
                    },
                  ),
                ],
              ),
            ),
          )
        ),
      ),
      viewModelBuilder: () => MustLoginFirstViewModel(),
    );
  }
}