part of 'playback_bloc.dart';

@immutable
abstract class PlaybackEvent extends Equatable {
  /// Passing class fields in a list to the Equatable super class
  const PlaybackEvent([List props = const []]) : super();
}

class StartPlaybackEvent extends PlaybackEvent {
  final Duration duration;
  final int tick;

  const StartPlaybackEvent({
    required this.duration,
    this.tick = 0,
  });

  @override
  List<Object> get props => [tick, duration];
}

class PausePlaybackEvent extends PlaybackEvent {
  @override
  List<Object> get props => [];
}

class ResumePlaybackEvent extends PlaybackEvent {
  @override
  List<Object> get props => [];
}

class FinishPlaybackEvent extends PlaybackEvent {
  @override
  List<Object> get props => [];
}

class ResetPlaybackEvent extends PlaybackEvent {
  @override
  List<Object> get props => [];
}

class StopPlaybackEvent extends PlaybackEvent {
  @override
  List<Object> get props => [];
}

class TickPlayEvent extends PlaybackEvent {
  final int? tick;

  const TickPlayEvent({this.tick});

  @override
  List<Object?> get props => [tick];
}
