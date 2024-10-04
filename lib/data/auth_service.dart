import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthService {
  static final AuthService _singleton = AuthService._internal();

  factory AuthService() {
    return _singleton;
  }

  AuthService._internal();

  final FirebaseMessaging fcm = FirebaseMessaging.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> login(String email, String password) async =>
      await auth.signInWithEmailAndPassword(email: email, password: password);

  Future<void> register(String email, String password) async => await auth
      .createUserWithEmailAndPassword(email: email, password: password);

  Future<bool> saveToken() async {

    await fcm.requestPermission();
    final token = await fcm.getToken();
    print('uid:${auth.currentUser!.uid},token:$token');
    if (token != null) {
      await db
          .collection('users').doc(auth.currentUser!.uid)
          .set({'token': token, 'email': auth.currentUser!.email});
    }
    return token != null;
  }
  Future<void> signOut () async =>await auth.signOut();
}
