import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failuer.dart';
import '../../../../core/utils/input_converter.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';
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
    on<GetConcreteNumberTriviaEvent>((event, emit) async {
      /// loading...
      emit(const LoadingNumberTriviaState());

      /// evaluate result
      final result = inputConverter.stringToUnsignedInteger(event.numberString);

      await result.fold((failure) {
        emit(ErrorNumberTriviaState(errMsg: _mapFailureToMessage(failure)));
      }, (number) async {
        final concreteNumberTrivia = await getConcreteNumberTrivia(
          Params(number: number),
        );
        _emitState(concreteNumberTrivia, emit);
      });
    });

    /// Random Number Trivia
    on<GetRandomNumberTriviaEvent>((event, emit) async {
      /// loading...
      emit(const LoadingNumberTriviaState());

      /// evaluate result
      final randomNumberTrivia = await getRandomNumberTrivia(NoParams());
      _emitState(randomNumberTrivia, emit);
    });
  }

  void _emitState(
    Either<Failure, NumberTrivia> numberTriviaResult,
    Emitter<NumberTriviaState> emit,
  ) {
    numberTriviaResult.fold(
      (failure) => emit(
        ErrorNumberTriviaState(errMsg: _mapFailureToMessage(failure)),
      ),
      (numberTrivia) => emit(
        LoadedNumberTriviaState(trivia: numberTrivia),
      ),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error';

      case CacheFailure:
        return 'Cache error';

      case InvalidInputFailure:
        return 'Invalid input';

      default:
        return 'Unexpected error';
    }
  }
}
