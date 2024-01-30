import 'package:bloc_auth/features/number_trival/domain/entities/number_tivia.dart';
import 'package:bloc_auth/features/number_trival/domain/repositories/number_trivia_repository.dart';
import 'package:bloc_auth/features/number_trival/domain/usecases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
// import 'package:mockito/mockito.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late MockNumberTriviaRepository mockNumberTriviaRepository;
  late GetConcreteNumberTrivia getConcreteNumberTrivia;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    getConcreteNumberTrivia = GetConcreteNumberTrivia(
      repository: mockNumberTriviaRepository,
    );
  });

  const tNumber = 1;
  const tNumberTrivia = NumberTrivia(text: "test", number: tNumber);
  test("should get trivia number from repository", () async {
    // arrange
    when(() => mockNumberTriviaRepository.getConcreteNumberTrivia(any()))
        .thenAnswer(
      (_) async => const Right(tNumberTrivia),
    );

    // act
    final result =
        await getConcreteNumberTrivia(const MyParams(number: tNumber));

    // assert
    expect(result, const Right(tNumberTrivia));
    verify(() => mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
  });
}
