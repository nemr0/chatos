part of 'chat_cubit.dart';

sealed class ChatState extends Equatable {
  const ChatState();
}

final class InitialChatState extends ChatState {
  const InitialChatState();

  @override
  List<Object?> get props => [];
}
 class GetMessagesForUserState extends ChatState {
  const GetMessagesForUserState();

  @override
  List<Object?> get props => [];
}



final class GetMessagesLoading extends GetMessagesForUserState {
  @override
  List<Object> get props => [];
}

class GetMessagesError extends GetMessagesForUserState {
  final String message;
  final List<Message>? messages;
  const GetMessagesError( {this.messages,required this.message});

  @override
  List<Object> get props => [message];
}

class GetMessagesSuccess extends GetMessagesForUserState {
  final List<Message> messages;

  const GetMessagesSuccess({required this.messages});

  @override
  List<Object> get props => [messages];
}final class SendMessageLoading extends GetMessagesForUserState {
  @override
  List<Object> get props => [];
}

class SendMessageError extends GetMessagesForUserState {
  final String message;
  const SendMessageError( {required this.message});

  @override
  List<Object> get props => [message];
}

final class SendMessageSuccess extends GetMessagesForUserState {

  const SendMessageSuccess();

  @override
  List<Object> get props => [];
}