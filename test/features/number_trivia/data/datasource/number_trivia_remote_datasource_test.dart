import 'package:bloc_auth/core/error/custom_exceptions.dart';
import 'package:bloc_auth/features/number_trival/data/datasources/number_trivia_remote_datasource.dart';
import 'package:bloc_auth/features/number_trival/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late NumberTriviaRemoteDatasource remoteDatasource;
  late http.Client httpClient;

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  setUp(() {
    httpClient = MockHttpClient();
    remoteDatasource = NumberTriviaRemoteDatasourceImpl(
      httpClient: httpClient,
    );
  });

  void setUpMockHttpClientSuccess200() {
    when(() => httpClient.get(any())).thenAnswer(
      (_) async => http.Response(fixture("trivia_int.json"), 200),
    );
  }

  void setUpMockHttpClientFailure404() {
    when(() => httpClient.get(any())).thenAnswer(
      (_) async => http.Response("", 404),
    );
  }

  group('remote data source test', () {
    const tNumber = 42;
    const tNumberTriviaModel = NumberTriviaModel(text: "test-text", number: 1);
    test("should perform a GET request for concrete number", () async {
      // arrange
      setUpMockHttpClientSuccess200();

      // act
      final result = await remoteDatasource.getConcreteNumberTrivia(tNumber);

      // assert
      verify(() => httpClient.get(any())).called(1);
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        "perform a GET request for concrete number should throw ServerException on error status code",
        () async {
      // arrange
      setUpMockHttpClientFailure404();

      // act
      final call = remoteDatasource.getConcreteNumberTrivia;

      // assert
      expect(() async => await call(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });

    test("should perform a GET request for random number", () async {
      // arrange
      setUpMockHttpClientSuccess200();

      // act
      final result = await remoteDatasource.getRandomNumberTrivia();

      // assert
      verify(() => httpClient.get(any())).called(1);
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        "perform a GET request for random number should throw ServerException on error status code",
        () async {
      // arrange
      setUpMockHttpClientFailure404();

      // act
      final call = remoteDatasource.getRandomNumberTrivia;

      // assert
      expect(() async => await call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
