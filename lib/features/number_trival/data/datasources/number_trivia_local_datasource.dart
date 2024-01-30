import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDatasource {
  /// Get the cache [NumberTriviaModel] which gotten the last time.
  ///
  /// Throws a [NoLocalDataException] for all err codes.
  Future<NumberTriviaModel> getLastNumberTrivia();

  /// cache number trivia
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTriviaModel);
}
