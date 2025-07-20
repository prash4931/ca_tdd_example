import 'dart:convert';

import 'package:ca_tdd_example/features/number_trivia_example/data/models/number_trivia_model.dart';
import 'package:ca_tdd_example/features/number_trivia_example/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(text: 'Test text', number: 1);

  test('should be a subclass of NumberTrivia Entity', () {
    // Assert
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON number is an integer', () {
      // Arrange
      final jsonMap =
          json.decode(readFixtureFromFileName('trivia.json'))
              as Map<String, dynamic>;

      // Act
      final result = NumberTriviaModel.fromJson(jsonMap);

      // Assert
      expect(result, tNumberTriviaModel);
    });

    test('Should return a valid Model when the JSON number is a double', () {
      // Arrange
      final jsonMap =
          json.decode(readFixtureFromFileName('trivia_double.json'))
              as Map<String, dynamic>;

      // Act
      final result = NumberTriviaModel.fromJson(jsonMap);

      // Assert
      expect(result, tNumberTriviaModel);
    });
  });

  group('toJson', () {
    test('Should return a JSON Map containing the proper data', () {
      // Act
      final result = tNumberTriviaModel.toJson();

      // Assert
      final expectedMap = {'text': 'Test text', 'number': 1};

      // Assert
      expect(result, expectedMap);
    });
  });
}
