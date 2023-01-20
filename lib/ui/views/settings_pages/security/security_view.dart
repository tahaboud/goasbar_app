import 'package:flutter/material.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/settings_pages/security/security_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/cupertino.dart';

class SecurityView extends HookWidget {
  const SecurityView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final password = useTextEditingController();
    final newPassword = useTextEditingController();

    return ViewModelBuilder<SecurityViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: SizedBox(
              height: 650,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(CupertinoIcons.arrow_turn_up_left).height(40)
                          .width(40)
                          .gestures(
                          onTap: () {
                            model.back();
                          }
                      ),
                      const Text('Security Information', style: TextStyle(fontSize: 21),),
                    ],
                  ),
                  verticalSpaceMedium,
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            horizontalSpaceSmall,
                            Image.asset("assets/icons/forget_password.png", color: Colors.grey,),
                            horizontalSpaceTiny,
                            const Text("Password", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          ],
                        ),
                        verticalSpaceRegular,
                        Row(
                          children: const [
                            horizontalSpaceSmall,
                            Text("Current password")
                          ],
                        ),
                        verticalSpaceSmall,
                        TextFormField(
                          controller: password,
                          validator: (value) => model.validatePassword(value: value),
                          obscureText: model.isObscure,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            hintText: 'Current Password',
                            hintStyle: const TextStyle(fontSize: 14),
                            suffixIcon: const Icon(Icons.remove_red_eye_outlined, size: 17)
                                .gestures(
                                onTap: () {
                                  model.changeObscure();
                                }
                            ),
                            fillColor: kTextFiledMainColor,
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
                        Row(
                          children: const [
                            horizontalSpaceSmall,
                            Text("New password")
                          ],
                        ),
                        verticalSpaceSmall,
                        TextFormField(
                          controller: newPassword,
                          validator: (value) => model.validatePassword(value: value),
                          obscureText: model.isObscure,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            hintText: 'New Password',
                            hintStyle: const TextStyle(fontSize: 14),
                            suffixIcon: const Icon(Icons.remove_red_eye_outlined, size: 17)
                                .gestures(
                                onTap: () {
                                  model.changeObscure();
                                }
                            ),
                            fillColor: kTextFiledMainColor,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: kTextFiledGrayColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                      width: MediaQuery.of(context).size.width - 30,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        gradient: password.text.isNotEmpty && newPassword.text.isNotEmpty ? kMainGradient : kMainDisabledGradient,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          const Spacer(),
                          const Spacer(),
                          const Text('Update Your Password', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),),
                          const Spacer(),
                          const Spacer(),
                          Image.asset("assets/icons/forget_password.png",).padding(horizontal: 15),
                        ],
                      )
                  ).gestures(
                    onTap: password.text.isNotEmpty && newPassword.text.isNotEmpty ? () {
                      model.back();
                    } : () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      viewModelBuilder: () => SecurityViewModel(),
    );
  }
}
