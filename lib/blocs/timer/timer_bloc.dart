// ignore: unnecessary_this
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo/models/todo_model.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  Todo todo;
  TimerBloc copyWith({Todo todo}) {
    return TimerBloc(todo: todo ?? this.todo);
  }

  TimerBloc({this.todo}) : super(TimerInitial()) {
    on<TimerEvent>((event, emit) {
      // TODO: implement event handler
      if (event is StartTimerEvent) {
        Timer timer = Timer.periodic(Duration(seconds: 1), (timer) {
    
          if (this.todo?.timerRunning)
            this.add(TimerRunningEvent());
          else {
              timer?.cancel();
          }
        });
      } else if (event is ResumeTimerEvent) {
    
        Todo newTodo = Todo(
            timerRunning: true,
            title: this.todo.title,
            isPaused: false,
            status: "In Progress",
            duration: this.todo.duration,
            description: this.todo.description,
            displayString: this.todo.displayString,
            durationSeconds: this.todo.durationSeconds);
        this.todo = newTodo;
        this.add(StartTimerEvent());
      } else if (event is TimerRunningEvent) {
        if (this.todo != null &&
            this.todo.durationSeconds>0) {
          this.todo.durationSeconds -= 1;
          this.todo.displayString =
              (this.todo.durationSeconds / 60).toInt().toString() +
                  ":" +
                  (this.todo.durationSeconds % 60).toInt().toString();

          Todo newTodo = Todo(
              timerRunning: true,
              title: this.todo.title,
              isPaused: false,
              status: "In Progress",
              duration: this.todo.duration,
              description: this.todo.description,
              displayString: this.todo.displayString,
              durationSeconds: this.todo.durationSeconds);
          if (emit.isDone) this.todo = newTodo;
          emit(TimerRunningState(todo: newTodo));
        } else {
          Todo newTodo = Todo(
              timerRunning: false,
              title: this.todo.title,
              isCompleted: true,
              isPaused: true,
              status: "Done",
              duration: this.todo.duration,
              description: this.todo.description,
              displayString: this.todo.displayString,
              durationSeconds: this.todo.durationSeconds);
          this.todo = newTodo;

          emit(TimerInitial(todo: newTodo));
        }
      } else if (event is LoadTimerData) {
        if (state is TimerInitial) {
          emit(state.copyWith(newTodo: event.todo));
        } else {
          emit(TimerInitial(todo: event.todo));
        }
      } else if (event is PauseTimerEvent) {
        Todo newTodo = Todo(
            timerRunning: false,
            title: this.todo.title,
            isPaused: true,
            status: "In Progress",
            duration: this.todo.duration,
            description: this.todo.description,
            displayString: this.todo.displayString,
            durationSeconds: this.todo.durationSeconds);
        this.todo = newTodo;
        emit(TimerInitial(todo: newTodo));
      }
    });
  }
}
