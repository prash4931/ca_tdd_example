import 'dart:convert';

import 'package:ca_tdd_example/core/error/exception.dart';
import 'package:ca_tdd_example/features/number_trivia_example/data/datasources/number_trivia_local_data_source.dart';
import 'package:ca_tdd_example/features/number_trivia_example/data/models/number_trivia_model.dart';
import 'package:ca_tdd_example/utils/app_strings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getLastNumberTrivia', () {
    final tNumberTrivia = NumberTriviaModel.fromJson(
      json.decode(readFixtureFromFileName('trivia_cached.json'))
          as Map<String, dynamic>,
    );
    test(
      'should return NumberTrivia from SharedPreferences when there is data in'
      'cache',
      () async {
        // Arrange
        when(() => mockSharedPreferences.getString(any())).thenReturn(null);

        // Act
        final call = dataSource.getLastNumberTrivia;

        // Assert
        expect(call, throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheNumberTrivia', () {
    const tNumberTriviaModel = NumberTriviaModel(
      text: 'Test trivia',
      number: 1,
    );

    test('should call SharedPreferences to cache the data', () async {
      // arrange
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());

      when(
        () => mockSharedPreferences.setString(any(), any()),
      ).thenAnswer((_) async => true);

      // act
      await dataSource.cacheNumberTrivia(tNumberTriviaModel);

      // assert
      verify(
        () => mockSharedPreferences.setString(
          cachedNumberTrivia,
          expectedJsonString,
        ),
      );
    });
  });
}
