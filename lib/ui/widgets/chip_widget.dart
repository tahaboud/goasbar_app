import 'package:flutter/cupertino.dart';
import 'package:goasbar/ui/views/chats_notifications/chats_notifications_viewmodel.dart';
import 'package:styled_widget/styled_widget.dart';

class ChipWidget extends StatelessWidget {
  const ChipWidget({
    Key? key,
    this.model,
    this.index,
  }) : super(key: key);
  final ChatsNotificationsViewModel? model;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: 100,
      child: Text(index! == 1 ? "Messages" : "Notifications").center(),
    ).decorated(
      borderRadius: BorderRadius.circular(20),
      color: model!.indexTab == index ? const Color(0xffF9F9F9) : const Color(0xffE8E9ED),
      animate: true,
    ).animate(const Duration(milliseconds: 300), Curves.easeIn)
        .gestures(onTap: () => model!.changeTab(index!));
  }
}