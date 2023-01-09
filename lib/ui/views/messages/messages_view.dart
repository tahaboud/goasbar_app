import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/chat_with_agency/chat_with_agency_view.dart';
import 'package:goasbar/ui/views/messages/messages_viewmodel.dart';
import 'package:goasbar/ui/widgets/chat_item.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:stacked/stacked.dart';

class MessagesView extends HookWidget {
  const MessagesView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var search = useTextEditingController();

    return ViewModelBuilder.reactive(
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
            ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              children: [
                ChatItem(onTap: () => model.navigateTo(view: const ChatWithAgencyView())),
                ChatItem(onTap: () => model.navigateTo(view: const ChatWithAgencyView())),
                ChatItem(onTap: () => model.navigateTo(view: const ChatWithAgencyView())),
                ChatItem(onTap: () => model.navigateTo(view: const ChatWithAgencyView())),
                ChatItem(onTap: () => model.navigateTo(view: const ChatWithAgencyView())),
                ChatItem(onTap: () => model.navigateTo(view: const ChatWithAgencyView())),
              ],
            ),
          ],
        );
      },
      viewModelBuilder: () => MessagesViewModel(),
      onModelReady: (model) => model.loadData(),
    );
  }
}