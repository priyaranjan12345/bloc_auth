import 'dart:convert';

import 'package:bloc_auth/features/number_trival/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: "test-text");

  test("number trivia model", () {
    // assert
    expect(tNumberTriviaModel, isA<NumberTriviaModel>());
    expect(
      tNumberTriviaModel,
      const NumberTriviaModel(number: 1, text: "test-text"),
    );
  });

  group("from json test", () {
    test("should return valid number trivia model from json", () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_int.json'));

      // act
      final result = NumberTriviaModel.fromJson(jsonMap);

      // assert
      expect(result, equals(tNumberTriviaModel));
    });

    test("should return valid number trivia model from json with double number",
        () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double.json'));

      // act
      final result = NumberTriviaModel.fromJson(jsonMap);

      // assert
      expect(result, equals(tNumberTriviaModel));
    });
  });

  group("to json test", () {
    test("", () async {
      // arrange

      // act
      final result = tNumberTriviaModel.toJson();

      // assert
      expect(result, {"text": "test-text", "number": 1});
    });
  });
}
