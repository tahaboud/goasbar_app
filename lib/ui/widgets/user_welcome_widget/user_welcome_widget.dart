import 'package:flutter/material.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/widgets/user_welcome_widget/user_welcome_widget_viewmodel.dart';
import 'package:stacked/stacked.dart';

class UserWelcomeWidget extends StatelessWidget {
  const UserWelcomeWidget({
    Key? key,
    required this.isUser,
  }) : super(key: key);

  final bool? isUser;

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
              model.isBusy ? Image.asset("assets/images/user.png",)
                  : ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network("$baseUrl${model.user!.image}", height: 30, width: 30, fit: BoxFit.cover),
              ),
              horizontalSpaceTiny,
              model.isBusy ? const Text('Hi , ') : Text('Hi , ${model.user!.firstName} !'),
            ] : [
              Image.asset("assets/icons/person_login.png", color: kMainColor1),
              horizontalSpaceTiny,
              const Text('welcome ,Guest'),
            ],
          ),
        );
      },
      viewModelBuilder: () => UserWelcomeWidgetViewModel(),
    );
  }
}