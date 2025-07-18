import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'word_trivia_event.dart';
part 'word_trivia_state.dart';

class WordTriviaBloc extends Bloc<WordTriviaEvent, WordTriviaState> {
  WordTriviaBloc() : super(WordTriviaInitial()) {
    on<WordTriviaEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
