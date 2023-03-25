import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/stream_messages/stream_messages_viewmodel.dart';
import 'package:goasbar/ui/widgets/message_bubble.dart';
import 'package:goasbar/ui/widgets/seen_widget.dart';
import 'package:goasbar/ui/widgets/seen_widget_sender.dart';
import 'package:stacked/stacked.dart';

class StreamMessagesView extends HookWidget {
  const StreamMessagesView({super.key, this.chatId, this.providerId});
  final String? chatId;
  final int? providerId;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StreamMessagesViewModel>.reactive(
      builder: (context, model, child) {
        return StreamBuilder(
          stream: model.stream,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.transparent, borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }

            List<Widget>? messagesBubble = [];
            List<DocumentSnapshot>? messages = snapshot.data!.docs;
            int? minutes = ((DateTime.now().millisecondsSinceEpoch / 60000).floor() - (messages.last.get('createdAt').seconds / 60)).floor();
            int? hours = ((DateTime.now().millisecondsSinceEpoch / 3600000).floor() - (messages.last.get('createdAt').seconds / 3600)).floor();
            int? days = ((DateTime.now().millisecondsSinceEpoch / 86400000).floor() - (messages.last.get('createdAt').seconds / 86400)).floor();

            String? time = minutes < 1
                ? "now"
                : minutes < 60
                ? "$minutes min"
                : hours < 2
                ? "1 hour"
                : hours < 24
                ? "$hours hours"
                : days < 2
                ? "1 day"
                : "$days days";

            for (var message in messages) {
              if (message.get("receiverID") == providerId.toString()) {
                messagesBubble.add(Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset("assets/images/user.png"),
                    horizontalSpaceSmall,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MessageBubble(isSender: true, message: message.get("text").toString()),
                        verticalSpaceTiny,
                        if (message.get("text") == messages.last.get("text"))
                          SeenWidgetSender(time: time),
                        if (message.get("text") == messages.last.get("text"))
                          verticalSpaceSmall,
                      ],
                    )
                  ],
                ));
              } else {
                messagesBubble.add(Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    MessageBubble(message: message.get("text"), isSender: false),
                    verticalSpaceTiny,
                    if (message.get("text") == messages.last.get("text"))
                      SeenWidgetMe(time: time,),
                  ],
                ));
              }
            }

            return SingleChildScrollView(
              reverse: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: messagesBubble,
              ),
            );
          },
        );
      },
      viewModelBuilder: () => StreamMessagesViewModel(chatId: chatId,),
    );
  }
}