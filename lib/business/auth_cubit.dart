import 'package:chatos/data/auth_service.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  static AuthCubit get(BuildContext context) =>
      BlocProvider.of<AuthCubit>(context);
  final AuthService auth = AuthService();

  /// login Or Register then save user data to Firestore.
  /// if user exist register fallbacks to login.
  loginOrRegister(String email, String password) async {
    if (kDebugMode) print('---Login:\nemail: $email, password: $password');
    try {
      emit(AuthLoadingsState());
      bool notExist = await _register(email, password);
      if (!notExist) {
        await auth.login(email, password);
      }

      await auth.saveToken();
      print('4');

      emit(AuthSuccessState());
    } catch (e) {

      if (kDebugMode) print('error:$e');

      emit(AuthErrorState(message: e is FirebaseException?e.message ?? 'An Error Happened':'An Error Happened'));
    }
  }

  signOut() async {
   await auth.signOut();
   emit(AuthSignOutState());
  }

  Future<bool> _register(String email, String password) async {
    try {
      await auth.register(email, password);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return false;
      } else {
        rethrow;
      }
    }
  }


}
