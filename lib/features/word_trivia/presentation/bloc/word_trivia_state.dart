part of 'word_trivia_bloc.dart';

abstract class WordTriviaState extends Equatable {
  const WordTriviaState();  

  @override
  List<Object> get props => [];
}
class WordTriviaInitial extends WordTriviaState {}
