import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(BuildContext context) =>
      BlocProvider.of<LoginCubit>(context);
  final auth = FirebaseAuth.instance;
  // if user exist register fallbacks to login.
  loginOrRegister(String email, String password) async {
    if (kDebugMode) print('email:$email,password:$password');
    emit(LoginLoadingsState());
    _register(email, password).catchError((_) => _login(email, password));
  }

  Future<void> _register(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      emit(LoginSuccessState());
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'email-already-in-use') {
        rethrow;
      } else {
        emit(LoginErrorState(message: e.message ?? 'An Error Happened'));
      }
    }
  }

  _login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      if (kDebugMode) print('success');
      emit(LoginSuccessState());
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) print('error:$e');

      emit(LoginErrorState(message: e.message ?? 'An Error Happened'));
    }
  }
}
