import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/chat_with_agency/chat_with_agency_view.dart';
import 'package:goasbar/ui/views/messages/messages_viewmodel.dart';
import 'package:goasbar/ui/widgets/chat_item/chat_item.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:stacked/stacked.dart';

class MessagesView extends HookWidget {
  const MessagesView({Key? key, this.user,}) : super(key: key,);
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    var search = useTextEditingController();

    return ViewModelBuilder<MessagesViewModel>.reactive(
      builder: (context, model, child) {
        return model.isBusy ? const Loader() : Column(
          children: [
            TextField(
              controller: search,
              decoration: InputDecoration(
                hintText: 'Search company trips . . .',
                hintStyle: const TextStyle(fontSize: 14),
                prefixIcon: Image.asset("assets/icons/navbar/search.png"),
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
            ).padding(horizontal: 20),
            verticalSpaceMedium,
            const Text('Chats', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),).alignment(Alignment.centerLeft),
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

                for (var chat in chats) {
                  Map<String, dynamic> data = chat.data()! as Map<String, dynamic>;

                  messagesItems.add(
                    ChatItem(
                      isUser: !user!.isProvider!,
                      receiverName: user!.id == data["members"][1] ? data["member_names"][0] : data["member_names"][1],
                      receiverId: user!.id == data["members"][1] ? int.parse(data["members"][0]) : int.parse(data["members"][1]),
                      onTap: () => model.navigateTo(view: const ChatWithAgencyView()),
                    ),
                  );
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
      viewModelBuilder: () => MessagesViewModel(),
      onModelReady: (model) => model.loadData(),
    );
  }
}