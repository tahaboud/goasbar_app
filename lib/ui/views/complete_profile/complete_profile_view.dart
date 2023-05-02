import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
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
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: [
                const Icon(CupertinoIcons.arrow_turn_up_left).height(40)
                    .width(40)
                    .gestures(
                  onTap: () {model.back();},
                ).alignment(Alignment.centerLeft),
                verticalSpaceLarge,
                Text('Profile'.tr(), style: const TextStyle(fontSize: 32),).center(),
                verticalSpaceSmall,
                Text("Quick steps to publish your profile".tr(), style: const TextStyle(color: kMainGray,),).center(),
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
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: model.file != null ? FileImage(model.file!) as ImageProvider
                          : const AssetImage("assets/images/profile_image.png"),
                    ),
                  ),
                ).gestures(onTap: () => model.pickImage()),
                verticalSpaceMedium,
                TextField(
                  controller: firstName,
                  decoration: InputDecoration(
                    hintText: 'Abdeldjalil',
                    hintStyle: const TextStyle(fontSize: 14),
                    // prefixText: 'Saudi Arabia ( +966 ) | ',
                    prefixIcon: Text(' First name '.tr(), style: const TextStyle(color: kMainColor2, fontSize: 14),).padding(vertical: 20, horizontal: 10),
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
                    prefixIcon: Text(' Last name '.tr(), style: const TextStyle(color: kMainColor2, fontSize: 14),).padding(vertical: 20, horizontal: 10),
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
                      hintText: 'Male'.tr(),
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
                    prefixIcon: Text(' Birthday '.tr(), style: TextStyle(color: kMainColor2, fontSize: 14),).padding(vertical: 20, horizontal: 10),
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
                                value: "${c[0]}${c.substring(1).replaceAll('_', ' ').toLowerCase()}",
                                onTap: () {},
                                child: SizedBox(
                                  child: Text("${c[0]}${c.substring(1).replaceAll('_', ' ').toLowerCase()}", style: const TextStyle(fontFamily: 'Cairo'),),
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
                    hintText: 'Re-Password'.tr(),
                    hintStyle: const TextStyle(fontSize: 14),
                    prefixIcon: Text(' Re-Password '.tr(), style: TextStyle(color: kMainColor2, fontSize: 14),).padding(vertical: 20, horizontal: 10),
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
                  child: Text('Continue'.tr(), style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),).center(),
                ).gestures(
                  onTap: firstName.text.isNotEmpty && email.text.isNotEmpty && firstName.text.isNotEmpty
                      && lastName.text.isNotEmpty && password.text.isNotEmpty
                      && rePassword.text.isNotEmpty && model.birthDate.text.isNotEmpty
                      && model.gender.text.isNotEmpty ? () async {

                    Map<String, dynamic> body = {
                      "username": "${firstName.text}_${lastName.text}",
                      "email": email.text,
                      "password": password.text,
                      "first_name": firstName.text,
                      "last_name": lastName.text,
                      "birth_date": model.birthDate.text,
                      "gender": model.gender.text[0],
                      "phone_number": "",
                      "verification_code": "",
                      "city": model.city!.replaceAll(' ', '_').toUpperCase(),
                    };

                    if (model.file != null) {
                      var pickedFile = await MultipartFile.fromFile(
                        model.file!.path,
                        filename: model.file!.path.substring(model.file!.absolute.path.lastIndexOf('/') + 1),
                      );

                      body.addAll({"image": pickedFile,});
                    }

                    model.navigateTo(view: SignUpView(body: body, hasImage: model.hasImage));
                  } : () {},
                ),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => CompleteProfileViewModel(),
    );
  }
}