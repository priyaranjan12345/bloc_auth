import 'package:bloc_auth/core/error/failuer.dart';
import 'package:bloc_auth/features/number_trival/domain/entities/number_tivia.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
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
  late MockConcreteNumberTrivia getConcreteNumberTrivia;
  late MockRandomNumberTrivia getRandomNumberTrivia;
  late MockInputConverter inputConverter;

  late NumberTriviaBloc numberTriviaBloc;

  const tNumberString = '1';
  const tNumberParsed = 1;

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

  group("GetTriviaForConcreteNumber", () {
    const tNumberTrivia = NumberTrivia(text: 'test number ext', number: 2);
    test(
        "should call the input converter to validate and convert the string to an unsigned",
        () async {
      // arrange
      when(
        () => inputConverter.stringToUnsignedInteger(any()),
      ).thenReturn(
        const Right(tNumberParsed),
      );

      when(
        () => getConcreteNumberTrivia(const Params(number: tNumberParsed)),
      ).thenAnswer(
        (invocation) async => const Right(tNumberTrivia),
      );

      // act
      numberTriviaBloc.add(
        GetConcreteNumberTriviaEvent(numberString: tNumberString),
      );
      // important: wait till method called
      await untilCalled(() => inputConverter.stringToUnsignedInteger(any()));

      // assert
      verify(() => inputConverter.stringToUnsignedInteger(tNumberString));
    });

    test("should emit [Error] when input is invalid", () async {
      // arrange
      when(
        () => inputConverter.stringToUnsignedInteger(any()),
      ).thenReturn(
        Left(InvalidInputFailure()),
      );

      // act
      numberTriviaBloc.add(
        GetConcreteNumberTriviaEvent(numberString: tNumberString),
      );
      await untilCalled(() => inputConverter.stringToUnsignedInteger(any()));

      // assert
      verify(() => inputConverter.stringToUnsignedInteger(tNumberString));
      expect(
        numberTriviaBloc.state,
        const ErrorNumberTriviaState(errMsg: 'Invalid input'),
      );
    });

    test("should emit [loading, loaded] state when data is gotten successfully",
        () async {
      // arrange
      when(
        () => inputConverter.stringToUnsignedInteger(any()),
      ).thenReturn(
        const Right(tNumberParsed),
      );

      when(
        () => getConcreteNumberTrivia(const Params(number: tNumberParsed)),
      ).thenAnswer(
        (invocation) async => const Right(tNumberTrivia),
      );

      final expected = [
        const LoadingNumberTriviaState(),
        const LoadedNumberTriviaState(trivia: tNumberTrivia),
      ];

      // assert
      expectLater(numberTriviaBloc.stream, emitsInOrder(expected));

      // act
      numberTriviaBloc.add(
        GetConcreteNumberTriviaEvent(numberString: tNumberString),
      );
    });

    test(
      'should emit [loading, error] state when data is gotten failure',
      () {
        // arrange
        when(
          () => inputConverter.stringToUnsignedInteger(any()),
        ).thenReturn(Left(InvalidInputFailure()));

        when(
          () => getConcreteNumberTrivia(const Params(number: tNumberParsed)),
        ).thenAnswer(
          (invocation) async => const Right(tNumberTrivia),
        );

        final expected = [
          const LoadingNumberTriviaState(),
          const ErrorNumberTriviaState(errMsg: 'Invalid input'),
        ];

        // assert
        expectLater(numberTriviaBloc.stream, emitsInOrder(expected));

        // act
        numberTriviaBloc.add(
          GetConcreteNumberTriviaEvent(numberString: tNumberString),
        );
      },
    );

    test(
        'should emit [loading, serverError] state, on server error but valid input number string',
        () {
      // arrange
      when(
        () => inputConverter.stringToUnsignedInteger(any()),
      ).thenReturn(
        const Right(tNumberParsed),
      );

      when(
        () => getConcreteNumberTrivia(const Params(number: tNumberParsed)),
      ).thenAnswer(
        (invocation) async => Left(ServerFailure()),
      );

      final expected = [
        const LoadingNumberTriviaState(),
        const ErrorNumberTriviaState(errMsg: 'Server error'),
      ];

      // assert
      expectLater(numberTriviaBloc.stream, emitsInOrder(expected));

      // act
      numberTriviaBloc.add(
        GetConcreteNumberTriviaEvent(numberString: tNumberString),
      );
    });
  });

  group('test GetRandomNumberTrivia', () {
    const tNumberTrivia = NumberTrivia(
      text: 'test random number trivia',
      number: 1,
    );
    test('should emits [loading, loaded] stete on server success', () {
      // arrange
      when(
        () => getRandomNumberTrivia(NoParams()),
      ).thenAnswer(
        (invocation) async => const Right(tNumberTrivia),
      );

      // assert
      final expected = [
        const LoadingNumberTriviaState(),
        const LoadedNumberTriviaState(trivia: tNumberTrivia),
      ];

      expectLater(numberTriviaBloc.stream, emitsInOrder(expected));

      // act
      numberTriviaBloc.add(GetRandomNumberTriviaEvent());
    });
    test('should emits [loading, error] stete on server success', () {
      // arrange
      when(
        () => getRandomNumberTrivia(NoParams()),
      ).thenAnswer(
        (invocation) async => Left(ServerFailure()),
      );

      // assert
      final expected = [
        const LoadingNumberTriviaState(),
        const ErrorNumberTriviaState(errMsg: 'Server error'),
      ];

      expectLater(numberTriviaBloc.stream, emitsInOrder(expected));

      // act
      numberTriviaBloc.add(GetRandomNumberTriviaEvent());
    });
  });

  group(
      "test number trivia bloc for concrete number trivia - with bloc test - ",
      () {
    const tNumberTrivia = NumberTrivia(text: 'test number', number: 1);
    // const tNumberTriviaExt = NumberTrivia(text: 'test number ext', number: 2);

    blocTest(
      "test intial state",
      build: () => NumberTriviaBloc(
        getConcreteNumberTrivia: getConcreteNumberTrivia,
        getRandomNumberTrivia: getRandomNumberTrivia,
        inputConverter: inputConverter,
      ),
      expect: () => <NumberTriviaState>[],
    );

    blocTest(
      "test invalid input",
      setUp: () {
        when(
          () => inputConverter.stringToUnsignedInteger(any()),
        ).thenReturn(
          Left(InvalidInputFailure()),
        );
      },
      build: () => NumberTriviaBloc(
        getConcreteNumberTrivia: getConcreteNumberTrivia,
        getRandomNumberTrivia: getRandomNumberTrivia,
        inputConverter: inputConverter,
      ),
      act: (bloc) => bloc.add(
        GetConcreteNumberTriviaEvent(numberString: tNumberString),
      ),
      expect: () => <NumberTriviaState>[
        const LoadingNumberTriviaState(),
        const ErrorNumberTriviaState(errMsg: 'Invalid input'),
      ],
    );

    blocTest(
      "test emit concrete number trvia",
      setUp: () {
        when(
          () => inputConverter.stringToUnsignedInteger(any()),
        ).thenReturn(
          const Right(tNumberParsed),
        );

        when(
          () => getConcreteNumberTrivia(const Params(number: tNumberParsed)),
        ).thenAnswer((invocation) async => const Right(tNumberTrivia));
      },
      build: () => NumberTriviaBloc(
        getConcreteNumberTrivia: getConcreteNumberTrivia,
        getRandomNumberTrivia: getRandomNumberTrivia,
        inputConverter: inputConverter,
      ),
      act: (bloc) => bloc.add(
        GetConcreteNumberTriviaEvent(numberString: tNumberString),
      ),
      expect: () => <NumberTriviaState>[
        const LoadingNumberTriviaState(),
        const LoadedNumberTriviaState(trivia: tNumberTrivia),
      ],
      verify: (bloc) => getConcreteNumberTrivia(
        const Params(number: tNumberParsed),
      ),
    );
  });

  group('test numberTriviaBloc for randomNumberTrivia - with blic test', () {
    const tNumberTrivia = NumberTrivia(text: 'test number ext', number: 2);
    blocTest(
      "should emits [intial] state",
      build: () => NumberTriviaBloc(
        getConcreteNumberTrivia: getConcreteNumberTrivia,
        getRandomNumberTrivia: getRandomNumberTrivia,
        inputConverter: inputConverter,
      ),
      expect: () => <NumberTriviaState>[],
    );

    blocTest(
      "should emits [loading, loaded] state",
      setUp: () => when(
        () => getRandomNumberTrivia(NoParams()),
      ).thenAnswer((invocation) async => const Right(tNumberTrivia)),
      build: () => NumberTriviaBloc(
        getConcreteNumberTrivia: getConcreteNumberTrivia,
        getRandomNumberTrivia: getRandomNumberTrivia,
        inputConverter: inputConverter,
      ),
      act: (bloc) => bloc.add(
        GetRandomNumberTriviaEvent(),
      ),
      expect: () => <NumberTriviaState>[
        const LoadingNumberTriviaState(),
        const LoadedNumberTriviaState(trivia: tNumberTrivia),
      ],
    );

    blocTest(
      "should emits [loading, error] state",
      setUp: () => when(
        () => getRandomNumberTrivia(NoParams()),
      ).thenAnswer((invocation) async =>Left(ServerFailure())),
      build: () => NumberTriviaBloc(
        getConcreteNumberTrivia: getConcreteNumberTrivia,
        getRandomNumberTrivia: getRandomNumberTrivia,
        inputConverter: inputConverter,
      ),
      act: (bloc) => bloc.add(
        GetRandomNumberTriviaEvent(),
      ),
      expect: () => <NumberTriviaState>[
        const LoadingNumberTriviaState(),
        const ErrorNumberTriviaState(errMsg: 'Server error'),
      ],
    );
  });
}
