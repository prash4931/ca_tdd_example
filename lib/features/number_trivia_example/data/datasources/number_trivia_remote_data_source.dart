import 'dart:convert';

import 'package:ca_tdd_example/core/error/exception.dart';
import 'package:ca_tdd_example/features/number_trivia_example/data/models/number_trivia_model.dart';

import 'package:http/http.dart' as http;

/// Contract for the remote data source responsible for fetching number trivia
/// data.
abstract class NumberTriviaRemoteDataSource {
  /// Calls the https://numbersapi.com/{number} endpoint
  //
  /// Throws a [ServerException] for all error codes
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the https://numbersapi.com/random endpoint
  //
  /// Throws a [ServerException] for all error codes
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

/// Concrete class that implements [NumberTriviaRemoteDataSource] abstract
/// class. This class uses [http.Client] to retrieve number trivia from the API.
class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  /// The [http.Client] instance used for retrieving the number trivia from the API.
  final http.Client client;

  /// Constructor that accepts an instance of [http.Client] for making API
  /// requests.
  NumberTriviaRemoteDataSourceImpl({required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) =>
      _getTriviaFromUrl('http://numbersapi.com/$number');

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() =>
      _getTriviaFromUrl('http://numbersapi.com/random');

  Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
    final response = await client.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(
        json.decode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw ServerException();
    }
  }
}
