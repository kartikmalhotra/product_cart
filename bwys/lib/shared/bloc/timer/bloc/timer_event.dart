part of 'timer_bloc.dart';

@immutable
abstract class TimerEvent extends Equatable {
  /// Passing class fields in a list to the Equatable super class
  const TimerEvent([List props = const []]) : super();
}

class StartTimerEvent extends TimerEvent {
  final int? duration;

  const StartTimerEvent({required this.duration});

  @override
  List<Object?> get props => [duration];
}

class PauseTimerEvent extends TimerEvent {
  @override
  List<Object> get props => [];
}

class ResumeTimerEvent extends TimerEvent {
  @override
  List<Object> get props => [];
}

class FinishTimerEvent extends TimerEvent {
  @override
  List<Object> get props => [];
}

class ResetTimerEvent extends TimerEvent {
  @override
  List<Object> get props => [];
}

class StopTimerEvent extends TimerEvent {
  @override
  List<Object> get props => [];
}

class TickEvent extends TimerEvent {
  final int? duration;

  const TickEvent({this.duration});

  @override
  List<Object?> get props => [duration];
}
