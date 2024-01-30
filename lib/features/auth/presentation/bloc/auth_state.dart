part of 'auth_bloc.dart';

enum AuthStatus {
  loading,
  logedin,
  error,
}

class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}
