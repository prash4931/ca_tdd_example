import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'number_trivia_example_event.dart';
part 'number_trivia_example_state.dart';

class NumberTriviaExampleBloc extends Bloc<NumberTriviaExampleEvent, NumberTriviaExampleState> {
  NumberTriviaExampleBloc() : super(NumberTriviaExampleInitial()) {
    on<NumberTriviaExampleEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
