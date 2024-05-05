import 'package:bloc_auth/core/utils/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group("stringToUnsignedInt", () {
    test("should return int when string represents a unsigned integer", () async {
      // arrange
      const str = '123';

      // act
      final result = inputConverter.stringToUnsignedInteger(str);

      // assert
      expect(result, const Right(123));
    });

    test("should return failure when string represents not a unsigned integer", () async {
      // arrange
      const str = 'abc';

      // act
      final result = inputConverter.stringToUnsignedInteger(str);

      // assert
      expect(result, Left(InvalidInputFailure()));
    });

    test("should return failure when string represents not a -ve integer", () async {
      // arrange
      const str = '-123';

      // act
      final result = inputConverter.stringToUnsignedInteger(str);

      // assert
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
