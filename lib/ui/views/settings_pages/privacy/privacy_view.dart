import 'package:flutter/material.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/settings_pages/privacy/privacy_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/cupertino.dart';

class PrivacyView extends HookWidget {
  const PrivacyView({Key? key}) : super(key: key);

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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(CupertinoIcons.arrow_turn_up_left).height(40)
                        .width(40)
                        .gestures(
                        onTap: () {
                          model.back();
                        }
                    ),
                    const Text('Privacy Policy', style: TextStyle(fontSize: 21),),
                  ],
                ),
                verticalSpaceMedium,
                const Text("1. Types of data that can be collected", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),).alignment(Alignment.centerLeft),
                verticalSpaceRegular,
                const Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident."),
                verticalSpaceMedium,
                const Text("2. Use of your personal data", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),).alignment(Alignment.centerLeft),
                verticalSpaceRegular,
                const Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident."),
                verticalSpaceMedium,
                const Text("3. Disclosure of your personal data", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),).alignment(Alignment.centerLeft),
                verticalSpaceRegular,
                const Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident."),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => PrivacyViewModel(),
    );
  }
}
