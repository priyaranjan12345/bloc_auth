import 'package:bloc_auth/core/error/custom_exceptions.dart';
import 'package:dartz/dartz.dart';

import 'package:bloc_auth/core/error/failuer.dart';
import 'package:bloc_auth/core/platform/network_info.dart';
import 'package:bloc_auth/features/number_trival/data/datasources/number_trivia_local_datasource.dart';
import 'package:bloc_auth/features/number_trival/data/datasources/number_trivia_remote_datasource.dart';
import 'package:bloc_auth/features/number_trival/domain/entities/number_tivia.dart';
import 'package:bloc_auth/features/number_trival/domain/repositories/number_trivia_repository.dart';

class INumberTriviaRepository implements NumberTriviaRepository {
  final NumberTriviaRemoteDatasource numberTriviaRemoteDatasource;
  final NumberTriviaLocalDatasource numberTriviaLocalDatasource;
  final NetworkInfo networkInfo;

  INumberTriviaRepository({
    required this.numberTriviaRemoteDatasource,
    required this.numberTriviaLocalDatasource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
    int number,
  ) async {
    final isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        final remoteConcreteTrivia =
            await numberTriviaRemoteDatasource.getConcreteNumberTrivia(number);
        await numberTriviaLocalDatasource
            .cacheNumberTrivia(remoteConcreteTrivia);
        return Right(remoteConcreteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localConcreteTrivia =
            await numberTriviaLocalDatasource.getLastNumberTrivia();
        return Right(localConcreteTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    await networkInfo.isConnected;
    final remoteRandomTrivia =
        await numberTriviaRemoteDatasource.getRandomNumberTrivia();
    await numberTriviaLocalDatasource.cacheNumberTrivia(remoteRandomTrivia);
    return Right(remoteRandomTrivia);
  }
}
