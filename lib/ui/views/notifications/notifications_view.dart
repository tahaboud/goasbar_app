import 'package:flutter/material.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/notifications/notifications_viewmodel.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:goasbar/ui/widgets/notification_item.dart';
import 'package:stacked/stacked.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NotificationsViewModel>.reactive(
      builder: (context, model, child) {
        return model.isBusy ? const Loader() : Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/icons/read_check.png"),
                horizontalSpaceSmall,
                const Text("Mark all as read", style: TextStyle(color: Color(0xff3983F1), fontWeight: FontWeight.w600),),
              ],
            ),
            const Divider(height: 40, thickness: 1),
            const NotificationItem(),
            const NotificationItem(),
            const NotificationItem(),
            const NotificationItem(),
            const NotificationItem(),
          ],
        );
      },
      viewModelBuilder: () => NotificationsViewModel(),
      onModelReady: (model) => model.loadData(),
    );
  }
}