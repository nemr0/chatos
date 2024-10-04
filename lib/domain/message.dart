import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Message extends Equatable{
  final String senderId;
  final String message;
  final DateTime timestamp;

  const Message({required this.senderId, required this.message, required this.timestamp});

  factory Message.fromDocument(DocumentSnapshot doc) {
    return Message(
      senderId: doc['senderId'],
      message: doc['message'],
      timestamp: (doc['timestamp'] as Timestamp).toDate(),
    );
  }

  @override
  List<Object?> get props => [senderId,message,timestamp];
}