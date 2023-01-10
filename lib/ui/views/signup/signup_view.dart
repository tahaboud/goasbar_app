import 'package:flutter/material.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/faqs/faqs_view.dart';
import 'package:goasbar/ui/views/signup/signup_viewmodel.dart';
import 'package:goasbar/ui/views/signup_otp/signup_otp_view.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SignUpView extends HookWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var phone = useTextEditingController();

    return ViewModelBuilder<SignUpViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            children: [
              verticalSpaceMedium,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.arrow_back_sharp).height(40)
                      .width(40)
                      .gestures(
                    onTap: () {
                      model.back();
                    }
                  ),
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
              verticalSpaceRegular,
              Image.asset("assets/images/signup_img.png", height: 300),
              verticalSpaceRegular,
              const Text("New \nAccount ?", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30),),
              verticalSpaceSmall,
              const Text("Find your best experience in Saudi Arabia with GoAsbar", style: TextStyle(color: kMainGray, fontSize: 13),)
                  .center(),
              verticalSpaceTiny,
              TextFormField(
                controller: phone,
                validator: (value) => model.validatePhoneNumber(value: value),
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  hintText: 'xx x - xx x - xx x',
                  hintStyle: const TextStyle(fontSize: 14),
                  // prefixText: 'Saudi Arabia ( +966 ) | ',
                  prefixIcon: const Text('Saudi Arabia ( +966 )  |', style: TextStyle(color: kMainGray, fontSize: 14),).padding(vertical: 20, horizontal: 10),
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

              Container(
                width: MediaQuery.of(context).size.width - 60,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  gradient: phone.text.isNotEmpty ? kMainGradient : kMainDisabledGradient,
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
                    Image.asset("assets/icons/person_login.png",).padding(horizontal: 15),
                  ],
                )
              ).gestures(
                onTap: phone.text.isNotEmpty ? () {
                  model.navigateTo(view: SignUpOtpView(phone: phone.text,));
                } : () {},
              ),
              verticalSpaceRegular,
              const Text("Already have an account ?", style: TextStyle(color: Color(0xff647382), fontWeight: FontWeight.w500, fontSize: 15),)
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
                      const Text('Go Back To Sign In', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),),
                      const Spacer(),
                      const Spacer(),
                      Image.asset("assets/icons/person_signup.png",).padding(horizontal: 15),
                    ],
                  )
              ).gestures(
                onTap: () {
                  model.back();
                },
              ),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => SignUpViewModel(),
    );
  }
}
