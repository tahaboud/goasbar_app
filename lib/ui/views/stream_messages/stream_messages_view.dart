import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/data_models/chat_message_model.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/widgets/message_bubble.dart';

class StreamMessagesView extends HookWidget {
  StreamMessagesView(
      {super.key,
      required this.stream,
      required this.user,
      required this.messages,
      required this.scrollController,
      required this.scrollToBottom});

  final Stream<dynamic> stream;
  final UserModel user;
  final List<ChatMessage> messages;
  bool isInitialRender = true;
  ScrollController scrollController;
  void Function() scrollToBottom;

  @override
  Widget build(BuildContext context) {
    final streamMessages = useState<List<StreamChatMessage>>(
      messages.map((msg) => StreamChatMessage.fromChatMessage(msg)).toList(),
    );

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (streamMessages.value.isNotEmpty) {
          scrollToBottom();
        }
      });
      return null;
    }, []);

    // Listen to the stream and update messages
    useEffect(() {
      final subscription = stream.listen((data) {
        try {
          final decodedData = jsonDecode(data);

          final newMessage = StreamChatMessage(
            message: decodedData["message"] ?? "",
            sender: decodedData["sender"] ?? "Unknown",
            createdAt: DateTime.tryParse(decodedData["created_at"] ?? "") ??
                DateTime.now(),
          );

          streamMessages.value = [...streamMessages.value, newMessage];

          scrollToBottom();

          // If this is the initial render, scroll to the bottom
          if (isInitialRender) {
            scrollToBottom();
            isInitialRender = false;
          }
        } catch (e) {
          debugPrint("Error parsing message: $e");
        }
      });

      return subscription.cancel;
    }, [stream]);

    return streamMessages.value.isEmpty
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_bubble_outline, size: 50, color: Colors.grey),
                SizedBox(height: 10),
                Text(
                  'No messages yet.',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          )
        : SizedBox(
            width: screenWidth(context),
            height: screenHeightPercentage(context, percentage: 0.75),
            child: ListView.builder(
              controller: scrollController,
              itemCount: streamMessages.value.length,
              itemBuilder: (context, index) {
                final message = streamMessages.value[index];
                final isSender = message.sender == user.id;

                return Column(
                  crossAxisAlignment: isSender
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    MessageBubble(
                      message: message.message,
                      isSender: isSender,
                      createdAt: message.createdAt,
                    ),
                  ],
                );
              },
            ),
          );
  }
}
