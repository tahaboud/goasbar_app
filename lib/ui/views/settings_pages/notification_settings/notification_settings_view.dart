import 'package:flutter/material.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/settings_pages/notification_settings/notification_settings_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/cupertino.dart';

class NotificationSettingsView extends HookWidget {
  const NotificationSettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NotificationSettingsViewModel>.reactive(
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
                    const Text('Notifications', style: TextStyle(fontSize: 21),),
                  ],
                ),
                verticalSpaceMedium,
                const Text("Common", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),).alignment(Alignment.centerLeft),
                verticalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("General Notification"),
                    CupertinoSwitch(
                      value: model.genInfo,
                      onChanged: (val) {
                        model.changeValue(number: 1, value: val);
                      },
                      // splashRadius: 30,
                      activeColor: kMainColor1,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Sound"),
                    CupertinoSwitch(
                      value: model.sound,
                      onChanged: (val) {
                        model.changeValue(number: 2, value: val);
                      },
                      // splashRadius: 30,
                      activeColor: kMainColor1,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Vibrate"),
                    CupertinoSwitch(
                      value: model.vibrate,
                      onChanged: (val) {
                        model.changeValue(number: 3, value: val);
                      },
                      // splashRadius: 30,
                      activeColor: kMainColor1,
                    ),
                  ],
                ),
                verticalSpaceSmall,
                const Divider(thickness: 1),
                verticalSpaceSmall,
                const Text("System & services update", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),).alignment(Alignment.centerLeft),
                verticalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("App updates"),
                    CupertinoSwitch(
                      value: model.appUpdates,
                      onChanged: (val) {
                        model.changeValue(number: 4, value: val);
                      },
                      // splashRadius: 30,
                      activeColor: kMainColor1,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Bill Reminder"),
                    CupertinoSwitch(
                      value: model.bill,
                      onChanged: (val) {
                        model.changeValue(number: 5, value: val);
                      },
                      // splashRadius: 30,
                      activeColor: kMainColor1,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Promotion"),
                    CupertinoSwitch(
                      value: model.promotion,
                      onChanged: (val) {
                        model.changeValue(number: 6, value: val);
                      },
                      // splashRadius: 30,
                      activeColor: kMainColor1,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Discount Avaiable"),
                    CupertinoSwitch(
                      value: model.discount,
                      onChanged: (val) {
                        model.changeValue(number: 7, value: val);
                      },
                      // splashRadius: 30,
                      activeColor: kMainColor1,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Payment Request"),
                    CupertinoSwitch(
                      value: model.payment,
                      onChanged: (val) {
                        model.changeValue(number: 8, value: val);
                      },
                      // splashRadius: 30,
                      activeColor: kMainColor1,
                    ),
                  ],
                ),
                verticalSpaceSmall,
                const Divider(thickness: 1),
                verticalSpaceSmall,
                const Text("Others", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),).alignment(Alignment.centerLeft),
                verticalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("New Service Available"),
                    CupertinoSwitch(
                      value: model.newService,
                      onChanged: (val) {
                        model.changeValue(number: 9, value: val);
                      },
                      // splashRadius: 30,
                      activeColor: kMainColor1,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("New Tips Available"),
                    CupertinoSwitch(
                      value: model.newTips,
                      onChanged: (val) {
                        model.changeValue(number: 10, value: val);
                      },
                      // splashRadius: 30,
                      activeColor: kMainColor1,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => NotificationSettingsViewModel(),
    );
  }
}
