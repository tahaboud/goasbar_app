import 'package:flutter/material.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/edit_profile/edit_profile_view.dart';
import 'package:goasbar/ui/views/login/login_view.dart';
import 'package:goasbar/ui/views/navbar/settings/settings_viewmodel.dart';
import 'package:goasbar/ui/views/settings/payment_method/payment_method_view.dart';
import 'package:goasbar/ui/widgets/settings_card.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:styled_widget/styled_widget.dart';

class SettingsView extends HookWidget {
  const SettingsView({Key? key, this.isUser}) : super(key: key);
  final bool? isUser;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingsViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              verticalSpaceLarge,
              Row(
                children: [
                  Image.asset("assets/icons/navbar/settings.png",),
                  horizontalSpaceMedium,
                  const Text("Customize your preferences", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),)
                ],
              ),
              verticalSpaceLarge,
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
                          image: model.file == null ? const AssetImage("assets/images/avatar.png",)
                              : FileImage(model.file!) as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: kGrayText,
                        ),
                        child: Image.asset("assets/icons/edit.png",).gestures(onTap: () => model.pickImage()),
                      ),
                    ),
                  ],
                ),
              ),
              verticalSpaceRegular,
              Text(isUser! ? "Name" : "Guest user", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
              verticalSpaceMedium,
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: isUser! ? kMainColor1 : Colors.black),
                ),
                child: Text(isUser! ? "Edit Your Profile" : "Get Your Information", style: TextStyle(color: isUser! ? kMainColor1 : Colors.black),).center(),
              ).gestures(onTap: isUser! ? () => model.navigateTo(view: const EditProfileView()) : () => model.navigateTo(view: const LoginView()),),
              verticalSpaceRegular,
              const SettingsCard(
                item1Image: 'notification',
                item1Title: 'Notifications',
                item1Parameter: "ON",
                item2Image: 'lang',
                item2Title: 'Language',
                item2Parameter: "English",
                isUser: false,
              ),
              verticalSpaceRegular,
              SettingsCard(
                item1Image: 'hosted',
                item1Title: isUser! ? 'Post new tripe experience' : 'Be Hosted',
                item1Parameter: isUser! ? 'Add new' : "Apply now",
                onTapParameter: isUser! ? () {} : () => model.showGeneralInfoBottomSheet(),
                item2Image: 'security',
                item2Title: 'Security',
                item2Parameter: "",
                isUser: false,
              ),
              verticalSpaceRegular,
              SettingsCard(
                onTapPaymentParameter: () => model.navigateTo(view: const PaymentMethodView()),
                item1Image: 'support',
                item1Title: 'Help & Support',
                item1Parameter: "",
                item2Image: 'privacy',
                item2Title: 'Privacy policy',
                item2Parameter: "",
                isUser: isUser!,
              ),
              verticalSpaceLarge,
            ],
          ).padding(horizontal: 20),
        ),
      ),
      viewModelBuilder: () => SettingsViewModel(),
      onModelReady: (model) => model.loadData(),
    );
  }
}