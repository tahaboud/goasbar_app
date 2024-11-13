import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/edit_profile/edit_profile_view.dart';
import 'package:goasbar/ui/views/login/login_view.dart';
import 'package:goasbar/ui/views/navbar/settings/settings_viewmodel.dart';
import 'package:goasbar/ui/views/request_reset/request_password_view.dart';
import 'package:goasbar/ui/views/settings_pages/language/language_view.dart';
import 'package:goasbar/ui/views/settings_pages/privacy/privacy_view.dart';
import 'package:goasbar/ui/views/settings_pages/support/support_view.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class SettingsView extends HookWidget {
  const SettingsView({super.key, this.isUser, this.user});
  final bool? isUser;
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingsViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              verticalSpaceLarge,
              Column(
                children: model.isBusy
                    ? [const Loader().center()]
                    : [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: Stack(
                            children: [
                              Container(
                                height: 130,
                                width: 130,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  image: DecorationImage(
                                    image: model.user != null
                                        ? NetworkImage(
                                            "$baseUrl${model.user!.image}",
                                          )
                                        : const AssetImage(
                                                "assets/images/avatar.png")
                                            as ImageProvider,
                                    // : FileImage(model.file!) as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              // Positioned(
                              //   right: 0,
                              //   bottom: 0,
                              //   child: Container(
                              //     height: 40,
                              //     width: 40,
                              //     decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(50),
                              //       color: kGrayText,
                              //     ),
                              //     child: Image.asset("assets/icons/edit.png",).gestures(onTap: () {
                              //       model.pickImage();
                              //     }),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        verticalSpaceRegular,
                        Text(
                          isUser! ? model.user!.firstName! : "",
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        verticalSpaceMedium,
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: 1,
                                color: isUser! ? kMainColor1 : Colors.black),
                          ),
                          child: Text(
                            isUser!
                                ? "Edit your Profile".tr()
                                : "Get Your Information".tr(),
                            style: TextStyle(
                                color: isUser! ? kMainColor1 : Colors.black),
                          ).center(),
                        ).gestures(
                          onTap: isUser!
                              ? () => model.navigateToWithResponse(
                                  view: EditProfileView())
                              : () => model.navigateTo(view: const LoginView()),
                        ),
                        verticalSpaceRegular,
                        ElevatedButton(
                          onPressed: () =>
                              model.navigateTo(view: const LanguageView()),
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all<Color>(Colors.white),
                              minimumSize: WidgetStateProperty.all<Size>(
                                  const Size.fromHeight(40)),
                              shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                Image.asset("assets/icons/settings/lang.png",
                                    width: 20),
                                horizontalSpaceSmall,
                                Text(
                                  "Language".tr(),
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ]),
                              const Text("English")
                            ],
                          ),
                        ),
                        isUser! ? verticalSpaceRegular : Container(),
                        isUser!
                            ? ElevatedButton(
                                onPressed: model.user!.isProvider!
                                    ? () => model.showGeneralInfoBottomSheet()
                                    : () => model.showGeneralInfoBottomSheet(),
                                style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                            Colors.white),
                                    minimumSize: WidgetStateProperty.all<Size>(
                                        const Size.fromHeight(40)),
                                    shape: WidgetStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ))),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(children: [
                                      Image.asset(
                                          "assets/icons/settings/hosted.png",
                                          width: 20),
                                      horizontalSpaceSmall,
                                      Text(
                                        model.user!.isProvider!
                                            ? 'Update Info'.tr()
                                            : 'Become a provider'.tr(),
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ]),
                                  ],
                                ),
                              )
                            : Container(),
                        isUser! ? verticalSpaceRegular : Container(),
                        isUser!
                            ? ElevatedButton(
                                onPressed: () => model.navigateTo(
                                    view: const RequestPasswordView()),
                                style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                            Colors.white),
                                    minimumSize: WidgetStateProperty.all<Size>(
                                        const Size.fromHeight(40)),
                                    shape: WidgetStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ))),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(children: [
                                      Image.asset(
                                          "assets/icons/settings/security.png",
                                          width: 20),
                                      horizontalSpaceSmall,
                                      Text(
                                        'Change password'.tr(),
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ]),
                                  ],
                                ),
                              )
                            : Container(),
                        verticalSpaceRegular,
                        ElevatedButton(
                          onPressed: () =>
                              model.navigateTo(view: const SupportView()),
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all<Color>(Colors.white),
                              minimumSize: WidgetStateProperty.all<Size>(
                                  const Size.fromHeight(40)),
                              shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                Image.asset("assets/icons/settings/support.png",
                                    width: 20),
                                horizontalSpaceSmall,
                                Text(
                                  'Help & Support'.tr(),
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ]),
                            ],
                          ),
                        ),
                        verticalSpaceRegular,
                        ElevatedButton(
                          onPressed: () =>
                              model.navigateTo(view: const PrivacyView()),
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all<Color>(Colors.white),
                              minimumSize: WidgetStateProperty.all<Size>(
                                  const Size.fromHeight(40)),
                              shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                Image.asset("assets/icons/settings/privacy.png",
                                    width: 20),
                                horizontalSpaceSmall,
                                Text(
                                  'Privacy policy'.tr(),
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ]),
                            ],
                          ),
                        ),
                        verticalSpaceMedium,
                        !isUser!
                            ? const SizedBox()
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: screenWidthPercentage(context,
                                        percentage: 0.4),
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      color: Colors.white,
                                      border: Border.all(
                                          width: 1, color: Colors.redAccent),
                                    ),
                                    child: model.isClicked!
                                        ? const Loader().center()
                                        : Text(
                                            'Logout'.tr(),
                                            style: const TextStyle(
                                                color: Colors.redAccent,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ).center(),
                                  ).gestures(onTap: () {
                                    model
                                        .logout(context: context)
                                        .then((value) {
                                      model.updateIsClicked(value: false);
                                      if (value!) {
                                        showMotionToast(
                                            context: context,
                                            title: 'Logout Success',
                                            msg:
                                                "Have a good day, see you later",
                                            type: MotionToastType.error);
                                        model.clearToken();
                                        model.clearAndNavigateTo(
                                            view: const LoginView());
                                      } else {}
                                    });
                                  }),
                                  Container(
                                    width: screenWidthPercentage(context,
                                        percentage: 0.4),
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      color: Colors.redAccent,
                                    ),
                                    child: model.isClicked2!
                                        ? const Loader().center()
                                        : Text(
                                            'Delete Account'.tr(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ).center(),
                                  ).gestures(onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text(
                                                "Do you want to delete your account?")
                                            .tr(),
                                        actions: <Widget>[
                                          ElevatedButton(
                                            child: Text("Yes".tr()),
                                            onPressed: () {
                                              Navigator.pop(context, false);
                                              model
                                                  .deleteAccount(
                                                      context: context)
                                                  .then((value) {
                                                model.updateIsClicked2(
                                                    value: false);
                                                if (value!) {
                                                  showMotionToast(
                                                      context: context,
                                                      title:
                                                          'Delete Account Success',
                                                      msg:
                                                          "Have a good day, see you later",
                                                      type: MotionToastType
                                                          .error);
                                                  model.clearToken();
                                                  model.clearAndNavigateTo(
                                                      view: const LoginView());
                                                } else {}
                                              });
                                            },
                                          ),
                                          ElevatedButton(
                                            child: Text("No".tr()),
                                            onPressed: () {
                                              Navigator.pop(context, false);
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                                ],
                              ),
                        !isUser! ? const SizedBox() : verticalSpaceLarge,
                      ],
              ),
            ],
          ).padding(horizontal: 20),
        ),
      ),
      viewModelBuilder: () =>
          SettingsViewModel(context: context, isUser: isUser!),
    );
  }
}
