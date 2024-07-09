import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goasbar/enum/status_code.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/complete_profile/complete_profile_viewmodel.dart';
import 'package:goasbar/ui/views/home/home_view.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class CompleteProfileView extends StatefulWidget {
  CompleteProfileView({
    super.key,
    required this.body,
  });
  Map<String, dynamic> body;

  @override
  State<CompleteProfileView> createState() => _CompleteProfileView();
}

class _CompleteProfileView extends State<CompleteProfileView> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController cityController =
      TextEditingController(text: "Select your city".tr());
  File? profile_picture;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool firstNameIsValid = false;
  bool lastNameIsValid = false;
  bool emailIsValid = false;
  bool passwordIsValid = false;
  bool rePasswordIsValid = false;
  bool genderIsValid = false;
  bool dateIsValid = false;
  bool cityIsValid = false;

  bool formIsValid = false;

  bool isLoading = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    genderController.dispose();
    dateController.dispose();
    cityController.dispose();
    super.dispose();
  }

  void _onFirstNameChanged() {
    firstNameIsValid = CompleteProfileViewModel()
            .validateFirstName(value: firstNameController.text) ==
        null;
    bool oldFormIsValid = formIsValid;
    formIsValid = firstNameIsValid &&
        lastNameIsValid &&
        emailIsValid &&
        passwordIsValid &&
        rePasswordIsValid &&
        genderIsValid &&
        dateIsValid &&
        cityIsValid;
    if (oldFormIsValid != formIsValid) {
      setState(() {});
    }
  }

  void _onLastNameChanged() {
    lastNameIsValid = CompleteProfileViewModel()
            .validateLastName(value: lastNameController.text) ==
        null;
    bool oldFormIsValid = formIsValid;
    formIsValid = firstNameIsValid &&
        lastNameIsValid &&
        emailIsValid &&
        passwordIsValid &&
        rePasswordIsValid &&
        genderIsValid &&
        dateIsValid &&
        cityIsValid;
    if (oldFormIsValid != formIsValid) {
      setState(() {});
    }
  }

  void _onEmailChanged() {
    emailIsValid =
        CompleteProfileViewModel().validateEmail(value: emailController.text) ==
            null;
    bool oldFormIsValid = formIsValid;
    formIsValid = firstNameIsValid &&
        lastNameIsValid &&
        emailIsValid &&
        passwordIsValid &&
        rePasswordIsValid &&
        genderIsValid &&
        dateIsValid &&
        cityIsValid;
    if (oldFormIsValid != formIsValid) {
      setState(() {});
    }
  }

  void _onPasswordChanged() {
    passwordIsValid = CompleteProfileViewModel()
            .validatePassword(value: passwordController.text) ==
        null;
    bool oldFormIsValid = formIsValid;
    formIsValid = firstNameIsValid &&
        lastNameIsValid &&
        emailIsValid &&
        passwordIsValid &&
        rePasswordIsValid &&
        genderIsValid &&
        dateIsValid &&
        cityIsValid;
    if (oldFormIsValid != formIsValid) {
      setState(() {});
    }
  }

  void _onRePasswordChanged() {
    rePasswordIsValid = CompleteProfileViewModel().validateRePassword(
            password: passwordController.text,
            rePassword: rePasswordController.text) ==
        null;
    bool oldFormIsValid = formIsValid;
    formIsValid = firstNameIsValid &&
        lastNameIsValid &&
        emailIsValid &&
        passwordIsValid &&
        rePasswordIsValid &&
        genderIsValid &&
        dateIsValid &&
        cityIsValid;
    if (oldFormIsValid != formIsValid) {
      setState(() {});
    }
  }

  void _onGenderChanged() {
    genderIsValid = genderController.text == "Male".tr() ||
        genderController.text == "Female".tr();
    bool oldFormIsValid = formIsValid;
    formIsValid = firstNameIsValid &&
        lastNameIsValid &&
        emailIsValid &&
        passwordIsValid &&
        rePasswordIsValid &&
        genderIsValid &&
        dateIsValid &&
        cityIsValid;
    if (oldFormIsValid != formIsValid) {
      setState(() {});
    }
  }

  void _onDateChanged() {
    dateIsValid = dateController.text != "";
    bool oldFormIsValid = formIsValid;
    formIsValid = firstNameIsValid &&
        lastNameIsValid &&
        emailIsValid &&
        passwordIsValid &&
        rePasswordIsValid &&
        genderIsValid &&
        dateIsValid &&
        cityIsValid;
    if (oldFormIsValid != formIsValid) {
      setState(() {});
    }
  }

  void _onCityChanged() {
    cityIsValid = cities.contains(cityController.text);
    bool oldFormIsValid = formIsValid;
    formIsValid = firstNameIsValid &&
        lastNameIsValid &&
        emailIsValid &&
        passwordIsValid &&
        rePasswordIsValid &&
        genderIsValid &&
        dateIsValid &&
        cityIsValid;
    if (oldFormIsValid != formIsValid) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    firstNameController.addListener(_onFirstNameChanged);
    lastNameController.addListener(_onLastNameChanged);
    emailController.addListener(_onEmailChanged);
    passwordController.addListener(_onPasswordChanged);
    rePasswordController.addListener(_onRePasswordChanged);
    genderController.addListener(_onGenderChanged);
    cityController.addListener(_onCityChanged);
    dateController.addListener(_onDateChanged);
  }

  void onSubmit() async {
    setState(() {
      isLoading = true;
    });
    widget.body["username"] =
        "${firstNameController.text}_${lastNameController.text}";
    widget.body["email"] = emailController.text;
    widget.body["password"] = passwordController.text;
    widget.body["first_name"] = firstNameController.text;
    widget.body["last_name"] = lastNameController.text;
    widget.body["birth_date"] = dateController.text;
    widget.body["gender"] = genderMap[genderController.text];
    widget.body["city"] = citiesMap[cityController.text];
    if (profile_picture != null) {
      var pickedFile = await MultipartFile.fromFile(
        profile_picture!.path,
        filename: profile_picture!.path
            .substring(profile_picture!.absolute.path.lastIndexOf('/') + 1),
      );

      widget.body.addAll({
        "image": pickedFile,
      });
    }
    CompleteProfileViewModel()
        .register(
            body: widget.body,
            context: context,
            hasImage: profile_picture != null)
        .then((value) => {
              if (value == StatusCode.throttled)
                {
                  MotionToast.error(
                    title: const Text("Register Failed"),
                    description: const Text("Request was throttled."),
                    animationCurve: Curves.easeIn,
                    animationDuration: const Duration(milliseconds: 200),
                  ).show(context),
                  setState(() {
                    isLoading = false;
                  })
                }
              else if (value == StatusCode.other)
                {
                  setState(() {
                    isLoading = false;
                  })
                }
              else
                {
                  CompleteProfileViewModel().navigateTo(
                      view: const HomeView(
                    isUser: true,
                  ))
                }
            });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CompleteProfileViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: [
                const Icon(CupertinoIcons.arrow_turn_up_left)
                    .height(40)
                    .width(40)
                    .gestures(
                  onTap: () {
                    model.back();
                  },
                ).alignment(Alignment.centerLeft),
                verticalSpaceLarge,
                Text(
                  'Complete your profile'.tr(),
                  style: const TextStyle(fontSize: 32),
                ).center(),
                verticalSpaceSmall,
                Text(
                  "Quick steps to publish your profile".tr(),
                  style: const TextStyle(
                    color: kMainGray,
                  ),
                ).center(),
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
                      fit: BoxFit.contain,
                      image: profile_picture != null
                          ? FileImage(profile_picture as File) as ImageProvider
                          : const AssetImage("assets/images/profile_image.png"),
                    ),
                  ),
                ).gestures(onTap: () {
                  model.pickImage().then((value) => profile_picture = value);
                }),
                verticalSpaceMedium,
                TextFormField(
                  controller: firstNameController,
                  validator: (value) => model.validateFirstName(value: value),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: "first name".tr(),
                    hintStyle: const TextStyle(fontSize: 14),
                    // prefixText: 'Saudi Arabia ( +966 ) | ',
                    prefixIcon: Text(
                      ' First name '.tr(),
                      style: const TextStyle(color: kMainColor2, fontSize: 14),
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
                ),
                verticalSpaceMedium,
                TextFormField(
                  controller: lastNameController,
                  validator: (value) => model.validateLastName(value: value),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: "last name".tr(),
                    hintStyle: const TextStyle(fontSize: 14),
                    // prefixText: 'Saudi Arabia ( +966 ) | ',
                    prefixIcon: Text(
                      ' Last name '.tr(),
                      style: const TextStyle(color: kMainColor2, fontSize: 14),
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
                ),
                verticalSpaceMedium,
                SizedBox(
                  height: 60,
                  child: TextField(
                    readOnly: true,
                    controller: genderController,
                    onTap: () {
                      model
                          .showSelectionDialog(gen: genderController.text)
                          .then((value) => {
                                genderController.text = value,
                                _onGenderChanged()
                              });
                    },
                    decoration: InputDecoration(
                      hintText: 'Select your gender'.tr(),
                      hintStyle: const TextStyle(fontSize: 14),
                      suffixIcon: Image.asset('assets/icons/drop_down.png'),
                      prefixIcon: Text(
                        ' Gender '.tr(),
                        style:
                            const TextStyle(color: kMainColor2, fontSize: 14),
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
                  ),
                ),
                verticalSpaceMedium,
                TextField(
                  readOnly: true,
                  onTap: () {
                    model.showBirthDayPicker(context).then((value) =>
                        {dateController.text = value, _onDateChanged()});
                  },
                  controller: dateController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(8),
                    _DateInputFormatter(),
                  ],
                  decoration: InputDecoration(
                    hintText: '2000-12-31',
                    hintStyle: const TextStyle(fontSize: 14),
                    suffixIcon: Image.asset('assets/icons/birth_date.png'),
                    prefixIcon: Text(
                      ' Date of birth '.tr(),
                      style: const TextStyle(color: kMainColor2, fontSize: 14),
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
                      Text(
                        ' City '.tr(),
                        style:
                            const TextStyle(color: kMainColor2, fontSize: 14),
                      ).padding(vertical: 20, horizontal: 10),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton<String>(
                                  value: cityController.text,
                                  iconSize: 24,
                                  icon: (null),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                  onChanged: (value) => {
                                        if (value != null)
                                          {
                                            setState(() {
                                              cityController.text = value;
                                            })
                                          },
                                      },
                                  items: cities.map(
                                    (e) {
                                      return DropdownMenuItem(
                                        value: e,
                                        enabled: e != "Select your city".tr(),
                                        child: Text(e),
                                      );
                                    },
                                  ).toList())),
                        ),
                      ),
                    ],
                  ),
                ),
                verticalSpaceMedium,
                TextFormField(
                  controller: emailController,
                  validator: (value) => model.validateEmail(value: value),
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: 'email@email.com',
                    hintStyle: const TextStyle(fontSize: 14),
                    prefixIcon: Text(
                      ' Email '.tr(),
                      style: const TextStyle(color: kMainColor2, fontSize: 14),
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
                ),
                verticalSpaceMedium,
                TextFormField(
                  controller: passwordController,
                  validator: (value) => model.validatePassword(value: value),
                  obscureText: model.isObscure,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: 'Password'.tr(),
                    hintStyle: const TextStyle(fontSize: 14),
                    prefixIcon: Text(
                      ' Password '.tr(),
                      style: const TextStyle(color: kMainColor2, fontSize: 14),
                    ).padding(vertical: 20, horizontal: 10),
                    suffixIcon:
                        const Icon(Icons.remove_red_eye_outlined, size: 17)
                            .gestures(onTap: () {
                      model.changeObscure();
                    }),
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
                  key: _formKey,
                  controller: rePasswordController,
                  validator: (value) => model.validateRePassword(
                      password: passwordController.text, rePassword: value),
                  obscureText: model.isObscure,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: 'Re-Password'.tr(),
                    hintStyle: const TextStyle(fontSize: 14),
                    prefixIcon: Text(
                      ' Re-Password '.tr(),
                      style: const TextStyle(color: kMainColor2, fontSize: 14),
                    ).padding(vertical: 20, horizontal: 10),
                    suffixIcon:
                        const Icon(Icons.remove_red_eye_outlined, size: 17)
                            .gestures(onTap: () {
                      model.changeObscure();
                    }),
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
                    gradient:
                        formIsValid ? kMainGradient : kMainDisabledGradient,
                  ),
                  child: isLoading
                      ? const Loader().center()
                      : Text(
                          'Continue'.tr(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ).center(),
                ).gestures(
                  onTap: formIsValid && !isLoading ? onSubmit : null,
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

class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Implement custom formatting logic here
    // For example, format as "YYYYMMDD"
    if (newValue.text.length > 4 && newValue.text.contains(RegExp(r'\d{4}'))) {
      return TextEditingValue(
        text:
            '${newValue.text.substring(0, 4)}-${newValue.text.substring(4, 6)}-${newValue.text.substring(6)}',
        selection: TextSelection.collapsed(offset: newValue.selection.end + 2),
      );
    }
    return newValue;
  }
}
