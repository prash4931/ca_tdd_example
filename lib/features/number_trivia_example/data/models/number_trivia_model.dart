import 'package:ca_tdd_example/features/number_trivia_example/domain/entities/number_trivia.dart';

// A model representing number trivia, extending [NumberTrivia]
class NumberTriviaModel extends NumberTrivia {
  // Creates a [NumberTriviaModel] with [text] and [number]
  const NumberTriviaModel({required super.text, required super.number});

  // Creates a [NumberTriviaModel] from JSON.
  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) =>
      NumberTriviaModel(
        text: json['text'] as String,
        // The num type can be both a 'double' and an 'int'
        number: (json['number'] as num).toInt(),
      );

  // Converts this model to JSON
  Map<String, dynamic> toJson() => {'text': text, 'number': number};
}
