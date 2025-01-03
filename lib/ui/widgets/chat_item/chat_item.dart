import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/data_models/chat_room_model.dart';
import 'package:goasbar/data_models/chat_user_model.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/chat_with_agency/chat.dart';
import 'package:goasbar/ui/views/chats/chats_viewmodel.dart';
import 'package:goasbar/ui/widgets/chat_item/chat_item_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class ChatItem extends StatelessWidget {
  ChatItem({
    super.key,
    required this.user,
    required this.room,
    required this.chatRoomsModel,
  }) : chatPartner = (room.client.id == user.id) ? room.provider : room.client;

  final UserModel user;
  final ChatRoom room;
  final ChatUser chatPartner;
  ChatsViewModel chatRoomsModel;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatItemViewModel>.reactive(
      builder: (context, model, child) {
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => model.navigateTo(
                    view: ChatView(user: user, room: room),
                    chatRoomsModel: chatRoomsModel),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                              NetworkImage(chatPartner.image) as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    horizontalSpaceSmall,
                    Flexible(
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              chatPartner.nickname != null
                                  ? chatPartner.nickname!
                                  : "${chatPartner.firstName} ${chatPartner.lastName}",
                            ),
                            Text(
                              room.lastMessageDate != null
                                  ? DateFormat("dd-MM-yyyy")
                                      .format(room.lastMessageDate!)
                                  : "",
                              style: const TextStyle(
                                color: kMainDisabledGray,
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Check your last messages'.tr(),
                              style: const TextStyle(
                                  color: kMainDisabledGray, fontSize: 12),
                            ),
                            room.unreadMessagesCount > 0
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Text(
                                            room.unreadMessagesCount.toString(),
                                            style: const TextStyle(
                                                color: Colors.white))
                                        .center(),
                                  ).decorated(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.red)
                                : const SizedBox(),
                          ],
                        ),
                      ]),
                    )
                  ],
                )));
      },
      viewModelBuilder: () => ChatItemViewModel(context: context),
    );
  }
}
