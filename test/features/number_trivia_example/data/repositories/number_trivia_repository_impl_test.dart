import 'package:ca_tdd_example/core/error/exception.dart';
import 'package:ca_tdd_example/core/error/failures.dart';
import 'package:ca_tdd_example/core/network/network_info.dart';
import 'package:ca_tdd_example/features/number_trivia_example/data/datasources/number_trivia_local_data_source.dart';
import 'package:ca_tdd_example/features/number_trivia_example/data/datasources/number_trivia_remote_data_source.dart';
import 'package:ca_tdd_example/features/number_trivia_example/data/models/number_trivia_model.dart';
import 'package:ca_tdd_example/features/number_trivia_example/data/repositories/number_trivia_repository_impl.dart';
import 'package:ca_tdd_example/features/number_trivia_example/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
    });
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(
      text: 'Test Trivia',
      number: tNumber,
    );
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if the device is online', () {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockRemoteDataSource.getConcreteNumberTrivia(tNumber),
      ).thenAnswer((_) async => tNumberTriviaModel);
      when(
        () => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel),
      ).thenAnswer((_) async => {});
      // Act
      repository.getConcreteNumberTrivia(tNumber);
      // Assert
      verify(() => mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test('should return remote data when the call to remote data source is'
          'succesful', () async {
        // arrange
        when(
          () => mockRemoteDataSource.getConcreteNumberTrivia(any()),
        ).thenAnswer((_) async => tNumberTriviaModel);
        when(
          () => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel),
        ).thenAnswer((_) async {});

        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);

        // assert
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(Right(tNumberTrivia)));
      });

      test(
        'should cache the data locally when the call to remote data source is'
        'succesful',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getConcreteNumberTrivia(any()),
          ).thenAnswer((_) async => tNumberTriviaModel);
          when(
            () => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel),
          ).thenAnswer((_) async {});

          // Act
          await repository.getConcreteNumberTrivia(tNumber);

          // Assert
          verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verify(
            () => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel),
          );
        },
      );

      test('should return server failure when the call to remote data source is'
          'unsuccessful', () async {
        // arrange
        when(
          () => mockRemoteDataSource.getConcreteNumberTrivia(any()),
        ).thenThrow(ServerException());

        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);

        // assert
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(MockLocalDataSource());
        expect(result, Left(ServerFailure()));
      });
    });

    runTestsOffline(() {
      test('should return last locally cached data when the cached data is'
          'present', () async {
        // arrange
        when(
          () => mockLocalDataSource.getLastNumberTrivia(),
        ).thenAnswer((_) async => tNumberTriviaModel);

        // act
        final result = repository.getConcreteNumberTrivia(tNumber);

        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        expect(result, Right(tNumberTriviaModel));
      });

      test(
        'should return CacheFailure when no cached data is present',
        () async {
          // arrange
          when(
            () => mockLocalDataSource.getLastNumberTrivia(),
          ).thenThrow(CacheException());
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);

          // verify
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastNumberTrivia());
          expect(result, Left(CacheFailure()));
        },
      );
    });
  });

  group('getRandomNumberTrivia', () {
    const tNumberTriviaModel = NumberTriviaModel(
      text: 'test trivia',
      number: 1,
    );
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if the device is online', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockRemoteDataSource.getRandomNumberTrivia(),
      ).thenAnswer((_) async => tNumberTriviaModel);
      when(
        () => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel),
      ).thenAnswer((_) async {});

      // act
      await repository.getRandomNumberTrivia();

      // assert
      verify(() => mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test('should return remote data when the call to remote data source is'
          'successful', () async {
        // arrange
        when(
          () => mockRemoteDataSource.getRandomNumberTrivia(),
        ).thenAnswer((_) async => tNumberTriviaModel);
        when(
          () => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel),
        ).thenAnswer((_) async {});

        // act
        final result = await repository.getRandomNumberTrivia();

        // assert
        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test(
        'should cache the data locally when the call to remote data source is'
        'successful',
        () async {
          // arrange
          when(
            () => mockRemoteDataSource.getRandomNumberTrivia(),
          ).thenAnswer((_) async => tNumberTriviaModel);
          when(
            () => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel),
          ).thenAnswer((_) async {});

          // act
          await repository.getRandomNumberTrivia();

          // verify
          verify(() => mockRemoteDataSource.getRandomNumberTrivia());
          verify(
            () => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel),
          );
        },
      );

      test('should return server failure when the call to remote data source is'
          'unsuccessful', () async {
        // arrange
        when(
          () => mockRemoteDataSource.getRandomNumberTrivia(),
        ).thenThrow(ServerException());

        // act
        final result = await repository.getRandomNumberTrivia();

        // verify, expect
        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(MockLocalDataSource());
        expect(result, Left(ServerFailure()));
      });
    });

    runTestsOffline(() {
      test('should return last locally cached data when the cached data is'
          'present', () async {
        // arrange
        when(
          () => mockLocalDataSource.getLastNumberTrivia(),
        ).thenAnswer((_) async => tNumberTriviaModel);

        // act
        final result = repository.getRandomNumberTrivia();

        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        expect(result, Right(tNumberTriviaModel));
      });

      test(
        'should return CacheFailure when no cached data is present',
        () async {
          // arrange
          when(
            () => mockLocalDataSource.getLastNumberTrivia(),
          ).thenThrow(CacheException());
          // act
          final result = await repository.getRandomNumberTrivia();

          // verify
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastNumberTrivia());
          expect(result, Left(CacheFailure()));
        },
      );
    });
  });
}
