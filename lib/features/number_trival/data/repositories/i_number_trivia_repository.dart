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
    networkInfo.isConnected;
    return const Right(NumberTrivia(text: "text", number: 1));
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    networkInfo.isConnected;
    return const Right(NumberTrivia(text: "text", number: 1));
  }
}
