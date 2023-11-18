import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/faqs/faqs_view.dart';
import 'package:goasbar/ui/views/signup/signup_viewmodel.dart';
import 'package:goasbar/ui/views/signup_otp/signup_otp_view.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class SignUpView extends StatefulHookWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  _SignUpView createState() => _SignUpView();
}

class _SignUpView extends State<SignUpView> {
  bool isValid = false;
  TextEditingController phoneNumberController = TextEditingController(text: "");
  String? serverError;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    phoneNumberController.addListener(onPhoneNumberChanged);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    phoneNumberController.dispose();
    super.dispose();
  }

  void onPhoneNumberChanged() {
    isValid = SignUpViewModel().validatePhoneNumber(
            value: phoneNumberController.text.split(" ").join()) ==
        null;
    if (isValid == true) {
      setState(() {});
    }
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
                    const Icon(Icons.arrow_back_sharp)
                        .height(40)
                        .width(40)
                        .gestures(onTap: () {
                      model.back();
                    }),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
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
                    textDirection: TextDirection.ltr,
                    child: TextFormField(
                      maxLength: 11,
                      controller: phoneNumberController,
                      inputFormatters: [
                        MaskTextInputFormatter(mask: "### ### ###")
                      ],
                      keyboardType: TextInputType.phone,
                      validator: (value) => model.validatePhoneNumber(
                          value: value?.split(" ").join()),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        hintText: "123 456 789",
                        counterText: '',
                        hintStyle: const TextStyle(fontSize: 14),
                        // prefixText: 'Saudi Arabia ( +966 ) | ',
                        prefixIcon: const Text(
                          ' ( +966 )  |',
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
                      gradient: isValid ? kMainGradient : kMainDisabledGradient,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        const Spacer(),
                        const Spacer(),
                        model.isClicked!
                            ? const Loader().center()
                            : Text(
                                'Send Verification Code'.tr(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                        const Spacer(),
                        const Spacer(),
                        Image.asset(
                          "assets/icons/person_login.png",
                        ).padding(horizontal: 15),
                      ],
                    )).gestures(
                  onTap: isValid && !model.isClicked!
                      ? () {
                          model
                              .verifyPhoneNumber(
                                  phoneNumber:
                                      "+966${phoneNumberController.text.split(" ").join()}",
                                  context: context)
                              .then((value) {
                            model.updateIsClicked(value: false);
                            if (value) {
                              model.navigateTo(
                                  view: SignUpOtpView(
                                      phone: phoneNumberController.text
                                          .split(" ")
                                          .join()));
                            } else {}
                          });
                        }
                      : null,
                ),
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
