import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:todo/blocs/timer/timer_bloc.dart';
import 'package:todo/blocs/todo/todo_bloc.dart';
import 'package:todo/handlers/local_storage_handler.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/utils/meta_colors.dart';

class ViewTodoScreen extends StatefulWidget {
  final Todo todo;
  const ViewTodoScreen({Key key, this.todo}) : super(key: key);

  @override
  _ViewTodoScreenState createState() => _ViewTodoScreenState();
}

class _ViewTodoScreenState extends State<ViewTodoScreen> {
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
        child: BlocConsumer<TimerBloc, TimerState>(
          listener: (context, state) {
           
          },
          builder: (context, state) {
         
            if (state.todo != null)
              return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                      onPressed: () async {
                        await LocalStorageHandler.setData(
                            BlocProvider.of<TodoBloc>(context).state.todoList);
                        Navigator.pop(context);
                      },
                    ),
                    backgroundColor: Colors.transparent,
                    centerTitle: true,
                    elevation: 0,
                    title: Text(
                      state.todo.title,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w700),
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  body: Center(
                    child: Container(
                      child: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    state.todo.description,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                              SizedBox(height: 87),
                              _buildProgressIndicator(state),
                              SizedBox(
                                height: 30,
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: _buildStatus(state)),
                              SizedBox(
                                height: 30,
                              ),
                              if (state.todo?.isCompleted == null ||
                                  !state.todo?.isCompleted)
                                (state.todo?.isPaused != null &&
                                        state.todo?.isPaused)
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                            onTap: () {
                                              BlocProvider.of<TimerBloc>(
                                                      context)
                                                  .add(ResumeTimerEvent());
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(.12),
                                                        spreadRadius: 2,
                                                        blurRadius: 12,
                                                        offset: Offset(0, 5))
                                                  ]),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons.play_circle_outline,
                                                  color: Colors.black,
                                                  size: 30,
                                                ),
                                              ),
                                            )),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                            onTap: () {
                                              BlocProvider.of<TimerBloc>(
                                                      context)
                                                  .add(PauseTimerEvent());
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(.12),
                                                        spreadRadius: 2,
                                                        blurRadius: 12,
                                                        offset: Offset(0, 5))
                                                  ]),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons.pause,
                                                  color: Colors.black,
                                                  size: 30,
                                                ),
                                              ),
                                            )),
                                      )
                              else
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.done,
                                    color: Colors.green,
                                  ),
                                ),
                            ]),
                      ),
                    ),
                  ),
                ),
              );
            else
              return Container(
                child: Text("Loading"),
              );
          },
        ),
      ),
    );
  }

  Container _buildProgressIndicator(TimerState state) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.12),
                spreadRadius: 2,
                blurRadius: 12,
                offset: Offset(0, 5))
          ]),
      height: 130,
      width: 130,
      child: Center(
        child: LiquidCircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
              MetaColors.primaryColor.withOpacity(.6)),
          center: Text(
            state.todo.displayString,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          value: state.todo.durationSeconds / state.todo.duration.inSeconds,
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }

  Text _buildStatus(TimerState state) => Text(
        state.todo?.status.toString(),
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: state.todo?.status.toString() == "Done"
                ? Colors.green
                : state.todo?.status.toString() == "To Do"
                    ? Colors.red
                    : Colors.yellow[800]),
      );
}
