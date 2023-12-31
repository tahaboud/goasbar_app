import 'package:flutter/material.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/widgets/user_welcome_widget/user_welcome_widget_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:easy_localization/easy_localization.dart';

class UserWelcomeWidget extends StatelessWidget {
  const UserWelcomeWidget({
    Key? key,
    required this.isUser,
    required this.user,
  }) : super(key: key);

  final bool? isUser;
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserWelcomeWidgetViewModel>.reactive(
      builder: (context, model, child) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,
            border: Border.all(color: kMainDisabledGray),
          ),
          child: Row(
            children: isUser! ? [
              user == null ? Image.asset("assets/images/user.png",)
                  : ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network("$baseUrl${user!.image}", height: 30, width: 30, fit: BoxFit.cover),
              ),
              horizontalSpaceTiny,
              user == null ? Text('Hi ,'.tr()) : Text('${'Hi ,'.tr()} ${user!.firstName} !'),
            ] : [
              Image.asset("assets/icons/person_login.png", color: kMainColor1),
              horizontalSpaceTiny,
              Text('welcome ,Guest'.tr()),
            ],
          ),
        );
      },
      viewModelBuilder: () => UserWelcomeWidgetViewModel(),
    );
  }
}