import 'dart:convert';

import 'package:ca_tdd_example/core/error/exception.dart';
import 'package:ca_tdd_example/features/number_trivia_example/data/datasources/number_trivia_remote_data_source.dart';
import 'package:ca_tdd_example/features/number_trivia_example/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200(Uri url) {
    when(
      () => mockHttpClient.get(url, headers: any(named: 'headers')),
    ).thenAnswer(
      (_) async => http.Response(readFixtureFromFileName('trivia.json'), 200),
    );
  }

  void setUpMockHttpClientFailure404(Uri url) {
    when(
      () => mockHttpClient.get(url, headers: any(named: 'headers')),
    ).thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
      json.decode(readFixtureFromFileName('trivia.json'))
          as Map<String, dynamic>,
    );
    final url = Uri.parse('http://numbersapi.com/$tNumber');

    test('should perform a GET request on a URL with number'
        'being the endpoint and with application/json header', () async {
      // arrange
      when(
        () => mockHttpClient.get(url, headers: any(named: 'headers')),
      ).thenAnswer(
        (_) async => http.Response(readFixtureFromFileName('trivia.json'), 200),
      );

      // act
      await dataSource.getConcreteNumberTrivia(tNumber);

      // assert
      verify(
        () => mockHttpClient.get(
          url,
          headers: {'Content-Type': 'application/json'},
        ),
      );
    });

    test(
      'should return NumberTrivia when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200(url);

        // act
        final result = await dataSource.getConcreteNumberTrivia(tNumber);

        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404(url);

        // act
        final call = dataSource.getConcreteNumberTrivia;

        // assert
        expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
      json.decode(readFixtureFromFileName('trivia.json'))
          as Map<String, dynamic>,
    );
    final url = Uri.parse('http://numbersapi.com/random');

    test('should perform a GET request on a URL with number'
        'being the endpoint and with application/json header', () async {
      // arrange
      when(
        () => mockHttpClient.get(url, headers: any(named: 'headers')),
      ).thenAnswer(
        (_) async => http.Response(readFixtureFromFileName('trivia.json'), 200),
      );

      // act
      await dataSource.getRandomNumberTrivia();

      // assert
      verify(
        () => mockHttpClient.get(
          url,
          headers: {'Content-Type': 'application/json'},
        ),
      );
    });

    test(
      'should return NumberTrivia when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200(url);

        // act
        final result = await dataSource.getRandomNumberTrivia();

        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404(url);

        // act
        final call = dataSource.getRandomNumberTrivia;

        // assert
        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
