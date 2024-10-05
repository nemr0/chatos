part of 'get_recent_chats_cubit.dart';

sealed class GetRecentChatsState extends Equatable {
  const GetRecentChatsState();
}

final class GetRecentChatsInitial extends GetRecentChatsState {
  @override
  List<Object> get props => [];
}


final class GetRecentChatsLoading extends GetRecentChatsState {
  @override
  List<Object> get props => [];
}

class GetRecentChatsError extends GetRecentChatsState {
  final String message;

  const GetRecentChatsError({required this.message});

  @override
  List<Object> get props => [message];
}

class GetRecentChatsSuccess extends GetRecentChatsState {
  final List<Chat> chats;

  const GetRecentChatsSuccess({required this.chats});

  @override
  List<Object> get props => [chats];
}