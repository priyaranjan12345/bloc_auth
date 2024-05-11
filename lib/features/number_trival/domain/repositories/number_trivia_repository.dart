import 'package:dartz/dartz.dart';

import '../entities/entities.dart';
import '../../../../core/error/failuer.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}
