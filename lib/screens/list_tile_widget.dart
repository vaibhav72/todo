import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/blocs/timer/timer_bloc.dart';
import 'package:todo/screens/view_todo_screen.dart';

class ListTileWidget extends StatefulWidget {
  ListTileWidget({Key key, this.isGridView}) : super(key: key);
  bool isGridView;

  @override
  State<ListTileWidget> createState() => _ListTileWidgetState();
}

class _ListTileWidgetState extends State<ListTileWidget> {
 

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TimerBloc, TimerState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.todo == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
        

          return Align(
            alignment: Alignment.topCenter,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (newContext) => BlocProvider.value(
                          value: BlocProvider.of<TimerBloc>(context),
                          child: ViewTodoScreen(),
                        )));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(.12),
                            spreadRadius: 2,
                            blurRadius: 12,
                            offset: Offset(0, 5))
                      ]),
                  child: widget.isGridView
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            state.todo?.title.toString(),
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700),
                                          )),
                                    ),
                                    if (state.todo?.isCompleted == null ||
                                        !state.todo?.isCompleted)
                                      (state.todo?.isPaused != null &&
                                              state.todo?.isPaused)
                                          ? InkWell(
                                              onTap: () {
                                                BlocProvider.of<TimerBloc>(
                                                        context)
                                                    .add(ResumeTimerEvent());
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (newContext) =>
                                                            BlocProvider.value(
                                                              value: BlocProvider
                                                                  .of<TimerBloc>(
                                                                      context),
                                                              child:
                                                                  ViewTodoScreen(),
                                                            )));
                                              },
                                              child: Icon(Icons.play_circle))
                                          : InkWell(
                                              onTap: () {
                                                BlocProvider.of<TimerBloc>(
                                                        context)
                                                    .add(PauseTimerEvent());
                                              },
                                              child: Icon(Icons.pause_circle))
                                    else
                                      Icon(
                                        Icons.done,
                                        color: Colors.green,
                                      ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      state.todo?.status.toString(),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: state.todo?.status
                                                      .toString() ==
                                                  "Done"
                                              ? Colors.green
                                              : state.todo?.status.toString() ==
                                                      "To Do"
                                                  ? Colors.red
                                                  : Colors.yellow[800]),
                                    )),
                              ),
                              Expanded(
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        state.todo?.description.toString())),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      state.todo?.displayString.toString()),
                                ),
                              )
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          state.todo?.title.toString(),
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700),
                                        )),
                                  ),
                                  Text(
                                    state.todo?.status.toString(),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: state.todo?.status.toString() ==
                                                "Done"
                                            ? Colors.green
                                            : state.todo?.status.toString() ==
                                                    "To Do"
                                                ? Colors.red
                                                : Colors.yellow[800]),
                                  )
                                ],
                              ),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child:
                                      Text(state.todo?.description.toString())),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(state.todo?.displayString.toString()),
                                    if (state.todo?.isCompleted == null ||
                                        !state.todo?.isCompleted)
                                      (state.todo?.isPaused != null &&
                                              state.todo?.isPaused)
                                          ? InkWell(
                                              onTap: () {
                                                BlocProvider.of<TimerBloc>(
                                                        context)
                                                    .add(ResumeTimerEvent());
                                              },
                                              child: Icon(Icons.play_circle))
                                          : InkWell(
                                              onTap: () {
                                                BlocProvider.of<TimerBloc>(
                                                        context)
                                                    .add(PauseTimerEvent());
                                              },
                                              child: Icon(Icons.pause_circle))
                                    else
                                      Icon(
                                        Icons.done,
                                        color: Colors.green,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
