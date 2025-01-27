import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/chats/chats_view.dart';
import 'package:goasbar/ui/views/chats_notifications/chats_notifications_viewmodel.dart';
import 'package:goasbar/ui/widgets/chip_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class ChatsNotificationsView extends HookWidget {
  const ChatsNotificationsView({super.key, this.user});
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatsNotificationsViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: [
                verticalSpaceRegular,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.arrow_back_sharp)
                        .height(40)
                        .width(40)
                        .gestures(onTap: () {
                      model.back();
                    }),
                    Container(
                      height: 40,
                      width: 120,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xffE8E9ED),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          ChipWidget(index: 1, model: model),
                        ],
                      ),
                    ),
                    horizontalSpaceLarge,
                  ],
                ),
                verticalSpaceMedium,
                !model.dataReady
                    ? const SizedBox()
                    : ChatsView(
                        user: user!,
                        userToken: model.userToken,
                      )
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => ChatsNotificationsViewModel(context: context),
    );
  }
}
