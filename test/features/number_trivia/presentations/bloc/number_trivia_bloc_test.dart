import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:bloc_auth/core/utils/input_converter.dart';
import 'package:bloc_auth/features/number_trival/presentation/bloc/bloc.dart';
import 'package:bloc_auth/features/number_trival/domain/usecases/get_concrete_number_trivia.dart';
import 'package:bloc_auth/features/number_trival/domain/usecases/get_random_number_trivia.dart';

class MockConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late GetConcreteNumberTrivia getConcreteNumberTrivia;
  late GetRandomNumberTrivia getRandomNumberTrivia;
  late InputConverter inputConverter;

  late NumberTriviaBloc numberTriviaBloc;

  setUp(() {
    getConcreteNumberTrivia = MockConcreteNumberTrivia();
    getRandomNumberTrivia = MockRandomNumberTrivia();
    inputConverter = MockInputConverter();

    numberTriviaBloc = NumberTriviaBloc(
      getConcreteNumberTrivia: getConcreteNumberTrivia,
      getRandomNumberTrivia: getRandomNumberTrivia,
      inputConverter: inputConverter,
    );
  });

  group("number trivia bloc test", () {
    test("- check initial state", () {
      // assert
      expect(numberTriviaBloc.state, equals(const InitialNumberTriviaState()));
    });
  });
}
