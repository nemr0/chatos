import 'package:chatos/domain/chat.dart';
import 'package:chatos/domain/message.dart';
import 'package:chatos/domain/user.dart';
import 'package:chatos/presentation/screens/chat/chat_screen.dart';
import 'package:chatos/presentation/widgets/home_widgets/chat_tile.dart';
import 'package:flutter/material.dart';

final List<Chat> fakeChats = List.generate(
    20,
    (index) => Chat(
        chatId: 'chatId',
        user: const User(
            id: 'userId', email: 'email@example.com', name: 'Some Name'),
        lastMessage: Message(
            isSender: true,
            senderId: 'senderId',
            recipientId: 'recipientId',
            content: 'context of message',
            timestamp: DateTime.timestamp())));

class ChatTiles extends StatelessWidget {
  const ChatTiles({super.key, required this.chats,  this.loading=false});

  final List<Chat> chats;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate((_, index) {
      return ChatTile(
        loading: loading,
        chat: chats[index],
        onPressed: loading?null:()=>Navigator.pushNamed(context, ChatScreen.route,arguments: chats[index].user.toMap()),
      );
    }, childCount: chats.length));
  }
}
