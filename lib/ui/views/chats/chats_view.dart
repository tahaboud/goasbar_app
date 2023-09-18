import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/chat_with_agency/chat_with_agency_view.dart';
import 'package:goasbar/ui/views/chats/chats_viewmodel.dart';
import 'package:goasbar/ui/widgets/chat_item/chat_item.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:stacked/stacked.dart';
import 'package:easy_localization/easy_localization.dart';

class ChatsView extends HookWidget {
  const ChatsView({Key? key, this.user, this.userToken}) : super(key: key,);
  final UserModel? user;
  final String? userToken;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatsViewModel>.reactive(
      builder: (context, model, child) {
        return model.isBusy ? const Loader() : Column(
          children: [
            verticalSpaceMedium,
            Text('Chats'.tr(), style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),).alignment(Alignment.centerLeft),
            verticalSpaceMedium,
            model.isBusy ? const Loader().center() : StreamBuilder(
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

                List<Widget>? messagesItems = [];
                List<DocumentSnapshot>? chats = snapshot.data!.docs;

                print(chats);
                for (var chat in chats) {
                  Map<String, dynamic> data = chat.data()! as Map<String, dynamic>;

                  int? notMeId;
                  int? meId;
                  String? chatId;
                  String? notMeName;
                  chatId = chat.id;

                  if (user!.userName == data["member_names"]![0]) {
                    notMeId = int.parse(data["members"][1]);
                    notMeName = data["member_names"][1];
                    meId = int.parse(data["members"][0]);
                  } else {
                    if (user!.userName == data["member_names"]![1]) {
                      notMeId = int.parse(data["members"][0]);
                      notMeName = data["member_names"][0];
                      meId = int.parse(data["members"][1]);
                    } else {
                      if (user!.id == int.parse(data["members"][0])) {
                        notMeId = int.parse(data["members"][1]);
                        notMeName = data["member_names"][1];
                        meId = int.parse(data["members"][0]);
                      } else if (user!.id == int.parse(data["members"][1])) {
                        notMeId = int.parse(data["members"][0]);
                        notMeName = data["member_names"][0];
                        meId = int.parse(data["members"][1]);
                      }
                    }
                  }

                  print("**********************");
                  print(chatId);
                  print("**********************");

                  if (notMeId != null) {
                    messagesItems.add(
                      ChatItem(
                        isUser: !user!.isProvider!,
                        receiverName: notMeName,
                        receiverId: notMeId,
                        onTap: () => model.navigateTo(view: ChatWithAgencyView(meId: meId, notMeId: notMeId, chatId: chatId, notMeName: notMeName,)),
                      ),
                    );
                  }
                }

                return SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: messagesItems,
                  ),
                );
              },
            ),
          ],
        );
      },
      viewModelBuilder: () => ChatsViewModel(context: context, user: user),
    );
  }
}