import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/chats/chats_viewmodel.dart';
import 'package:goasbar/ui/widgets/chat_item/chat_item.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class ChatsView extends HookWidget {
  const ChatsView({super.key, this.user, this.userToken});
  final UserModel? user;
  final String? userToken;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatsViewModel>.reactive(
      builder: (context, model, child) {
        return model.isBusy
            ? const Loader()
            : Column(
                children: [
                  Text(
                    'Chats'.tr(),
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ).alignment(Alignment.centerRight),
                  verticalSpaceMedium,
                  SingleChildScrollView(
                    reverse: true,
                    child: SizedBox(
                        width: screenWidth(context),
                        height:
                            screenHeightPercentage(context, percentage: 0.75),
                        child: ListView(
                          children: model.rooms.isEmpty
                              ? [
                                  const Text("No rooms"),
                                ]
                              : model.rooms
                                  .map((room) => ChatItem(
                                        user: user!,
                                        room: room,
                                        chatRoomsModel: model,
                                      ))
                                  .toList(),
                        )),
                  ),
                ],
              );
      },
      viewModelBuilder: () => ChatsViewModel(context: context, user: user),
      onViewModelReady: (model) async => await model.getChatRooms(),
    );
  }
}
