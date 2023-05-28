import 'package:flutter/material.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/chat_with_agency_from_trip_detail/chat_with_agency_from_trip_detail_viewmodel.dart';
import 'package:goasbar/ui/views/stream_messages/stream_messages_view.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ChatWithAgencyFromTripDetailView extends HookWidget {
  const ChatWithAgencyFromTripDetailView({Key? key, this.meId, this.providerId, this.notMeName, this.notMeId}) : super(key: key);
  final int? providerId;
  final int? notMeId;
  final int? meId;
  final String? notMeName;

  @override
  Widget build(BuildContext context) {
    var message = useTextEditingController();

    return ViewModelBuilder<ChatWithAgencyFromTripDetailViewModel>.reactive(
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
                    Text(notMeName!, style: const TextStyle(fontSize: 21),),
                  ],
                ),
                verticalSpaceMedium,
                Expanded(
                  child: !model.dataReady ? const Loader().center() : StreamMessagesView(chatId: model.chatTokenProvider!.chatId!, notMeId: notMeId, meId: meId),
                ),
                TextField(
                  controller: message,
                  decoration: InputDecoration(
                    hintText: 'Send a message',
                    hintStyle: const TextStyle(fontSize: 14),
                    suffixIcon: Image.asset("assets/icons/import.png").gestures(onTap: () => model.sendMessage(notMeId: notMeId!.toString(), message: message, meId: meId!.toString())),
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
      viewModelBuilder: () => ChatWithAgencyFromTripDetailViewModel(context: context, providerId: providerId),
    );
  }
}

