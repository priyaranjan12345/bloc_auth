import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/entities.dart';

@immutable
sealed class NumberTriviaState extends Equatable {
  const NumberTriviaState();

  @override
  List<Object?> get props => [];
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
  final NumberTrivia trivia;

  const LoadedNumberTriviaState({
    required this.trivia,
  }) : super();

  @override
  List<Object?> get props => [trivia];

  @override
  bool? get stringify => true;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LoadedNumberTriviaState && other.trivia == trivia;
  }

  @override
  int get hashCode => trivia.hashCode;
}

class ErrorNumberTriviaState implements NumberTriviaState {
  final String errMsg;

  const ErrorNumberTriviaState({
    required this.errMsg,
  }) : super();

  @override
  List<Object?> get props => [errMsg];

  @override
  bool? get stringify => true;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ErrorNumberTriviaState && other.errMsg == errMsg;
  }

  @override
  int get hashCode => errMsg.hashCode;
}
