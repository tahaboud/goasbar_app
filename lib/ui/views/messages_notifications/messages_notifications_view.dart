import 'package:flutter/material.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/messages_notifications/messages_notifications_viewmodel.dart';
import 'package:goasbar/ui/views/messages/messages_view.dart';
import 'package:goasbar/ui/views/notifications/notifications_view.dart';
import 'package:goasbar/ui/widgets/chip_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MessagesNotificationsView extends HookWidget {
  const MessagesNotificationsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MessagesNotificationsViewModel>.reactive(
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
                    const Icon(Icons.arrow_back_sharp).height(40)
                        .width(40)
                        .gestures(
                        onTap: () {
                          model.back();
                        }
                    ),
                    Container(
                      height: 40,
                      width: 230,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xffE8E9ED),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          ChipWidget(index: 1, model: model),
                          horizontalSpaceSmall,
                          ChipWidget(index: 2, model: model),
                        ],
                      ),
                    ),
                    horizontalSpaceLarge,
                  ],
                ),
                verticalSpaceMedium,
                model.indexTab == 1 ? const MessagesView() : const NotificationsView(),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => MessagesNotificationsViewModel(),
    );
  }
}