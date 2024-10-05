import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final AuthService _singleton = AuthService._internal();

  factory AuthService() {
    return _singleton;
  }

  AuthService._internal();

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> login(String email, String password) async =>
      await auth.signInWithEmailAndPassword(email: email, password: password);

  Future<void> register(String email, String password) async => await auth
      .createUserWithEmailAndPassword(email: email, password: password);
  Future<void> updateUsername(String displayName) async => await auth.currentUser?.updateDisplayName(displayName) ;

  Future<void> signOut () async =>await auth.signOut();
}
