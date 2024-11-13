import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/settings_pages/privacy/privacy_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class PrivacyView extends HookWidget {
  const PrivacyView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PrivacyViewModel>.reactive(
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
                      icon: const Icon(CupertinoIcons.arrow_turn_up_right),
                    ),
                    Text(
                      'Privacy Policy'.tr(),
                      style: const TextStyle(fontSize: 21),
                    ),
                  ],
                ),
                verticalSpaceMedium,
                Text(
                  "title 1 privacy".tr(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ).alignment(context.locale == const Locale('ar', 'SA')
                    ? Alignment.centerRight
                    : Alignment.centerLeft),
                verticalSpaceSmall,
                Text("section 1 privacy 01".tr()).alignment(
                    context.locale == const Locale('ar', 'SA')
                        ? Alignment.centerRight
                        : Alignment.centerLeft),
                Text("section 1 privacy 02".tr()).alignment(
                    context.locale == const Locale('ar', 'SA')
                        ? Alignment.centerRight
                        : Alignment.centerLeft),
                Text("section 1 privacy 03".tr()).alignment(
                    context.locale == const Locale('ar', 'SA')
                        ? Alignment.centerRight
                        : Alignment.centerLeft),
                Text("section 1 privacy 04".tr()).alignment(
                    context.locale == const Locale('ar', 'SA')
                        ? Alignment.centerRight
                        : Alignment.centerLeft),
                Text("section 1 privacy 05".tr()).alignment(
                    context.locale == const Locale('ar', 'SA')
                        ? Alignment.centerRight
                        : Alignment.centerLeft),
                Text("section 1 privacy 06".tr()).alignment(
                    context.locale == const Locale('ar', 'SA')
                        ? Alignment.centerRight
                        : Alignment.centerLeft),
                Text("section 1 privacy 07".tr()).alignment(
                    context.locale == const Locale('ar', 'SA')
                        ? Alignment.centerRight
                        : Alignment.centerLeft),
                Text("section 1 privacy 08".tr()).alignment(
                    context.locale == const Locale('ar', 'SA')
                        ? Alignment.centerRight
                        : Alignment.centerLeft),
                Text("section 1 privacy 09".tr()).alignment(
                    context.locale == const Locale('ar', 'SA')
                        ? Alignment.centerRight
                        : Alignment.centerLeft),
                verticalSpaceMedium,
                Text(
                  "title 2 privacy".tr(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ).alignment(context.locale == const Locale('ar', 'SA')
                    ? Alignment.centerRight
                    : Alignment.centerLeft),
                verticalSpaceSmall,
                Text("section 2 privacy 01".tr()).alignment(
                    context.locale == const Locale('ar', 'SA')
                        ? Alignment.centerRight
                        : Alignment.centerLeft),
                Text("section 2 privacy 02".tr()).alignment(
                    context.locale == const Locale('ar', 'SA')
                        ? Alignment.centerRight
                        : Alignment.centerLeft),
                Text("section 2 privacy 03".tr()).alignment(
                    context.locale == const Locale('ar', 'SA')
                        ? Alignment.centerRight
                        : Alignment.centerLeft),
                Text("section 2 privacy 04".tr()).alignment(
                    context.locale == const Locale('ar', 'SA')
                        ? Alignment.centerRight
                        : Alignment.centerLeft),
                Text("section 2 privacy 05".tr()).alignment(
                    context.locale == const Locale('ar', 'SA')
                        ? Alignment.centerRight
                        : Alignment.centerLeft),
                Text("section 2 privacy 06".tr()).alignment(
                    context.locale == const Locale('ar', 'SA')
                        ? Alignment.centerRight
                        : Alignment.centerLeft),
                Text("section 2 privacy 07".tr()).alignment(
                    context.locale == const Locale('ar', 'SA')
                        ? Alignment.centerRight
                        : Alignment.centerLeft),
                Text("section 2 privacy 08".tr()).alignment(
                    context.locale == const Locale('ar', 'SA')
                        ? Alignment.centerRight
                        : Alignment.centerLeft),
                Text("section 2 privacy 09".tr()).alignment(
                    context.locale == const Locale('ar', 'SA')
                        ? Alignment.centerRight
                        : Alignment.centerLeft),
                Text("section 2 privacy 10".tr()).alignment(
                    context.locale == const Locale('ar', 'SA')
                        ? Alignment.centerRight
                        : Alignment.centerLeft),
                Text("section 2 privacy 11".tr()).alignment(
                    context.locale == const Locale('ar', 'SA')
                        ? Alignment.centerRight
                        : Alignment.centerLeft),
                Text("section 2 privacy 12".tr()).alignment(
                    context.locale == const Locale('ar', 'SA')
                        ? Alignment.centerRight
                        : Alignment.centerLeft),
                Text("section 2 privacy 13".tr()).alignment(
                    context.locale == const Locale('ar', 'SA')
                        ? Alignment.centerRight
                        : Alignment.centerLeft),
                Text("section 2 privacy 14".tr()).alignment(
                    context.locale == const Locale('ar', 'SA')
                        ? Alignment.centerRight
                        : Alignment.centerLeft),
                Text("section 2 privacy 15".tr()).alignment(
                    context.locale == const Locale('ar', 'SA')
                        ? Alignment.centerRight
                        : Alignment.centerLeft),
                Text("section 2 privacy 16".tr()).alignment(
                    context.locale == const Locale('ar', 'SA')
                        ? Alignment.centerRight
                        : Alignment.centerLeft),
                Text("section 2 privacy 17".tr()).alignment(
                    context.locale == const Locale('ar', 'SA')
                        ? Alignment.centerRight
                        : Alignment.centerLeft),
                Text("section 2 privacy 18".tr()).alignment(
                    context.locale == const Locale('ar', 'SA')
                        ? Alignment.centerRight
                        : Alignment.centerLeft),
                verticalSpaceMedium,
                Text(
                  "title 3 privacy".tr(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ).alignment(context.locale == const Locale('ar', 'SA')
                    ? Alignment.centerRight
                    : Alignment.centerLeft),
                verticalSpaceSmall,
                Text('section 3 privacy 01'.tr()).alignment(
                    context.locale == const Locale('ar', 'SA')
                        ? Alignment.centerRight
                        : Alignment.centerLeft),
                Text('section 3 privacy 02'.tr()).alignment(
                    context.locale == const Locale('ar', 'SA')
                        ? Alignment.centerRight
                        : Alignment.centerLeft),
                Text("section 3 privacy 03".tr()).alignment(
                    context.locale == const Locale('ar', 'SA')
                        ? Alignment.centerRight
                        : Alignment.centerLeft),
                Text('section 3 privacy 04'.tr()).alignment(
                    context.locale == const Locale('ar', 'SA')
                        ? Alignment.centerRight
                        : Alignment.centerLeft),
                Text('section 3 privacy 05'.tr()).alignment(
                    context.locale == const Locale('ar', 'SA')
                        ? Alignment.centerRight
                        : Alignment.centerLeft),
                Text('section 3 privacy 06'.tr()).alignment(
                    context.locale == const Locale('ar', 'SA')
                        ? Alignment.centerRight
                        : Alignment.centerLeft),
                Text('section 3 privacy 07'.tr()).alignment(
                    context.locale == const Locale('ar', 'SA')
                        ? Alignment.centerRight
                        : Alignment.centerLeft),
                Text('section 3 privacy 08'.tr()).alignment(
                    context.locale == const Locale('ar', 'SA')
                        ? Alignment.centerRight
                        : Alignment.centerLeft),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => PrivacyViewModel(),
    );
  }
}
