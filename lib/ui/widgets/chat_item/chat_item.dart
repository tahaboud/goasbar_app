import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/widgets/chat_item/chat_item_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({
    Key? key,
    this.onTap,
    this.receiverName,
    this.receiverId,
    this.isUser,
  }) : super(key: key);
  final Function()? onTap;
  final String? receiverName;
  final int? receiverId;
  final bool? isUser;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatItemViewModel>.reactive(
      builder: (context, model, child) {
        return Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: model.isBusy
                      ? const AssetImage("assets/images/message_pic.png")
                      : model.data == null
                          ? const AssetImage("assets/images/message_pic.png")
                          : NetworkImage('$baseUrl${model.data}')
                              as ImageProvider,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            horizontalSpaceSmall,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  receiverName!,
                ),
                verticalSpaceSmall,
                Text(
                  'Check your last messages'.tr(),
                  style:
                      const TextStyle(color: kMainDisabledGray, fontSize: 12),
                )
              ],
            ),
            //TODO add non read messages
            // const Spacer(),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.end,
            //   children: [
            //     const Text('5 min ago', style: TextStyle(color: kMainDisabledGray,),),
            //     verticalSpaceSmall,
            //     SizedBox(
            //       width: 20,
            //       height: 20,
            //       child: const Text('4', style: TextStyle(color: Colors.white)).center(),
            //     ).decorated(borderRadius: BorderRadius.circular(5), color: Colors.black),
            //   ],
            // ),
          ],
        ).padding(bottom: 20).gestures(onTap: onTap);
      },
      viewModelBuilder: () =>
          ChatItemViewModel(id: receiverId, isUser: isUser, context: context),
    );
  }
}
