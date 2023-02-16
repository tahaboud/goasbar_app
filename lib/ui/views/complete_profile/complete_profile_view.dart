import 'package:flutter/material.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/complete_profile/complete_profile_viewmodel.dart';
import 'package:goasbar/ui/views/signup/signup_view.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CompleteProfileView extends HookWidget {
  const CompleteProfileView({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var firstName = useTextEditingController();
    var lastName = useTextEditingController();
    var email = useTextEditingController();
    final password = useTextEditingController();
    final rePassword = useTextEditingController();

    return ViewModelBuilder<CompleteProfileViewModel>.reactive(
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  verticalSpaceLarge,
                  const Text('Profile', style: TextStyle(fontSize: 32),).center(),
                  verticalSpaceSmall,
                  const Text("Quick steps to publish your profile", style: TextStyle(color: kMainGray,),).center(),
                  verticalSpaceMedium,
                  Container(
                    height: 130,
                    width: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: kMainDisabledGray,
                        width: 5,
                      ),
                      image: const DecorationImage(
                        image: AssetImage("assets/images/profile_image.png"),
                      )
                    ),
                    // child: Image.asset("assets/images/profile_image.png"),
                  ),
                  verticalSpaceMedium,
                  TextField(
                    controller: firstName,
                    decoration: InputDecoration(
                      hintText: 'Abdeldjalil',
                      hintStyle: const TextStyle(fontSize: 14),
                      // prefixText: 'Saudi Arabia ( +966 ) | ',
                      prefixIcon: const Text(' First name ', style: TextStyle(color: kMainColor2, fontSize: 14),).padding(vertical: 20, horizontal: 10),
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
                  TextField(
                    controller: lastName,
                    decoration: InputDecoration(
                      hintText: 'Anas',
                      hintStyle: const TextStyle(fontSize: 14),
                      // prefixText: 'Saudi Arabia ( +966 ) | ',
                      prefixIcon: const Text(' Last name ', style: TextStyle(color: kMainColor2, fontSize: 14),).padding(vertical: 20, horizontal: 10),
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
                  SizedBox(
                    height: 60,
                    child: TextField(
                      readOnly: true,
                      controller: model.gender,
                      decoration: InputDecoration(
                        hintText: 'Male',
                        hintStyle: const TextStyle(fontSize: 14),
                        suffixIcon: Image.asset('assets/icons/drop_down.png')
                            .gestures(onTap: () {
                          model.showSelectionDialog(gen: model.gender.text);
                        }),
                        prefixIcon: const Text(' Gender ', style: TextStyle(color: kMainColor2, fontSize: 14),).padding(vertical: 20, horizontal: 10),
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
                  ),
                  verticalSpaceMedium,
                  TextField(
                    readOnly: true,
                    controller: model.birthDate,
                    decoration: InputDecoration(
                      hintText: '25 . 10 1998',
                      hintStyle: const TextStyle(fontSize: 14),
                      suffixIcon: Image.asset('assets/icons/birth_date.png')
                          .gestures(onTap: () {
                          model.showBirthDayPicker(context);
                      }),
                      prefixIcon: const Text(' Birthday ', style: TextStyle(color: kMainColor2, fontSize: 14),).padding(vertical: 20, horizontal: 10),
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
                    height: 60,
                    width: screenWidthPercentage(context, percentage: 1),
                    decoration: BoxDecoration(
                      color: kTextFiledGrayColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        const Text(' City ', style: TextStyle(color: kMainColor2, fontSize: 14),).padding(vertical: 20, horizontal: 10),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton<String>(
                                value: model.city,
                                iconSize: 24,
                                icon: (null),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                onChanged: (value) => model.updateCity(value: value),
                                items: cities.map((c) => DropdownMenuItem(
                                  value: c,
                                  onTap: () {},
                                  child: SizedBox(
                                    child: Text(c, style: const TextStyle(fontFamily: 'Cairo'),),
                                  ),
                                )).toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  verticalSpaceMedium,
                  TextFormField(
                    controller: email,
                    validator: (value) => model.validateEmail(value: value),
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      hintText: 'anas.yahya42@gmail.com',
                      hintStyle: const TextStyle(fontSize: 14),
                      prefixIcon: const Text(' Email ', style: TextStyle(color: kMainColor2, fontSize: 14),).padding(vertical: 20, horizontal: 10),
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
                  TextFormField(
                    controller: password,
                    validator: (value) => model.validatePassword(value: value),
                    obscureText: model.isObscure,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: const TextStyle(fontSize: 14),
                      prefixIcon: const Text(' Password ', style: TextStyle(color: kMainColor2, fontSize: 14),).padding(vertical: 20, horizontal: 10),
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
                  verticalSpaceMedium,
                  TextFormField(
                    controller: rePassword,
                    validator: (value) => model.validateRePassword(password: password.text, rePassword: value),
                    obscureText: model.isObscure,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      hintText: 'Re-Password',
                      hintStyle: const TextStyle(fontSize: 14),
                      prefixIcon: const Text(' Re-Password ', style: TextStyle(color: kMainColor2, fontSize: 14),).padding(vertical: 20, horizontal: 10),
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
                  verticalSpaceMedium,
                  Container(
                    width: MediaQuery.of(context).size.width - 30,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      gradient: firstName.text.isNotEmpty && email.text.isNotEmpty && firstName.text.isNotEmpty
                          && lastName.text.isNotEmpty && password.text.isNotEmpty
                          && rePassword.text.isNotEmpty && model.birthDate.text.isNotEmpty
                          && model.gender.text.isNotEmpty ? kMainGradient : kMainDisabledGradient,
                    ),
                    child: const Text('Continue', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),).center(),
                  ).gestures(
                    onTap: firstName.text.isNotEmpty && email.text.isNotEmpty && firstName.text.isNotEmpty
                        && lastName.text.isNotEmpty && password.text.isNotEmpty
                        && rePassword.text.isNotEmpty && model.birthDate.text.isNotEmpty
                        && model.gender.text.isNotEmpty ? () async {
                      Map body = {
                        "username": "${firstName.text}_${lastName.text}",
                        "email": email.text,
                        "password": password.text,
                        "first_name": firstName.text,
                        "last_name": lastName.text,
                        "birth_date": model.birthDate.text,
                        "gender": model.gender.text[0],
                        "phone_number": "",
                        "verification_code": "",
                        "city": model.city,
                      };
                      model.navigateTo(view: SignUpView(body: body,));
                    } : () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      viewModelBuilder: () => CompleteProfileViewModel(),
    );
  }
}
