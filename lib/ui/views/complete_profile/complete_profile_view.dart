import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      TextEditingController(text: "Select your city");
  File? profilePicture;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool isThrottled = false;
  int remainingSeconds = 0;
  Timer? timer;

  String? firstNameError;
  String? lastNameError;
  String? genderError;
  String? birthDateError;
  String? cityError;
  String? emailError;
  String? passwordError;
  String? rePasswordError;

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
    if (timer != null) {
      timer?.cancel();
    }
    super.dispose();
  }

  void onTimerChanged() {
    if (isThrottled) {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          remainingSeconds--;
          if (remainingSeconds == 0) {
            timer.cancel();
            isThrottled = false;
          }
        });
      });
    }
  }

  int extractSecondsFromResponse(String response) {
    // Extract the seconds value from the response using regular expressions or other parsing methods
    // Replace with your specific parsing logic
    final match =
        RegExp(r'Expected available in (\d+) seconds').firstMatch(response);
    return match?.group(1) != null ? int.parse(match!.group(1)!) : 0;
  }

  bool validateForm() {
    CompleteProfileViewModel model = CompleteProfileViewModel();
    firstNameError = model.validateFirstName(value: firstNameController.text);
    lastNameError = model.validateLastName(value: lastNameController.text);
    emailError = model.validateEmail(value: emailController.text);
    passwordError = model.validatePassword(value: passwordController.text);
    rePasswordError = model.validateRePassword(
        password: passwordController.text,
        rePassword: rePasswordController.text);
    if (!["M", "F"].contains(genderController.text)) {
      genderError = "This field is required.";
    }
    if (dateController.text.isEmpty) {
      birthDateError = "This field is required.";
    }
    if (cityController.text == "Select your city") {
      cityError = "This field is required.";
    }
    if (firstNameError == null &&
        lastNameError == null &&
        emailError == null &&
        passwordError == null &&
        rePasswordError == null &&
        genderError == null &&
        birthDateError == null &&
        cityError == null) {
      return true;
    } else {
      setState(() {});
      return false;
    }
  }

  void onSubmit() async {
    bool isValid = validateForm();
    if (isValid) {
      widget.body["email"] = emailController.text;
      widget.body["password"] = passwordController.text;
      widget.body["first_name"] = firstNameController.text;
      widget.body["last_name"] = lastNameController.text;
      widget.body["birth_date"] = dateController.text;
      widget.body["gender"] = genderController.text;
      widget.body["city"] = cityController.text;
      if (profilePicture != null) {
        var pickedFile = await MultipartFile.fromFile(
          profilePicture!.path,
          filename: profilePicture!.path
              .substring(profilePicture!.absolute.path.lastIndexOf('/') + 1),
        );

        widget.body.addAll({
          "image": pickedFile,
        });
      }
      CompleteProfileViewModel()
          .register(body: widget.body, hasImage: profilePicture != null)
          .then((value) {
        if (value == "success") {
          CompleteProfileViewModel().navigateTo(
              view: const HomeView(
            isUser: true,
          ));
        } else if (value.contains("Request was throttled")) {
          final match =
              RegExp(r'Expected available in (\d+) seconds').firstMatch(value);
          if (match != null) {
            setState(() {
              isThrottled = true;
              remainingSeconds = extractSecondsFromResponse(value);
              isLoading = false;
            });
            onTimerChanged();
          }
        } else if (value == "User with this email address already exists.") {
          setState(() {
            isLoading = false;
            emailError = "email_already_in_use".tr();
          });
        } else if (value == "internal_error") {
          setState(() {
            isLoading = false;
          });
          MotionToast.error(
            title: Text("Internal error has occured".tr()),
            description: Text("Please try again later.".tr()),
            animationCurve: Curves.easeIn,
            animationDuration: const Duration(milliseconds: 1000),
          ).show(context);
        }
      });
    }
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: model.back,
                        icon: const Icon(CupertinoIcons.arrow_turn_up_right)),
                    Text(
                      'Complete your profile'.tr(),
                      style: const TextStyle(fontSize: 20),
                    )
                  ],
                ),
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
                      image: profilePicture != null
                          ? FileImage(profilePicture as File) as ImageProvider
                          : const AssetImage("assets/images/profile_image.png"),
                    ),
                  ),
                ).gestures(onTap: () {
                  model.pickImage().then((value) {
                    setState(() {
                      profilePicture = value;
                    });
                  });
                }),
                verticalSpaceMedium,
                TextFormField(
                  controller: firstNameController,
                  validator: (value) => model.validateFirstName(value: value),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (value) => setState(() => firstNameError = null),
                  maxLength: 150,
                  decoration: InputDecoration(
                    prefixIcon: Text(
                      ' First name '.tr(),
                      style: const TextStyle(color: kMainColor2, fontSize: 14),
                    ).padding(vertical: 20, horizontal: 10),
                    fillColor: kTextFiledGrayColor,
                    filled: true,
                    errorText: firstNameError?.tr(),
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
                  onChanged: (value) => setState(() => lastNameError = null),
                  maxLength: 150,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    prefixIcon: Text(
                      ' Last name '.tr(),
                      style: const TextStyle(color: kMainColor2, fontSize: 14),
                    ).padding(vertical: 20, horizontal: 10),
                    fillColor: kTextFiledGrayColor,
                    errorText: lastNameError?.tr(),
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
                    decoration: BoxDecoration(
                        color: kTextFiledGrayColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField<String>(
                          value: genderController.text,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: InputDecoration(
                              hintText: "",
                              border: InputBorder.none,
                              errorText: genderError?.tr(),
                              prefixIcon: Text(
                                ' Gender '.tr(),
                                style: const TextStyle(
                                  color: kMainColor2,
                                  fontSize: 14,
                                ),
                              ).padding(
                                vertical: 10,
                              )),
                          style: const TextStyle(color: Colors.black),
                          onChanged: (String? value) {
                            setState(() {
                              genderController.text = value!;
                              genderError = null;
                            });
                          },
                          items: [
                            DropdownMenuItem<String>(
                              value: "",
                              enabled: false,
                              child: Text(
                                'Select your gender'.tr(),
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "M",
                              child: Text("Male".tr()),
                            ),
                            DropdownMenuItem<String>(
                              value: "F",
                              child: Text("Female".tr()),
                            ),
                          ]),
                    )),
                verticalSpaceMedium,
                TextField(
                  readOnly: true,
                  onTap: () {
                    model.showBirthDayPicker(context).then((value) => {
                          dateController.text = value,
                          setState(() => birthDateError = null)
                        });
                  },
                  controller: dateController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(8),
                    _DateInputFormatter(),
                  ],
                  decoration: InputDecoration(
                    suffixIcon: Image.asset('assets/icons/birth_date.png'),
                    prefixIcon: Text(
                      ' Date of birth '.tr(),
                      style: const TextStyle(color: kMainColor2, fontSize: 14),
                    ).padding(vertical: 20, horizontal: 10),
                    fillColor: kTextFiledGrayColor,
                    errorText: birthDateError?.tr(),
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
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButtonFormField<String>(
                            value: cityController.text,
                            iconSize: 24,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                            decoration: InputDecoration(
                                hintText: "",
                                border: InputBorder.none,
                                errorText: cityError?.tr(),
                                prefixIcon: Text(
                                  ' City '.tr(),
                                  style: const TextStyle(
                                    color: kMainColor2,
                                    fontSize: 14,
                                  ),
                                ).padding(
                                  vertical: 10,
                                )),
                            onChanged: (value) => {
                                  if (value != null)
                                    {
                                      setState(() {
                                        cityController.text = value;
                                        cityError = null;
                                      })
                                    },
                                },
                            items: () {
                              List<DropdownMenuItem<String>> items = cities.map(
                                (e) {
                                  return DropdownMenuItem(
                                    value: e,
                                    enabled: true,
                                    child: Text(e.tr()),
                                  );
                                },
                              ).toList();
                              items.insert(
                                  0,
                                  DropdownMenuItem(
                                    value: "Select your city",
                                    enabled: false,
                                    child: Text("Select your city".tr(),
                                        style: const TextStyle(
                                            color: Colors.grey)),
                                  ));
                              return items;
                            }())),
                  ),
                ),
                verticalSpaceMedium,
                TextFormField(
                  controller: emailController,
                  validator: (value) => model.validateEmail(value: value),
                  onChanged: (value) => setState(() => emailError = null),
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    prefixIcon: Text(
                      ' Email '.tr(),
                      style: const TextStyle(color: kMainColor2, fontSize: 14),
                    ).padding(vertical: 20, horizontal: 10),
                    errorText: emailError?.tr(),
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
                  onChanged: (value) => setState(() => passwordError = null),
                  obscureText: model.isObscure,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    prefixIcon: Text(
                      ' Password '.tr(),
                      style: const TextStyle(color: kMainColor2, fontSize: 14),
                    ).padding(vertical: 20, horizontal: 10),
                    suffixIcon: IconButton(
                      icon: Icon(
                          model.isObscure
                              ? Icons.visibility_off_outlined
                              : Icons.remove_red_eye_outlined,
                          size: 17),
                      onPressed: model.changeObscure,
                    ),
                    fillColor: kTextFiledGrayColor,
                    filled: true,
                    errorText: passwordError?.tr(),
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
                  onChanged: (value) => setState(() => rePasswordError = null),
                  validator: (value) => model.validateRePassword(
                      password: passwordController.text, rePassword: value),
                  obscureText: model.isObscure,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    prefixIcon: Text(
                      ' Re-Password '.tr(),
                      style: const TextStyle(color: kMainColor2, fontSize: 14),
                    ).padding(vertical: 20, horizontal: 10),
                    suffixIcon: IconButton(
                      icon: Icon(
                        model.isObscure
                            ? Icons.visibility_off_outlined
                            : Icons.remove_red_eye_outlined,
                        size: 17,
                      ),
                      onPressed: model.changeObscure,
                    ),
                    errorText: rePasswordError?.tr(),
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
                      gradient: !isThrottled && !isLoading
                          ? kMainGradient
                          : kMainDisabledGradient,
                    ),
                    child: ElevatedButton(
                      onPressed: !isThrottled && !isLoading ? onSubmit : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                      child: isLoading
                          ? const Loader().center()
                          : !isThrottled
                              ? Text(
                                  'Continue'.tr(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                )
                              : RichText(
                                  text: TextSpan(
                                    text: "Try again after ".tr(),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "$remainingSeconds",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      TextSpan(
                                          text: " seconds".tr(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500))
                                    ],
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                    )),
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
