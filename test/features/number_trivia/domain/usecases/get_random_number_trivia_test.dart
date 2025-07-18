import 'package:ca_tdd_example/core/usecase/usecase.dart';
import 'package:ca_tdd_example/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:ca_tdd_example/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:ca_tdd_example/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:ca_tdd_example/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_concrete_number_trivia_test.mocks.dart';

// class MockNumberTriviaRepository extends Mock
//     implements NumberTriviaRepository {}

@GenerateMocks([NumberTriviaRepository])
void main() {
  late GetRandomNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  // final tNumber = 1;
  final tNumberTrivia = NumberTrivia(text: 'test', number: 1);

  test('should get trivia from the repository', () async {
    // Arrange
    when(
      mockNumberTriviaRepository.getRandomNumberTrivia(),
    ).thenAnswer((_) async => Right(tNumberTrivia));
    // Act
    final result = await usecase(NoParams());

    // Assert
    expect(result, Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
