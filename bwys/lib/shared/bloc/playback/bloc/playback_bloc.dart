import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:bwys/utils/services/ticker_service.dart';

part 'playback_event.dart';
part 'playback_state.dart';

class PlaybackBloc extends Bloc<PlaybackEvent, PlaybackState> {
  final TickerService _tickerService;
  final int _tick;

  StreamSubscription<int>? _tickerSubscription;

  /// Constructor
  PlaybackBloc({
    required TickerService tickerService,
    int tick = 0,
  })  : _tickerService = tickerService,
        _tick = tick,
        super(ReadyPlaybackState(tick: tick));

  @override
  Stream<PlaybackState> mapEventToState(
    PlaybackEvent event,
  ) async* {
    if (event is TickPlayEvent) {
      yield* _mapTickPlayEventToState(event);
    } else if (event is StartPlaybackEvent) {
      yield* _mapStartPlaybackEventToState(event);
    } else if (event is PausePlaybackEvent) {
      yield* _mapPausePlaybackEventToState(event);
    } else if (event is ResumePlaybackEvent) {
      yield* _mapResumePlaybackEventToState(event);
    } else if (event is FinishPlaybackEvent) {
      yield* _mapFinishPlaybackEventToState(event);
    } else if (event is ResetPlaybackEvent) {
      yield* _mapResetPlaybackEventToState(event);
    } else if (event is StopPlaybackEvent) {
      yield* _mapStopPlaybackEventToState(event);
    }
  }

  Stream<PlaybackState> _mapTickPlayEventToState(TickPlayEvent event) async* {
    yield RunningPlaybackState(tick: event.tick);
  }

  Stream<PlaybackState> _mapStartPlaybackEventToState(
      StartPlaybackEvent start) async* {
    yield RunningPlaybackState(tick: start.tick);
    _tickerSubscription?.cancel();
    _tickerSubscription = _tickerService
        .tickWithoutTimeout(
          ticks: start.tick,
          duration: start.duration,
        )
        .listen((value) => add(TickPlayEvent(tick: value)));
  }

  Stream<PlaybackState> _mapPausePlaybackEventToState(
      PausePlaybackEvent pause) async* {
    if (state is RunningPlaybackState) {
      _tickerSubscription?.pause();
      yield PausedPlaybackState(tick: state.tick);
    }
  }

  Stream<PlaybackState> _mapResumePlaybackEventToState(
      ResumePlaybackEvent pause) async* {
    if (state is PlaybackState) {
      _tickerSubscription?.resume();
      yield RunningPlaybackState(tick: state.tick);
    }
  }

  Stream<PlaybackState> _mapFinishPlaybackEventToState(
      FinishPlaybackEvent finish) async* {
    _tickerSubscription?.cancel();
    yield const FinishedPlaybackState();
  }

  Stream<PlaybackState> _mapResetPlaybackEventToState(
      ResetPlaybackEvent reset) async* {
    _tickerSubscription?.cancel();
    yield ReadyPlaybackState(tick: _tick);
  }

  Stream<PlaybackState> _mapStopPlaybackEventToState(
      StopPlaybackEvent reset) async* {
    _tickerSubscription?.cancel();
    yield RunningPlaybackState(tick: state.tick);
  }
}
