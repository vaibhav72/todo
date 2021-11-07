part of 'timer_bloc.dart';

abstract class TimerState extends Equatable {
  Todo todo;
  TimerState({this.todo});
  TimerState copyWith({Todo newTodo}) {
    return TimerInitial(todo: newTodo ?? this.todo);
  }

  @override
  List<Object> get props => [todo];
}

class TimerInitial extends TimerState {
  TimerInitial({Todo todo}) : super(todo: todo);
  TimerInitial copyWith({Todo newTodo}) {
    return TimerInitial(todo: newTodo ?? this.todo);
  }
}

class TimerRunningState extends TimerState {
  TimerRunningState({Todo todo}) : super(todo: todo);
  @override
  TimerRunningState copyWith({Todo newTodo}) {
    return TimerRunningState(todo: newTodo ?? this.todo);
  }
}

class TimerCompleteState extends TimerState {
  TimerCompleteState({Todo todo}) : super(todo: todo);
  TimerCompleteState copyWith({Todo newTodo}) {
    return TimerCompleteState(todo: newTodo ?? this.todo);
  }
}
