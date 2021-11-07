import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo/handlers/local_storage_handler.dart';
import 'package:todo/models/todo_model.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitial()) {
    on<TodoEvent>((event, emit) async {
      if (event is LoadTodoDataEvent) {
        List<Todo> data = await LocalStorageHandler.getData();
        emit(TodoLoadedState(todoList: data));
      } else if (event is AddTodoEvent) {
        List<Todo> data = await LocalStorageHandler.addTodo(event.todo);
        emit(state.copyWith(
            todoList: data, message: "To Do added successfully"));
      }
      // TODO: implement event handler
    });
  }
}
