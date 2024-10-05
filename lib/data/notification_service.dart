import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService{
  final FirebaseMessaging fcm = FirebaseMessaging.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  /// Saves FCM Token to allow notifications later using firebase CloudFunctions.
  Future<bool> saveToken() async {
    await fcm.requestPermission();
    final token = await fcm.getToken();
    if (kDebugMode) {
      print('uid:${auth.currentUser!.uid},token:$token');
    }
    if (token != null) {
      await db
          .collection('users').doc(auth.currentUser!.uid)
          .set({'token': token, 'email': auth.currentUser!.email,'name':auth.currentUser?.displayName});
    }
    return token != null;
  }
}