import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/blocs/todo/todo_bloc.dart';
import 'package:todo/models/todo_model.dart';

class LocalStorageHandler {
 static Future<List<Todo>> getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> data = preferences.getStringList("data");
    List<Todo> responseList = [];
    if (data != null && data.isNotEmpty) {
      data.forEach((element) {
        responseList.add(todoFromJson(element));
      });
    }
    return responseList;
  }

 static setData(List<Todo> todoList) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> data = [];
    if (todoList?.isNotEmpty) {
      todoList.forEach((element) {
        data.add(todoToJson(element));
      });
    }
    preferences.setStringList("data", data);
  }
  static Future<List<Todo>> addTodo(Todo todo)async{
    List<Todo> todoList=await getData();
    todoList.add(todo);
   await setData(todoList);
   return todoList;

  }
  
}
