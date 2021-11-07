import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/blocs/timer/timer_bloc.dart';
import 'package:todo/blocs/todo/todo_bloc.dart';
import 'package:todo/handlers/local_storage_handler.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/screens/list_tile_widget.dart';
import 'package:todo/screens/view_todo_screen.dart';
import 'package:todo/utils/meta_colors.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key key}) : super(key: key);

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Duration currentDuration = Duration(minutes: 10);
  bool isGridView = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await LocalStorageHandler.setData(
            BlocProvider.of<TodoBloc>(context).state.todoList);
        return Future.value(true);
      },
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Colors.white, MetaColors.primaryColor])),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                "Todo",
                style: TextStyle(color: Colors.black),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isGridView = !isGridView;
                      });
                    },
                    child: !isGridView
                        ? Icon(
                            Icons.grid_3x3,
                            color: Colors.black,
                          )
                        : Icon(
                            Icons.list,
                            color: Colors.black,
                          ),
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(
                Icons.add,
                color: Colors.black,
              ),
              backgroundColor: Colors.white,
              elevation: 10,
              onPressed: _showAddTodoSheet,
            ),
            backgroundColor: Colors.white.withOpacity(.3),
            body: BlocConsumer<TodoBloc, TodoState>(
              listener: (context, state) {
             
                if (state.message != null)
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
              },
              buildWhen: (s1, s2) {
                if (s1 == s2)
                  return true;
                else if (s1.todoList?.length != s2.todoList?.length)
                  return true;
              },
              builder: (context, state) {
                if (state is TodoInitial) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TodoLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (state.todoList.isNotEmpty) {
                   
                    List<Todo> newList = state.todoList;
                    return Container(
                      child: Column(
                        children: [
                          Expanded(
                            child: GridView.count(
                              crossAxisCount: isGridView ? 3 : 1,
                              childAspectRatio: isGridView ? 1 : 2.5,
                              children: List.generate(
                                  newList.length,
                                  (index) => BlocProvider<TimerBloc>(
                                        create: (context) {
                                      
                                          return TimerBloc(todo: newList[index])
                                            ..add(LoadTimerData(
                                                todo: newList[index]));
                                        },
                                        child: ListTileWidget(
                                          isGridView: isGridView,
                                        ),
                                      )),
                            ),
                          )
                        ],
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text('No Todos Yet '),
                    );
                  }
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  _showAddTodoSheet() async {
    await showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Scaffold(
              body: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12))),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: titleController,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp("[a-z A-Z á-ú Á-Ú 0-9]"))
                            ],
                            cursorColor: MetaColors.primaryColor,
                            decoration: InputDecoration(
                                labelStyle:
                                    TextStyle(color: MetaColors.primaryColor),
                                label: Text("Title"),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                fillColor: Colors.grey.withOpacity(0.1),
                                filled: true),
                            validator: (String value) {
                              if (value.trim().isEmpty) {
                                return "Title is mandatory";
                              } else
                                return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: descriptionController,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp("[a-z A-Z á-ú Á-Ú 0-9]"))
                            ],
                            cursorColor: MetaColors.primaryColor,
                            decoration: InputDecoration(
                                labelStyle:
                                    TextStyle(color: MetaColors.primaryColor),
                                label: Text("Description"),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                                fillColor: Colors.grey.withOpacity(0.1),
                                filled: true),
                          ),
                        ),
                        CupertinoTimerPicker(
                          mode: CupertinoTimerPickerMode.ms,
                          minuteInterval: 1,
                          secondInterval: 1,
                          initialTimerDuration: currentDuration,
                          onTimerDurationChanged: (Duration changedtimer) {
                            setState(() {
                              currentDuration = changedtimer;
                            });
                          },
                        ),
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                        (states) => MetaColors.primaryColor)),
                            onPressed: _handleAddTodo,
                            child: Text(
                              "Add Todo",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  _handleAddTodo() async {
    if (!_formKey.currentState.validate())
      return;
    else if (currentDuration > Duration(minutes: 10))
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Duration must be less than or equal to 10 minutes")));
    else if (currentDuration < Duration(seconds: 1))
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Duration must be atleast 1 second")));
    else {
      Todo newTodo = Todo(
          title: titleController.text,
          description: descriptionController.text,
          duration: currentDuration,
          isPaused: true,
          isCompleted: false,
          status: "To Do",
          displayString: (currentDuration.inSeconds / 60).toInt().toString() +
                  ":" +
                  (currentDuration.inSeconds % 60).toInt().toString(),
          timerRunning: true,
          durationSeconds:currentDuration.inSeconds);
      setState(() {
        titleController.text = "";
        descriptionController.text = "";
      });
      BlocProvider.of<TodoBloc>(context).add(AddTodoEvent(todo: newTodo));
      Navigator.pop(context);
    }
  }
}
