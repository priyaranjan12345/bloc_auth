import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
sealed class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();
}

class GetConcreteNumberTriviaEvent implements NumberTriviaEvent {
  final String numberString;

  GetConcreteNumberTriviaEvent({
    required this.numberString,
  }) : super();

  int get nuber => int.parse(numberString);

  @override
  List<Object?> get props => [numberString];

  @override
  bool? get stringify => false;
}

class GetRandomNumberTriviaEvent implements NumberTriviaEvent {
  GetRandomNumberTriviaEvent() : super();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => false;
}
