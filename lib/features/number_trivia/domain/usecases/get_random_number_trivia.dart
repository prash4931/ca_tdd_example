import 'package:ca_tdd_example/core/error/failures.dart';
import 'package:ca_tdd_example/core/usecase/usecase.dart';
import 'package:ca_tdd_example/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:ca_tdd_example/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(params) async {
    return await repository.getRandomNumberTrivia();
  }
}