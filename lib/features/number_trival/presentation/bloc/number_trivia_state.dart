import 'package:bloc_auth/features/number_trival/data/models/number_trivia_model.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
sealed class NumberTriviaState extends Equatable {
  const NumberTriviaState();
}

class InitialNumberTriviaState implements NumberTriviaState {
  const InitialNumberTriviaState() : super();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}

class EmptyNumberTriviaState implements NumberTriviaState {
  const EmptyNumberTriviaState() : super();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}

class LoadingNumberTriviaState implements NumberTriviaState {
  const LoadingNumberTriviaState() : super();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}

class LoadedNumberTriviaState implements NumberTriviaState {
  final NumberTriviaModel trivia;

  const LoadedNumberTriviaState({
    required this.trivia,
  }) : super();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}

class ErrorNumberTriviaState implements NumberTriviaState {
  final String errMsg;

  const ErrorNumberTriviaState({
    required this.errMsg,
  }) : super();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}
