
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chatos/domain/message.dart';
import 'package:chatos/presentation/helpers/context_extension.dart';
import 'package:flutter/material.dart';

class MessagesView extends StatelessWidget {
  const MessagesView({
    super.key,
    required this.messages,
  });

  final List<Message> messages;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        padding: const EdgeInsets.all(8),
        reverse: true,
        itemBuilder: (_, index) {
          final message = messages[messages.length - (index + 1)];
          return BubbleSpecialThree(
              isSender: message.isSender,
              color: message.isSender
                  ? context.colorScheme.primaryContainer
                  : context.colorScheme.primary,
              textStyle: TextStyle(
                  color: message.isSender
                      ? context.colorScheme.onPrimaryContainer
                      : context.colorScheme.onPrimary),
              text: message.content);
        },
        itemCount: messages.length,
        separatorBuilder: (BuildContext context, int index) {
          final bool isSender =
              messages[messages.length - (index + 1)].isSender;

          return Divider(
            endIndent: isSender ? 10 : context.width * .8,
            indent: isSender ? context.width * .8 : 10,
          );
        });
  }
}
