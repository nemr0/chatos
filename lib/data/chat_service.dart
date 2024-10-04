import 'package:chatos/domain/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<List<Message>> getMessages() {
    if(FirebaseAuth.instance.currentUser?.uid == null) throw('Please Register.');
    return db
    .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Message.fromDocument(doc)).toList());
  }

  Future<void> sendMessage(String message, String senderId) async {
    await db.collection('messages').add({
      'senderId': senderId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}


