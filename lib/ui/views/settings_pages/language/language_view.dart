import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/settings_pages/language/language_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class LanguageView extends HookWidget {
  const LanguageView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LanguageViewModel>.reactive(
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
                      'Language'.tr(),
                      style: const TextStyle(fontSize: 21),
                    ),
                  ],
                ),
                verticalSpaceMedium,
                Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      "Suggested".tr(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    )).alignment(Alignment.topRight),
                verticalSpaceRegular,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Arabic (SA)".tr()),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          color: model.lang == "ar"
                              ? Colors.white
                              : Colors.grey.shade300,
                          border: Border.all(
                              width: model.lang == "ar" ? 5 : 1,
                              color: model.lang == "ar"
                                  ? kMainColor1
                                  : Colors.grey),
                          borderRadius: BorderRadius.circular(30)),
                    ).gestures(
                        onTap: () =>
                            model.changeValue(value: "ar", context: context)),
                  ],
                ),
                verticalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("English (UK)"),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          color: model.lang == "uk"
                              ? Colors.white
                              : Colors.grey.shade300,
                          border: Border.all(
                              width: model.lang == "uk" ? 5 : 1,
                              color: model.lang == "uk"
                                  ? kMainColor1
                                  : Colors.grey),
                          borderRadius: BorderRadius.circular(30)),
                    ).gestures(
                        onTap: () =>
                            model.changeValue(value: "uk", context: context)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => LanguageViewModel(),
      onModelReady: (model) => model.getStartLocale(context: context),
    );
  }
}
