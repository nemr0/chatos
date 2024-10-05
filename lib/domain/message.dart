import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Message extends Equatable{
  final String senderId;
  final String recipientId;
  final String content;
  final DateTime timestamp;
  final bool isSender;
  const Message( {required this.isSender,required this.senderId, required this.recipientId, required this.content, required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'isSender':senderId == FirebaseAuth.instance.currentUser?.uid,
      'senderId': senderId,
      'recipientId': recipientId,
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp.toUtc()),
    };
  }

  factory Message.fromDocument(DocumentSnapshot doc) {
    return Message(
      senderId: doc['senderId'],
      recipientId: doc['recipientId'],
      content: doc['content'],
      timestamp: (doc['timestamp'] as Timestamp).toDate().toLocal(), isSender: doc['senderId'] == FirebaseAuth.instance.currentUser?.uid,
    );
  }

  @override
  String toString() =>'Message(isSender:$isSender, senderId: $senderId, recipientId: $recipientId,content:$content,timestamp:$timestamp)';

  @override
  List<Object?> get props => [senderId,recipientId,timestamp,content];
}