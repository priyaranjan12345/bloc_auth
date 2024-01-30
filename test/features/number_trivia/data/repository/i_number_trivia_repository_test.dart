import 'package:bloc_auth/core/error/custom_exceptions.dart';
import 'package:bloc_auth/core/error/failuer.dart';
import 'package:bloc_auth/core/platform/network_info.dart';
import 'package:bloc_auth/features/number_trival/data/datasources/number_trivia_local_datasource.dart';
import 'package:bloc_auth/features/number_trival/data/datasources/number_trivia_remote_datasource.dart';
import 'package:bloc_auth/features/number_trival/data/models/number_trivia_model.dart';
import 'package:bloc_auth/features/number_trival/data/repositories/i_number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
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

  group("test get concrete number trivia", () {
    const tNumber = 1;
    const tNumberTriviaModel = NumberTriviaModel(
      text: "test-text",
      number: tNumber,
    );
    // const NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test("should check device is online", () async {
      // arrange
      when(
        () => mockNetworkInfo.isConnected,
      ).thenAnswer((_) async => true);

      when(
        () => mockRemoteDataSource.getConcreteNumberTrivia(any()),
      ).thenAnswer((_) async => tNumberTriviaModel);

      when(
        () => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel),
      ).thenAnswer((_) async {
        return;
      });

      // act
      await iNumberTriviaRepository.getConcreteNumberTrivia(tNumber);

      // assert
      verify(() => mockNetworkInfo.isConnected);
    });

    group("device is online ", () {
      setUp(() {
        when(
          () => mockNetworkInfo.isConnected,
        ).thenAnswer((_) async => true);
      });

      test(
        "should return remote data when the call to remote data source is successful",
        () async {
          // arrange
          when(
            () => mockRemoteDataSource.getConcreteNumberTrivia(any()),
          ).thenAnswer((_) async => tNumberTriviaModel);

          when(
            () => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel),
          ).thenAnswer((_) async {
            return;
          });

          // act
          final result =
              await iNumberTriviaRepository.getConcreteNumberTrivia(tNumber);

          // assert
          verify(
            () => mockRemoteDataSource.getConcreteNumberTrivia(tNumber),
          );
          expect(result, equals(const Right(tNumberTriviaModel)));
        },
      );

      test(
        "should return server failure when the call to remote data source is un-successful",
        () async {
          // arrange
          when(
            () => mockRemoteDataSource.getConcreteNumberTrivia(any()),
          ).thenThrow(ServerException());

          when(
            () => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel),
          ).thenAnswer((_) async {
            return;
          });

          // act
          final result =
              await iNumberTriviaRepository.getConcreteNumberTrivia(tNumber);

          // assert
          verify(
            () => mockRemoteDataSource.getConcreteNumberTrivia(tNumber),
          );
          expect(result, equals(Left(ServerFailure())));
        },
      );

      test(
        "should cache the data locally when the call to remote data source is successful",
        () async {
          // arrange
          when(
            () => mockRemoteDataSource.getConcreteNumberTrivia(any()),
          ).thenAnswer((_) async => tNumberTriviaModel);

          when(
            () => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel),
          ).thenAnswer((_) async {
            return;
          });

          // act
          await iNumberTriviaRepository.getConcreteNumberTrivia(tNumber);

          // assert
          verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verify(
              () => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );
    });

    group("device is offline ", () {
      setUp(() {
        when(
          () => mockNetworkInfo.isConnected,
        ).thenAnswer((_) async => false);
      });

      test(
        "should return last locally cached data when the cached data is present",
        () async {
          // arrange
          when(() => mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);

          // act
          final result =
              await iNumberTriviaRepository.getConcreteNumberTrivia(tNumber);

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(const Right(tNumberTriviaModel)));
        },
      );

      test(
        "should return cache failure when there is no cache data present",
        () async {
          // arrange
          when(() => mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());

          // act
          final result =
              await iNumberTriviaRepository.getConcreteNumberTrivia(tNumber);

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });

  group("test get random number trivia", () {});
}
