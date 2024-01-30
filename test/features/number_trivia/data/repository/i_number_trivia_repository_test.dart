import 'package:bloc_auth/core/platform/network_info.dart';
import 'package:bloc_auth/features/number_trival/data/datasources/number_trivia_local_datasource.dart';
import 'package:bloc_auth/features/number_trival/data/datasources/number_trivia_remote_datasource.dart';
import 'package:bloc_auth/features/number_trival/data/models/number_trivia_model.dart';
import 'package:bloc_auth/features/number_trival/data/repositories/i_number_trivia_repository.dart';
import 'package:bloc_auth/features/number_trival/domain/entities/number_tivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDatasource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDatasource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late INumberTriviaRepository iNumberTriviaRepository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    iNumberTriviaRepository = INumberTriviaRepository(
      numberTriviaRemoteDatasource: mockRemoteDataSource,
      numberTriviaLocalDatasource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group("get concrete number trivia", () {
    const tNumber = 1;
    const tNumberTriviaModel = NumberTriviaModel(
      text: "test-text",
      number: tNumber,
    );
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test("should check device is online", () async {
      // arrange
      when(
        () => mockNetworkInfo.isConnected,
      ).thenAnswer((_) async => true);

      // act
      final result =
          await iNumberTriviaRepository.getConcreteNumberTrivia(tNumber);

      // assert
      verify(() => mockNetworkInfo.isConnected);
    });

    group("device is online ", () {
      setUp(() {
        // arrange
        when(
          () => mockNetworkInfo.isConnected,
        ).thenAnswer((_) async => true);
      });

      test(
        "should return remote data when the call to remote data source is successful",
        () async {},
      );
    });

    group("device is offline ", () {
      setUp(() {
        // arrange
        when(
          () => mockNetworkInfo.isConnected,
        ).thenAnswer((_) async => false);
      });
    });
  });
}
