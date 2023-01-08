import 'package:flutter/material.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/forget_password/forget_password_viewmodel.dart';
import 'package:goasbar/ui/views/reset_password/reset_password_view.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ForgetPasswordView extends HookWidget {
  const ForgetPasswordView({Key? key, this.phone}) : super(key: key);
  final String? phone;

  @override
  Widget build(BuildContext context) {
    final userName = useTextEditingController();

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
                SizedBox(
                  height: 220,
                  child: Image.asset("assets/images/forget_password.png"),
                ),
                verticalSpaceMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text('Forget \nPassword ?', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                  ],
                ),
                verticalSpaceMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      "Don't worry ! it happens , please entre the address \nassociated with your account",
                      style: TextStyle(fontSize: 14, color: kMainGray),
                    ),
                  ],
                ),
                verticalSpaceMedium,
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
                verticalSpaceLarge,
                Container(
                    width: MediaQuery.of(context).size.width - 30,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      gradient: userName.text.isNotEmpty ? kMainGradient : kMainDisabledGradient,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        const Spacer(),
                        const Spacer(),
                        const Text('Send Verification Code', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),),
                        const Spacer(),
                        const Spacer(),
                        Image.asset("assets/icons/forget_password.png",).padding(horizontal: 15),
                      ],
                    )
                ).gestures(
                  onTap: userName.text.isNotEmpty ? () {
                    model.navigateTo(view: const ResetPasswordView());
                  } : () {},
                ),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => ForgetPasswordViewModel(),
    );
  }
}
