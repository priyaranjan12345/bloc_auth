import 'package:bloc_auth/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockDataConnectionChecker mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(
      connectionChecker: mockDataConnectionChecker,
    );
  });

  group("is connected", () {
    test("should forward the call to DataConnectionChecker.hasConnection",
        () async {
      // arrange
      const tHasConnection = true;
      when(
        () => mockDataConnectionChecker.hasConnection,
      ).thenAnswer((_) async => tHasConnection);

      // act
      final result = await networkInfoImpl.isConnected;

      // assert
      verify(() => mockDataConnectionChecker.hasConnection);
      expect(result, tHasConnection);
    });
  });
}
