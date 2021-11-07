part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {
  List<int> indices;
  TodoEvent({this.indices});

  @override
  List<Object> get props => [indices];
}

class LoadTodoDataEvent extends TodoEvent {}

class AddTodoEvent extends TodoEvent {
  Todo todo;
  AddTodoEvent({this.todo});
}
