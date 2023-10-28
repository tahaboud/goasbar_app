import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/edit_profile/edit_profile_viewmodel.dart';
import 'package:goasbar/ui/widgets/info_item.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class EditProfileView extends HookWidget {
  EditProfileView({Key? key}) : super(key: key);
  bool? once = true;

  @override
  Widget build(BuildContext context) {
    var firstName = useTextEditingController();
    var lastName = useTextEditingController();
    var userName = useTextEditingController();
    var email = useTextEditingController();
    var phone = useTextEditingController();

    return ViewModelBuilder<EditProfileViewModel>.reactive(
      builder: (context, model, child) {
        if (!model.isBusy && once!) {
          firstName.text = model.user!.firstName!;
          lastName.text = model.user!.lastName!;
          userName.text = model.user!.userName!;
          email.text = model.user!.email!;
          phone.text = model.user!.phoneNumber!;
          model.gender.text =
              model.user!.gender! == "M" ? "Male".tr() : "Female".tr();

          once = false;
        }
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(CupertinoIcons.arrow_turn_up_left)
                          .height(40)
                          .width(40)
                          .gestures(onTap: () {
                        model.back();
                      }),
                      Text(
                        'Edit Profile'.tr(),
                        style: const TextStyle(fontSize: 21),
                      ),
                    ],
                  ),
                  verticalSpaceMedium,
                  Column(
                    children: model.isBusy
                        ? [const Loader().center()]
                        : [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    spreadRadius: 0,
                                    offset: Offset(0, 1),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            border: Border.all(
                                                color: kMainColor2, width: 2),
                                            image: DecorationImage(
                                              image: model.file == null
                                                  ? NetworkImage(
                                                      "$baseUrl${model.user!.image}",
                                                    )
                                                  : FileImage(model.file!)
                                                      as ImageProvider,
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                      horizontalSpaceSmall,
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${model.user!.firstName!} ${model.user!.lastName!}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          verticalSpaceSmall,
                                          Text(
                                            "Change Profile Picture".tr(),
                                            style: const TextStyle(
                                                color: kGrayText),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Image.asset("assets/icons/export.png")
                                      .gestures(onTap: () => model.pickImage()),
                                ],
                              ),
                            ),
                            verticalSpaceMedium,
                            InfoItem(
                              controller: firstName,
                              label: 'First name'.tr(),
                              hintText: 'Abdeldjalil',
                            ),
                            verticalSpaceMedium,
                            InfoItem(
                              controller: lastName,
                              label: 'Last name'.tr(),
                              hintText: 'Anes',
                            ),
                            verticalSpaceMedium,
                            InfoItem(
                              controller: userName,
                              label: 'User name'.tr(),
                              hintText: 'Abdeldjalil_Anes',
                            ),
                            verticalSpaceMedium,
                            Container(
                              decoration: BoxDecoration(
                                color: kTextFiledMainColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  verticalSpaceSmall,
                                  Row(
                                    children: [
                                      horizontalSpaceSmall,
                                      Text("Email".tr()),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 50,
                                    child: TextFormField(
                                      validator: (value) =>
                                          model.validateEmail(value: value),
                                      controller: email,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: const InputDecoration(
                                        hintText: 'exemple@email.com',
                                        hintStyle: TextStyle(fontSize: 14),
                                        fillColor: kTextFiledMainColor,
                                        filled: true,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            verticalSpaceMedium,
                            Container(
                              decoration: BoxDecoration(
                                color: kTextFiledMainColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  verticalSpaceSmall,
                                  Row(
                                    children: [
                                      horizontalSpaceSmall,
                                      Text("Phone Number".tr()),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 50,
                                    child: TextFormField(
                                      validator: (value) => model
                                          .validatePhoneNumber(value: value),
                                      controller: phone,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        hintText: '+213699414965',
                                        hintStyle: TextStyle(fontSize: 14),
                                        fillColor: kTextFiledMainColor,
                                        filled: true,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            verticalSpaceMedium,
                            Container(
                              decoration: BoxDecoration(
                                color: kTextFiledMainColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  verticalSpaceSmall,
                                  Row(
                                    children: [
                                      horizontalSpaceSmall,
                                      Text("Gender".tr()),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 40,
                                    child: TextField(
                                      readOnly: true,
                                      controller: model.gender,
                                      decoration: InputDecoration(
                                        hintText: 'Male'.tr(),
                                        hintStyle:
                                            const TextStyle(fontSize: 14),
                                        suffixIcon:
                                            const Icon(Icons.arrow_drop_down)
                                                .gestures(
                                                    onTap: () => model
                                                        .showSelectionDialog(
                                                            gen: model
                                                                .gender.text)),
                                        fillColor: kTextFiledMainColor,
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            verticalSpaceMedium,
                            Container(
                              width: MediaQuery.of(context).size.width - 30,
                              height: 50,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                gradient: kMainGradient,
                              ),
                              child: model.isClicked!
                                  ? const Loader().center()
                                  : Text(
                                      'SUBMIT'.tr(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ).center(),
                            ).gestures(
                              onTap: firstName.text != model.user!.firstName! ||
                                      lastName.text != model.user!.lastName! ||
                                      userName.text != model.user!.userName! ||
                                      email.text != model.user!.email! ||
                                      phone.text != model.user!.phoneNumber! ||
                                      model.gender.text[0] !=
                                          model.user!.gender! ||
                                      model.file != null
                                  ? () async {
                                      Map<String, dynamic>? body = {};
                                      if (firstName.text !=
                                          model.user!.firstName!) {
                                        body.addAll(
                                            {'first_name': firstName.text});
                                      }
                                      if (lastName.text !=
                                          model.user!.lastName!) {
                                        body.addAll(
                                            {'last_name': lastName.text});
                                      }
                                      if (userName.text !=
                                          model.user!.userName!) {
                                        body.addAll(
                                            {'user_name': userName.text});
                                      }
                                      if (email.text != model.user!.email!) {
                                        body.addAll({'email': email.text});
                                      }
                                      if (phone.text !=
                                          model.user!.phoneNumber!) {
                                        body.addAll(
                                            {'phone_number': phone.text});
                                      }
                                      if (model.gender.text[0] !=
                                          model.user!.gender!) {
                                        body.addAll(
                                            {'gender': model.gender.text[0]});
                                      }
                                      if (model.file != null) {
                                        var pickedFile =
                                            await MultipartFile.fromFile(
                                          model.file!.path,
                                          filename: model.file!.path.substring(
                                              model.file!.absolute.path
                                                      .lastIndexOf('/') +
                                                  1),
                                        );
                                        body.addAll({'image': pickedFile});
                                      }

                                      if (body != {}) {
                                        if (context.mounted) {
                                          model
                                              .updateUserData(
                                            context: context,
                                            body: body,
                                          )
                                              .then((value) async {
                                            model.updateIsClicked(value: false);
                                            if (value != null) {
                                              model.back();
                                            } else {}
                                          });
                                        }
                                      }
                                    }
                                  : () {
                                      MotionToast.warning(
                                        title: const Text(
                                            "Update Your Data First"),
                                        description: const Text(
                                            "To submit update information, you must change your data first"),
                                        animationCurve: Curves.easeIn,
                                        animationDuration:
                                            const Duration(milliseconds: 200),
                                      ).show(context);
                                    },
                            ),
                          ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      viewModelBuilder: () => EditProfileViewModel(context: context),
    );
  }
}
