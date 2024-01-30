import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failuer.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/number_tivia.dart';
import '../repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, MyParams> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia({
    required this.repository,
  });

  @override
  Future<Either<Failure, NumberTrivia>> call(MyParams params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

class MyParams extends Equatable {
  final int number;

  const MyParams({
    required this.number,
  });

  @override
  List<Object> get props => [number];
}
