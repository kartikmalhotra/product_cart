part of 'playback_bloc.dart';

abstract class PlaybackState extends Equatable {
  final int? tick;

  const PlaybackState(this.tick, [List props = const []]);
}

class ReadyPlaybackState extends PlaybackState {
  final int tick;

  const ReadyPlaybackState({required this.tick}) : super(tick);

  @override
  List<Object> get props => [tick];
}

class PausedPlaybackState extends PlaybackState {
  final int? tick;

  const PausedPlaybackState({required this.tick}) : super(tick);

  @override
  List<Object?> get props => [tick];
}

class RunningPlaybackState extends PlaybackState {
  final int? tick;

  const RunningPlaybackState({required this.tick}) : super(tick);

  @override
  List<Object?> get props => [tick];
}

class FinishedPlaybackState extends PlaybackState {
  const FinishedPlaybackState() : super(0);

  @override
  List<Object> get props => [];
}
