import 'package:ca_tdd_example/core/error/failures.dart';
import 'package:ca_tdd_example/core/usecase/usecase.dart';
import 'package:ca_tdd_example/features/number_trivia_example/domain/entities/number_trivia.dart';
import 'package:ca_tdd_example/features/number_trivia_example/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;

  const Params({required this.number});

  @override
  List<Object?> get props => [number];
}
