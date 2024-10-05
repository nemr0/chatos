import 'dart:async';

import 'package:chatos/data/chat_service.dart';
import 'package:chatos/domain/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'get_recent_chats_state.dart';




class GetRecentChatsCubit extends Cubit<GetRecentChatsState> {
  GetRecentChatsCubit() : super(GetRecentChatsInitial());
  StreamSubscription? chatsSubscription;
  static GetRecentChatsCubit get(BuildContext context)=>BlocProvider.of<GetRecentChatsCubit>(context);

  killSubscription() {
  chatsSubscription?.cancel();
  chatsSubscription = null;
}
  List<Chat> chats=[];
  run({bool withLoading=true}) async {
   if(withLoading) emit(GetRecentChatsLoading());
    chatService.streamChats().listen((newList) {
      List<String> ids=[];
     chats.clear();
     for(Chat chat in newList){
       if(ids.contains(chat.user.id)==false){
         chats.add(chat);
         ids.add(chat.user.id);
       }
     }
      emit(GetRecentChatsSuccess(chats: newList));
    }, onError: (e,s) {
      emit(GetRecentChatsError(
          message: e is FirebaseException
              ? e.message ?? 'An Error Happened'
              : 'An Error Happened'));
    });
  }
}
