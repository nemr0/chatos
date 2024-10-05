import 'package:chatos/domain/message.dart';
import 'package:chatos/domain/user.dart';
import 'package:equatable/equatable.dart';

class Chat extends Equatable{
  final String chatId;
  final User user;
  final Message lastMessage;

  const Chat({required this.chatId, required this.user, required this.lastMessage});

  @override
  List<Object?> get props => [chatId,user,lastMessage];
  @override
  String toString() =>'Chat(chatId:$chatId, User: $user, lastMessage: $lastMessage)';

}