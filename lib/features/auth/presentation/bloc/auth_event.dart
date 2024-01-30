part of 'auth_bloc.dart';

class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Login extends AuthEvent {}

class RetryLogin extends AuthEvent {}
