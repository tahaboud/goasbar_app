import 'package:flutter/material.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/chat_with_agency/chat_with_agency_viewmodel.dart';
import 'package:goasbar/ui/views/stream_messages/stream_messages_view.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ChatWithAgencyView extends HookWidget {
  const ChatWithAgencyView({Key? key, this.userId, this.providerId}) : super(key: key);
  final int? providerId;
  final int? userId;

  @override
  Widget build(BuildContext context) {
    var message = useTextEditingController();

    return ViewModelBuilder<ChatWithAgencyViewModel>.reactive(
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
                    const Icon(Icons.arrow_back_sharp).height(40)
                        .width(40)
                        .gestures(
                        onTap: () {
                          model.back();
                        }
                    ),
                    const Text('E-salam Agency', style: TextStyle(fontSize: 21),),
                  ],
                ),
                verticalSpaceMedium,
                Expanded(
                  child: model.isBusy ? const Loader().center() : StreamMessagesView(chatId: model.chatTokenProvider!.chatId!, providerId: providerId),
                ),
                TextField(
                  controller: message,
                  decoration: InputDecoration(
                    hintText: 'Type Something...',
                    hintStyle: const TextStyle(fontSize: 14),
                    suffixIcon: Image.asset("assets/icons/import.png").gestures(onTap: () => model.sendMessage(providerId: providerId!.toString(), message: message, userId: userId!.toString())),
                    icon: Image.asset("assets/icons/file.png").gestures(onTap: () => model.file()),
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
      viewModelBuilder: () => ChatWithAgencyViewModel(context: context, providerId: providerId),
    );
  }
}

class SeenWidgetSender extends StatelessWidget {
  const SeenWidgetSender({
    Key? key,
    this.time,
  }) : super(key: key);
  final String? time;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(time!, style: const TextStyle(color: kMainGray, fontSize: 13),),
        horizontalSpaceSmall,
        Image.asset("assets/icons/sms.png"),
      ],
    );
  }
}

class SeenWidgetMe extends StatelessWidget {
  const SeenWidgetMe({
    Key? key,
    this.time,
  }) : super(key: key);
  final String? time;

  @override
  Widget build(BuildContext context) {
    return Text(time!, style: const TextStyle(color: kMainGray, fontSize: 13),).padding(horizontal: 5);
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key? key,
    this.message,
    this.isSender,
  }) : super(key: key);
  final String? message;
  final bool? isSender;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidthPercentage(context, percentage: 0.8),
      child: Text(
        message!,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: isSender! ? Colors.black : Colors.white),
        textAlign: isSender! ? TextAlign.left : TextAlign.right,
      ).padding(horizontal: 20, vertical: 10),
    ).decorated(
      color: isSender! ? kAgencyColor : kMainColor1,
      borderRadius: BorderRadius.only(
        topRight: isSender! ? const Radius.circular(20) : const Radius.circular(5),
        bottomRight: isSender! ? const Radius.circular(20) : const Radius.circular(5),
        topLeft: isSender! ? const Radius.circular(5) : const Radius.circular(20),
        bottomLeft: isSender! ? const Radius.circular(5) : const Radius.circular(20),
      ),
    );
  }
}