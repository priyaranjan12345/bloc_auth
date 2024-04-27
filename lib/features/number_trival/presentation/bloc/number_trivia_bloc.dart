import 'package:bloc_auth/core/error/failuer.dart';
import 'package:bloc_auth/core/utils/input_converter.dart';
import 'package:bloc_auth/features/number_trival/domain/entities/number_tivia.dart';
import 'package:bloc_auth/features/number_trival/domain/usecases/get_concrete_number_trivia.dart';
import 'package:bloc_auth/features/number_trival/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
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
    /// Concrete Number Trivia
    on<GetConcreteNumberTriviaEvent>((event, emit) {
      final result = inputConverter.stringToUnsignedInteger(event.numberString);
      result.fold((failure) {
        emit(const ErrorNumberTriviaState(errMsg: 'Invalid input'));
      }, (number) async {
        final concreteNumberTrivia = await getConcreteNumberTrivia(
          MyParams(number: number),
        );
        emitState(concreteNumberTrivia, emit);
      });
    });

    /// Random Number Trivia
    on<GetRandomNumberTriviaEvent>((event, emit) async {
      final randomNumberTrivia = await getRandomNumberTrivia(NoParams());
      emitState(randomNumberTrivia, emit);
    });
  }

  void emitState(
    Either<Failure, NumberTrivia> numberTriviaResult,
    Emitter<NumberTriviaState> emit,
  ) {
    numberTriviaResult.fold(
      (failure) => emit(
        const ErrorNumberTriviaState(errMsg: 'Failed to get data'),
      ),
      (numberTrivia) => emit(
        LoadedNumberTriviaState(trivia: numberTrivia),
      ),
    );
  }
}
