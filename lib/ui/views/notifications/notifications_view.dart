import 'package:flutter/material.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/notifications/notifications_viewmodel.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:easy_localization/easy_localization.dart';
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
            verticalSpaceMedium,
            Text('This page is not available right now'.tr()),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Image.asset("assets/icons/read_check.png"),
            //     horizontalSpaceSmall,
            //     const Text("Mark all as read".tr(), style: TextStyle(color: Color(0xff3983F1), fontWeight: FontWeight.w600),),
            //   ],
            // ),
            // const Divider(height: 40, thickness: 1),
            // const NotificationItem(),
            // const NotificationItem(),
            // const NotificationItem(),
            // const NotificationItem(),
            // const NotificationItem(),
          ],
        );
      },
      viewModelBuilder: () => NotificationsViewModel(),
      onModelReady: (model) => model.loadData(),
    );
  }
}