import 'package:dartz/dartz.dart';

import '../../../../core/error/custom_exceptions.dart';
import '../../../../core/error/failuer.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/datasources.dart';
import '../models/models.dart';

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
