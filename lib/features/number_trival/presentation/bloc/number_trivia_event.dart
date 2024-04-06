import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
sealed class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();
}

class GetTriviaForConcreteNumber implements NumberTriviaEvent {
  final String numberString;

  GetTriviaForConcreteNumber({
    required this.numberString,
  }) : super();

  int get nuber => int.parse(numberString);

  @override
  List<Object?> get props => [numberString];

  @override
  bool? get stringify => false;
}

class GetTriviaForRandomNumber implements NumberTriviaEvent {
  GetTriviaForRandomNumber() : super();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => false;
}
