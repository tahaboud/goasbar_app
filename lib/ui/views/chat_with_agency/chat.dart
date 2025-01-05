import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/data_models/chat_room_model.dart';
import 'package:goasbar/data_models/chat_user_model.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/chat_with_agency/chat_viewmodel.dart';
import 'package:goasbar/ui/views/stream_messages/stream_messages_view.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatView extends HookWidget {
  ChatView({
    super.key,
    required this.room,
    required this.user,
  }) : chatPartner = (room.client.id == user.id) ? room.provider : room.client;

  final ChatRoom room;
  final UserModel user;
  final ChatUser chatPartner;

  @override
  Widget build(BuildContext context) {
    final message = useTextEditingController();
    final scrollController = useScrollController();
    final FocusNode focusNode = FocusNode();

    void sendMessage(WebSocketChannel? channel) {
      if (channel != null && message.text.isNotEmpty) {
        channel.sink
            .add(jsonEncode({"type": "chat_message", "message": message.text}));
        message.text = "";
      }
    }

    void scrollToBottom() {
      if (scrollController.hasClients) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
    }

    useEffect(() {
      focusNode.addListener(() {
        if (focusNode.hasFocus) {
          Future.delayed(const Duration(milliseconds: 500), scrollToBottom);
        }
      });
      return null;
    }, []);

    return ViewModelBuilder<ChatViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: [
                verticalSpaceRegular,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.arrow_back_sharp)
                        .height(40)
                        .width(40)
                        .gestures(onTap: () {
                      model.back();
                    }),
                    Text(
                      chatPartner.nickname != null
                          ? chatPartner.nickname!
                          : "${chatPartner.firstName} ${chatPartner.lastName}",
                      style: const TextStyle(fontSize: 21),
                    ),
                  ],
                ),
                verticalSpaceMedium,
                model.isLoading
                    ? const Loader().center()
                    : model.channel != null
                        ? Expanded(
                            child: StreamMessagesView(
                              stream: model.channel!.stream,
                              user: user,
                              messages: model.messages,
                              scrollController: scrollController,
                              scrollToBottom: scrollToBottom,
                            ),
                          )
                        : const SizedBox(),
                TextField(
                  controller: message,
                  focusNode: focusNode,
                  enabled: !model.isLoading,
                  decoration: InputDecoration(
                    hintText: 'Send a message'.tr(),
                    hintStyle: const TextStyle(fontSize: 14),
                    suffixIcon: Image.asset("assets/icons/import.png")
                        .gestures(onTap: () => sendMessage(model.channel)),
                    // icon: Image.asset("assets/icons/file.png").gestures(onTap: () => model.file()),
                    fillColor: kTextFiledGrayColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: kTextFiledGrayColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => ChatViewModel(
        context: context,
      ),
      onViewModelReady: (model) => model.onStart(room.id),
      onDispose: (model) => model.channel?.sink.close(),
    );
  }
}
