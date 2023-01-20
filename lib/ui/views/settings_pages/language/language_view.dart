import 'package:flutter/material.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/settings_pages/language/language_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/cupertino.dart';

class LanguageView extends HookWidget {
  const LanguageView({Key? key}) : super(key: key);

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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(CupertinoIcons.arrow_turn_up_left).height(40)
                        .width(40)
                        .gestures(
                        onTap: () {
                          model.back();
                        }
                    ),
                    const Text('Language', style: TextStyle(fontSize: 21),),
                  ],
                ),
                verticalSpaceMedium,
                const Text("Suggested", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),).alignment(Alignment.centerLeft),
                verticalSpaceRegular,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("English (US)"),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: model.lang == "us" ? Colors.white : Colors.grey.shade300,
                        border: Border.all(width: model.lang == "us" ? 5 : 1, color: model.lang == "us" ? kMainColor1 : Colors.grey),
                        borderRadius: BorderRadius.circular(30)
                      ),
                    ).gestures(onTap: () => model.changeValue(value: "us")),
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
                          color: model.lang == "uk" ? Colors.white : Colors.grey.shade300,
                          border: Border.all(width: model.lang == "uk" ? 5 : 1, color: model.lang == "uk" ? kMainColor1 : Colors.grey),
                          borderRadius: BorderRadius.circular(30)
                      ),
                    ).gestures(onTap: () => model.changeValue(value: "uk")),
                  ],
                ),
                verticalSpaceSmall,
                const Divider(thickness: 1),
                verticalSpaceSmall,
                const Text("Others", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),).alignment(Alignment.centerLeft),
                verticalSpaceRegular,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Mandarin"),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(30)
                      ),
                    ).gestures(onTap: () => model.changeValue(value: "us")),
                  ],
                ),
                verticalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Hindi"),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(30)
                      ),
                    ).gestures(onTap: () => model.changeValue(value: "us")),
                  ],
                ),
                verticalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Spanish"),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(30)
                      ),
                    ).gestures(onTap: () => model.changeValue(value: "us")),
                  ],
                ),
                verticalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Arabic"),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(30)
                      ),
                    ).gestures(onTap: () => model.changeValue(value: "us")),
                  ],
                ),
                verticalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("French"),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(30)
                      ),
                    ).gestures(onTap: () => model.changeValue(value: "us")),
                  ],
                ),
                verticalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Russian"),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(30)
                      ),
                    ).gestures(onTap: () => model.changeValue(value: "us")),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => LanguageViewModel(),
    );
  }
}
