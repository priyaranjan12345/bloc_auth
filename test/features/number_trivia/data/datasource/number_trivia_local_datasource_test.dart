import 'dart:convert';

import 'package:bloc_auth/core/error/custom_exceptions.dart';
import 'package:bloc_auth/features/number_trival/data/datasources/number_trivia_local_datasource.dart';
import 'package:bloc_auth/features/number_trival/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreference extends Mock implements SharedPreferences {}

void main() {
  late SharedPreferences sharedPreferences;
  late NumberTriviaLocalDatasource localDatasource;
  String cacheKey = "cache-data";

  setUp(() {
    sharedPreferences = MockSharedPreference();
    localDatasource = NumberTriviaLocalDatasourceImpl(
      sharedPreferences: sharedPreferences,
    );
  });

  group("getLastNumberTrivia", () {
    final fixtureString = fixture("trivia_cache.json");
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixtureString));

    test(
      "should return NumbeTrivia from SharedPreferences when there is one in the cache",
      () async {
        // arrange
        when(() => sharedPreferences.getString(cacheKey)).thenAnswer((_) => fixtureString);

        // act
        final result = await localDatasource.getLastNumberTrivia();

        // assert
        verify(() => sharedPreferences.getString(cacheKey));
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      "should return CacheException when there is not cached value",
      () async {
        // arrange
        when(() => sharedPreferences.getString(cacheKey)).thenAnswer((_) => null);

        // act
        final call = localDatasource.getLastNumberTrivia;

        // assert
        expect(() async => await call(), throwsA(const TypeMatcher<CacheException>()));
      },
    );
  });

  group("cache number trivia", () {
    const tNumberTriviaModel = NumberTriviaModel(text: "test-text", number: 1);
    test("should return void on save cache", () async {
      // arrange
      when(() => sharedPreferences.setString(cacheKey, any())).thenAnswer((_) async => true);

      // act
      await localDatasource.cacheNumberTrivia(tNumberTriviaModel);

      // assert
      verify(
        () => sharedPreferences.setString(
          cacheKey,
          json.encode(tNumberTriviaModel.toJson()),
        ),
      );
    });

    test("should throw CacheException when failed to save data", () async {
      // arrange
      when(() => sharedPreferences.setString(cacheKey, any())).thenAnswer((_) async => false);

      // act
      final call = localDatasource.cacheNumberTrivia;

      // assert
      expect(
          () async => await call(tNumberTriviaModel), throwsA(const TypeMatcher<CacheException>()));
    });
  });
}
