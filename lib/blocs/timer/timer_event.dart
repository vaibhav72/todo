part of 'timer_bloc.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

class LoadTimerData extends TimerEvent {
  Todo todo;
  LoadTimerData({this.todo});
}

class StartTimerEvent extends TimerEvent {
  Todo todo;
  StartTimerEvent({this.todo});
}

class TimerRunningEvent extends TimerEvent {}

class EndTimerEvent extends TimerEvent {}

class PauseTimerEvent extends TimerEvent {}

class ResumeTimerEvent extends TimerEvent {}
