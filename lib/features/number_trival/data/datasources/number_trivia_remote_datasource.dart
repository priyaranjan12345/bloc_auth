import '../models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDatasource {
  /// calls the `http://numbersapi.com/{number}?json` endpoint
  ///
  /// throws a [ServerException] for all err codes
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// calls the `http://numbersapi.com/random?json` endpoint
  ///
  /// throws a [ServerException] for all err codes
  Future<NumberTriviaModel> getRandomNumberTrivia();
}
