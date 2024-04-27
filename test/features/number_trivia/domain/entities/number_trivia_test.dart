import 'package:bloc_auth/features/number_trival/domain/entities/number_tivia.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NumberTrivia', () {
    test('should return true if two NumberTrivia objects are equal', () {
      const trivia1 = NumberTrivia(text: 'Test', number: 1);
      const trivia2 = NumberTrivia(text: 'Test', number: 1);

      expect(trivia1, equals(trivia2));
    });

    test('should return false if two NumberTrivia objects are not equal', () {
      const trivia1 = NumberTrivia(text: 'Test', number: 1);
      const trivia2 = NumberTrivia(text: 'Different Test', number: 2);

      expect(trivia1, isNot(equals(trivia2)));
    });
  });
}
