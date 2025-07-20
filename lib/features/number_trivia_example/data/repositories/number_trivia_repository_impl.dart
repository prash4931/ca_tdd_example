import 'package:ca_tdd_example/core/error/exception.dart';
import 'package:ca_tdd_example/core/error/failures.dart';
import 'package:ca_tdd_example/core/network/network_info.dart';
import 'package:ca_tdd_example/features/number_trivia_example/data/datasources/number_trivia_local_data_source.dart';
import 'package:ca_tdd_example/features/number_trivia_example/data/datasources/number_trivia_remote_data_source.dart';
import 'package:ca_tdd_example/features/number_trivia_example/data/models/number_trivia_model.dart';
import 'package:ca_tdd_example/features/number_trivia_example/domain/entities/number_trivia.dart';
import 'package:ca_tdd_example/features/number_trivia_example/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

typedef _ConcreteOrRandomChooser = Future<NumberTrivia> Function();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
    int number,
  ) async => _getTrivia(() => remoteDataSource.getConcreteNumberTrivia(number));

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async =>
      _getTrivia(() => remoteDataSource.getRandomNumberTrivia());

  /// Fetches trivia from the remote or local data source based on network
  /// connectivity
  Future<Either<Failure, NumberTrivia>> _getTrivia(
    _ConcreteOrRandomChooser getConcreteOrRandom,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        await localDataSource.cacheNumberTrivia(
          remoteTrivia as NumberTriviaModel,
        );
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localData = await localDataSource.getLastNumberTrivia();
        return Right(localData);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
