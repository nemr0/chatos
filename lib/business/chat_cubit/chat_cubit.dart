import 'dart:async';

import 'package:chatos/data/chat_service.dart';
import 'package:chatos/domain/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(const InitialChatState());
  StreamSubscription? messagesSubscription;

  static ChatCubit get(BuildContext context) =>
      BlocProvider.of<ChatCubit>(context);

  killSubscription() {
    messagesSubscription?.cancel();
    messagesSubscription = null;
  }
  List<Message> messages = [];

  getMessagesForUser(String userId,{bool noLoading=false}) async {
   if(noLoading==false) emit(GetMessagesLoading());
   await chatService.startChatWithUser(userId);
    messagesSubscription=chatService.streamMessagesOfUser(userId).asBroadcastStream().listen((data) {
      messages = data.$1;
      emit(GetMessagesSuccess(messages: data.$1));
      print(messages);
    }, onError: (e) {
      print(e);
      emit(GetMessagesError(
          messages: messages,
          message: e is FirebaseException
              ? e.message ?? 'An Error Happened'
              : 'An Error Happened'));
    });
  }

  sendMessage(String otherUserID, String content) async {
    emit(SendMessageLoading());
    try {
      await chatService.sendMessage(otherUserID, content);
      emit(const SendMessageSuccess());
    } catch (e) {
      print(e);
      emit(SendMessageError(
          message: e is FirebaseException
              ? e.message ?? 'An Error Happened'
              : 'An Error Happened'));
    }
  }
}
