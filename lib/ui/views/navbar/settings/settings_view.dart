import 'package:flutter/material.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/bookings_history/bookings_history_view.dart';
import 'package:goasbar/ui/views/edit_profile/edit_profile_view.dart';
import 'package:goasbar/ui/views/login/login_view.dart';
import 'package:goasbar/ui/views/navbar/settings/settings_viewmodel.dart';
import 'package:goasbar/ui/views/request_reset/request_password_view.dart';
import 'package:goasbar/ui/views/settings_pages/language/language_view.dart';
import 'package:goasbar/ui/views/settings_pages/notification_settings/notification_settings_view.dart';
import 'package:goasbar/ui/views/settings_pages/payment_method/payment_method_view.dart';
import 'package:goasbar/ui/views/settings_pages/post_experience/post_experience_view.dart';
import 'package:goasbar/ui/views/settings_pages/privacy/privacy_view.dart';
import 'package:goasbar/ui/views/settings_pages/support/support_view.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:goasbar/ui/widgets/settings_card.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingsView extends HookWidget {
  const SettingsView({Key? key, this.isUser, this.user}) : super(key: key);
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset("assets/icons/navbar/settings.png",),
                ],
              ),
              verticalSpaceLarge,
              Column(
                children: model.isBusy ? [const Loader().center()] : [
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
                              image: model.user != null ? NetworkImage("$baseUrl${model.user!.image}",)
                                  : const AssetImage("assets/images/avatar.png") as ImageProvider,
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
                  Text(isUser! ? model.user!.firstName! : "Guest user", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                  verticalSpaceMedium,
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: isUser! ? kMainColor1 : Colors.black),
                    ),
                    child: Text(isUser! ? "Edit your Profile".tr() : "Get Your Information".tr(), style: TextStyle(color: isUser! ? kMainColor1 : Colors.black),).center(),
                  ).gestures(onTap: isUser! ? () => model.navigateToWithResponse(view: EditProfileView()) : () => model.navigateTo(view: const LoginView()),),
                  verticalSpaceRegular,
                  SettingsCard(
                    item1Image: 'notification',
                    item1Title: 'Notifications'.tr(),
                    item1Parameter: "ON",
                    item2Image: 'lang',
                    item2Title: 'Language'.tr(),
                    item2Parameter: context.locale.toString() == "en_UK" ? "English" : "Arabic".tr(),
                    onItem1Tap: () => model.navigateTo(view: const NotificationSettingsView()),
                    onItem2Tap: () => model.navigateTo(view: const LanguageView()),
                    isUser: false,
                  ),
                  verticalSpaceRegular,
                  SettingsCard(
                    item1Image: 'hosted',
                    item1Title: isUser! ? model.user!.isProvider! ? 'Post a new experience'.tr() : 'Be Hosted'.tr() : 'Be Hosted'.tr(),
                    item1Parameter: isUser! ? model.user!.isProvider! ? 'Update Info'.tr() : "Apply now".tr() : "Apply now".tr(),
                    onTapParameter: isUser! ? model.user!.isProvider! ? () => model.showGeneralInfoBottomSheet() : () => model.showGeneralInfoBottomSheet() : () {model.navigateTo(view: const LoginView());},
                    item2Image: 'security',
                    additionalParameterOnTap: isUser! ? () => model.navigateTo(view: BookingsHistoryView(user: model.user!,)) : () {},
                    item2Title: 'Security'.tr(),
                    item2Parameter: "",
                    onItem1Tap: !isUser! ? () {model.navigateTo(view: const LoginView());} : model.user!.isProvider! ? () => model.navigateTo(view: const PostExperienceView()) : () => model.showGeneralInfoBottomSheet(),
                    onItem2Tap: () => model.navigateTo(view: const RequestPasswordView()),
                    isUser: false,
                  ),
                  verticalSpaceRegular,
                  SettingsCard(
                    additionalParameterOnTap: () => model.navigateTo(view: const PaymentMethodView()),
                    item1Image: 'support',
                    item1Title: 'Help & Support'.tr(),
                    item1Parameter: "",
                    item2Image: 'privacy',
                    item2Title: 'Privacy policy'.tr(),
                    item2Parameter: "",
                    onItem1Tap: () => model.navigateTo(view: const SupportView()),
                    onItem2Tap: () => model.navigateTo(view: const PrivacyView()),
                    isUser: isUser!,
                  ),
                  verticalSpaceMedium,
                  !isUser! ? const SizedBox() : Container(
                    height: 50,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.redAccent,
                    ),
                    child: model.isClicked! ? const Loader().center() : Text('Logout'.tr(), style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),).center(),
                  ).gestures(onTap: () {
                    model.logout(context: context).then((value) {
                      model.updateIsClicked(value: false);
                      if (value!) {
                        showMotionToast(context: context, title: 'Logout Success', msg: "Have a good day, see you later", type: MotionToastType.error);
                        model.clearToken();
                        model.clearAndNavigateTo(view: const LoginView());
                      } else {
                        showMotionToast(context: context, title: 'Logout Failed', msg: "An error has occurred, please try again", type: MotionToastType.error);
                      }
                    });
                  }),
                  !isUser! ? const SizedBox() : verticalSpaceLarge,
                ],
              ),
            ],
          ).padding(horizontal: 20),
        ),
      ),
      viewModelBuilder: () => SettingsViewModel(context: context, isUser: isUser!),
    );
  }
}