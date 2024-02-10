import 'package:bloc_auth/core/error/custom_exceptions.dart';
import 'package:bloc_auth/features/number_trival/data/models/number_trivia_model.dart';
import 'package:dartz/dartz.dart';

import 'package:bloc_auth/core/error/failuer.dart';
import 'package:bloc_auth/core/network/network_info.dart';
import 'package:bloc_auth/features/number_trival/data/datasources/number_trivia_local_datasource.dart';
import 'package:bloc_auth/features/number_trival/data/datasources/number_trivia_remote_datasource.dart';
import 'package:bloc_auth/features/number_trival/domain/entities/number_tivia.dart';
import 'package:bloc_auth/features/number_trival/domain/repositories/number_trivia_repository.dart';

typedef _ConcreateOrRandomChooser = Future<NumberTriviaModel> Function();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDatasource numberTriviaRemoteDatasource;
  final NumberTriviaLocalDatasource numberTriviaLocalDatasource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.numberTriviaRemoteDatasource,
    required this.numberTriviaLocalDatasource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
    int number,
  ) async {
    return await _getNumberTrivia(
      () => numberTriviaRemoteDatasource.getConcreteNumberTrivia(number),
    );
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getNumberTrivia(
      () => numberTriviaRemoteDatasource.getRandomNumberTrivia(),
    );
  }

  Future<Either<Failure, NumberTrivia>> _getNumberTrivia(
    _ConcreateOrRandomChooser getConcreteOrRandom,
  ) async {
    final isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        final remoteRandomTrivia = await getConcreteOrRandom();
        await numberTriviaLocalDatasource.cacheNumberTrivia(remoteRandomTrivia);
        return Right(remoteRandomTrivia);
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
}
