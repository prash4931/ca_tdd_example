import 'dart:convert';

import 'package:ca_tdd_example/core/error/exception.dart';
import 'package:ca_tdd_example/features/number_trivia_example/data/models/number_trivia_model.dart';
import 'package:ca_tdd_example/utils/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Contract for the local data source responsible for caching and retrieving
/// number trivia.
abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was fetched the last time
  /// the user had an Internet Connection
  ///
  /// Throws [NoLocalDataException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  /// Cache Number Trivia when the internet connection is present.
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

/// Concrete class that implements [NumberTriviaLocalDataSource] abstract
/// class. This class uses [SharedPreferences] to cache and retrieve number
/// trivia.
class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  /// Instance of [SharedPreferences] for to cache and retrieve number
  /// trivia.
  final SharedPreferences sharedPreferences;

  /// Constructor that accepts an instance of [SharedPreferences]
  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    return sharedPreferences.setString(
      cachedNumberTrivia,
      json.encode(triviaToCache.toJson()),
    );
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(cachedNumberTrivia);
    if (jsonString != null) {
      return Future.value(
        NumberTriviaModel.fromJson(
          json.decode(jsonString) as Map<String, dynamic>,
        ),
      );
    } else {
      throw CacheException();
    }
  }
}
