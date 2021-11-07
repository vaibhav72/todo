part of 'todo_bloc.dart';

abstract class TodoState extends Equatable {
  List<Todo> todoList;
  String message;
  TodoState({this.todoList, this.message});
  TodoState copyWith({List<Todo> todoList, String message}) {
    return TodoLoadedState(
        todoList: todoList ?? this.todoList, message: message);
  }

  @override
  List<Object> get props => [todoList];
}

class TodoInitial extends TodoState {
  TodoInitial({List<Todo> todo}) : super(todoList: todo);
}

class TodoLoading extends TodoState {}

class TodoLoadedState extends TodoState {
  TodoLoadedState({List<Todo> todoList, String message})
      : super(todoList: todoList, message: message);
  TodoLoadedState copyWith({List<Todo> todoList, String message}) {
    return TodoLoadedState(
        todoList: todoList ?? this.todoList, message: message);
  }
}

class DeletedState extends TodoState {
  DeletedState({List<Todo> todoList}) : super(todoList: todoList);
  DeletedState copyWith({List<Todo> todoList, String message}) {
    return DeletedState(todoList: todoList ?? this.todoList);
  }
}
