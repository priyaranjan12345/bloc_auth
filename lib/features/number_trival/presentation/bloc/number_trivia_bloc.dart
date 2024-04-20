import 'package:bloc_auth/core/utils/input_converter.dart';
import 'package:bloc_auth/features/number_trival/domain/usecases/get_concrete_number_trivia.dart';
import 'package:bloc_auth/features/number_trival/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(const InitialNumberTriviaState()) {
    on<GetTriviaForConcreteNumber>((event, emit) {});

    on<GetTriviaForRandomNumber>((event, emit) {});
  }
}
