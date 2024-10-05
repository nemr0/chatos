import 'package:chatos/domain/chat.dart';
import 'package:chatos/domain/message.dart';
import 'package:chatos/domain/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'package:firebase_messaging/firebase_messaging.dart';
final ChatService chatService = ChatService();

abstract class IChatService {

  Future<List<User>> findUsersByEmail(String email);

  Future<void> sendMessage(String recipientId, String content);

  Future<String> startChatWithUser(String otherUserId);

  Stream<List<Chat>> streamChats();

  Stream<(List<Message> messages,DocumentSnapshot? lastDoc)> streamMessagesOfUser(String userId,
      {required int limit,});
  Future<User> findUsersByUID(String uid);
}

class ChatService implements IChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final fa.FirebaseAuth _firebaseAuth = fa.FirebaseAuth.instance;
  final FirebaseMessaging fcm = FirebaseMessaging.instance;

  @override

  /// Finds user with matching email (must be the same email)
  Future<List<User>> findUsersByEmail(String email) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    return querySnapshot.docs.map((doc) => User.fromDocument(doc)).toList();
  }

  @override
  /// Finds user with matching email (must be the same email)
  Future<User> findUsersByUID(String uid) async {
    final doc = await _firestore
        .collection('users')
        .doc(uid)
        .get();
    doc.data();
    return User(
        id: uid, email: doc.data()?['email'], name: doc.data()?['name'] ?? '');
  }

  @override
  Future<void> sendMessage(String recipientId, String content) async {
    String senderId = _firebaseAuth.currentUser!.uid;
    (DocumentReference, DocumentReference) chatDocRef =
    await _getOrCreateChatDocument(senderId, recipientId);

    Message message = Message(
      senderId: senderId,
      recipientId: recipientId,
      content: content,
      isSender: true,
      timestamp: DateTime.now(),
    );

    chatDocRef.$1.collection('messages').add(message.toMap());
    await chatDocRef.$2.collection('messages').add(message.toMap());
  }

  @override

  /// Adds A chat
  Future<String> startChatWithUser(String otherUserId) async {
    String currentUserId = _firebaseAuth.currentUser!.uid;
    DocumentReference chatDocRef = (await _getOrCreateChatDocument(
        currentUserId, otherUserId)).$1;
    return chatDocRef.id;
  }

  @override

  /// get all user chats
  Stream<(List<Message> messages, DocumentSnapshot? lastDoc)> streamMessagesOfUser(
      String userId, {int limit = 20, DocumentSnapshot? startAfter}) {
    String currentUserId = _firebaseAuth.currentUser!.uid;

    Stream<QuerySnapshot> chatQueryStream = _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('chats')
        .where('participants', arrayContainsAny: [currentUserId, userId])
        .snapshots();

    return chatQueryStream.asyncExpand((chatQuery) async* {
      if (chatQuery.docs.isNotEmpty) {
        DocumentReference chatDocRef = chatQuery.docs.first.reference;
        Query messagesQueryBuilder = chatDocRef
            .collection('messages')
            .orderBy('timestamp', descending: false);

        // if (startAfter != null) {
        //   messagesQueryBuilder = messagesQueryBuilder.startAfterDocument(startAfter);
        // }

        yield* messagesQueryBuilder.snapshots().map<
            (List<Message> messages, DocumentSnapshot? lastDoc)>((
            messagesQuery) {
          List<Message> msgs = messagesQuery.docs.map<Message>((doc) =>
              Message.fromDocument(doc)).toList();
          print(msgs);
          return (msgs, messagesQuery.docs.last);
        });
      } else {
        yield ([], null);
      }
    });
  }

  @override
  Stream<List<Chat>> streamChats() {
    String currentUserId = _firebaseAuth.currentUser!.uid;
    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('chats')
        .snapshots()
        .asyncMap((chatQuery) async {
      List<Chat> chats = [];
      for (var doc in chatQuery.docs) {
        print(chatQuery.docs.first.data());
        print(doc.data()['participants']);
        String? otherUserId = (doc.data()['participants'] as List<dynamic>).where((id) => id != currentUserId).firstOrNull;
        User? user = await findUserById(otherUserId ?? '');
        Message? lastMessage = await _getLastMessage(doc.reference);
        print('user:$user');
        print(lastMessage);
        print(otherUserId);

        if (user != null && lastMessage != null) {
          chats.add(Chat(chatId: doc.id, user: user, lastMessage: lastMessage));
        }
      }
      print(chats);

      return chats;
    });
  }

  Future<User?> findUserById(String userId) async {
    DocumentSnapshot userDoc =
    await _firestore.collection('users').doc(userId).get();
    if (userDoc.exists) {
      return User.fromDocument(userDoc);
    }
    return null;
  }

  Future<Message?> _getLastMessage(DocumentReference chatDocRef) async {
    QuerySnapshot messageQuery = await chatDocRef
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();
    if (messageQuery.docs.isNotEmpty) {
      return Message.fromDocument(messageQuery.docs.first);
    }
    return null;
  }

  Future<(DocumentReference, DocumentReference)> _getOrCreateChatDocument(
      String currentUserId, String otherUserId) async {
    QuerySnapshot existingChats = await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('chats')
        .where('participants', arrayContains: otherUserId)
        .limit(1)
        .get();
    QuerySnapshot existingChatsForOtherUser = await _firestore
        .collection('users')
        .doc(otherUserId)
        .collection('chats')
        .where('participants', arrayContains: currentUserId)
        .limit(1)
        .get();

    if (existingChats.docs.isNotEmpty &&
        existingChatsForOtherUser.docs.isNotEmpty) {
      return (existingChats.docs.first.reference, existingChatsForOtherUser.docs
          .first.reference);
    } else {
      DocumentReference newChatRef = _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('chats')
          .doc();
      DocumentReference newChatRefForOtherUser = _firestore
          .collection('users')
          .doc(otherUserId)
          .collection('chats')
          .doc(newChatRef.id);
      await newChatRef.set({
        'participants': [currentUserId, otherUserId],
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      // Also create the chat reference for the other user
      await _firestore
          .collection('users')
          .doc(otherUserId)
          .collection('chats')
          .doc(newChatRef.id)
          .set({
        'participants': [currentUserId, otherUserId],
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      return (newChatRef, newChatRefForOtherUser);
    }
  }
}