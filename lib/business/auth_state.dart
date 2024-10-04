part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();
}

final class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

final class AuthSuccessState extends AuthState {
  @override
  List<Object> get props => [];
}

final class AuthLoadingsState extends AuthState {
  @override
  List<Object> get props => [];
}

final class AuthPermissionDenied extends AuthState {
  @override
  List<Object> get props => [];
}

final class AuthPermissionGranted extends AuthState {
  @override
  List<Object> get props => [];
}
final class AuthSignOutState extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthErrorState extends AuthState {
  final String message;

  const AuthErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
