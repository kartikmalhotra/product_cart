part of 'timer_bloc.dart';

abstract class TimerState extends Equatable {
  final int? duration;

  const TimerState(this.duration, [List props = const []]);
}

class ReadyTimerState extends TimerState {
  final int duration;

  const ReadyTimerState({required this.duration}) : super(duration);

  @override
  List<Object> get props => [];
}

class PausedTimerState extends TimerState {
  final int? duration;

  const PausedTimerState({required this.duration}) : super(duration);

  @override
  List<Object?> get props => [duration];
}

class RunningTimerState extends TimerState {
  final int? duration;

  const RunningTimerState({required this.duration}) : super(duration);

  @override
  List<Object?> get props => [duration];
}

class FinishedTimerState extends TimerState {
  const FinishedTimerState() : super(100);

  @override
  List<Object?> get props => [duration];
}

class TimeoutTimerState extends TimerState {
  final int? duration;

  const TimeoutTimerState({required this.duration}) : super(duration);

  @override
  List<Object?> get props => [duration];
}
