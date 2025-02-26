import 'package:bloc_auth/features/number_trival/domain/entities/number_tivia.dart';
import 'package:bloc_auth/features/number_trival/domain/repositories/number_trivia_repository.dart';
import 'package:bloc_auth/features/number_trival/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository {}

void main() {
  late GetRandomNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(repository: mockNumberTriviaRepository);
  });

  const tNumberTrivia = NumberTrivia(text: "Random Number", number: 1);

  test("should get random trivia from the repository", () async {
    // arrange
    when(() => mockNumberTriviaRepository.getRandomNumberTrivia()).thenAnswer(
      (_) async => const Right(tNumberTrivia),
    );

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, const Right<dynamic, NumberTrivia>(tNumberTrivia));
    verify(() => mockNumberTriviaRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
