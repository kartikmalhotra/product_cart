import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:bwys/utils/services/ticker_service.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final int _duration = 0;
  final TickerService _tickerService;
  final int _periodicDuration;
  final int _timeoutDuration;

  StreamSubscription<int?>? _tickerSubscription;

  /// Constructor
  TimerBloc({
    required TickerService tickerService,
    int periodicDuration = 1,
    int timeoutDuration = 180,
  })  : _tickerService = tickerService,
        _periodicDuration = periodicDuration,
        _timeoutDuration = timeoutDuration,
        super(const ReadyTimerState(duration: 0));

  @override
  Stream<TimerState> mapEventToState(
    TimerEvent event,
  ) async* {
    if (event is StartTimerEvent) {
      yield* _mapStartTimerEventToState(event);
    } else if (event is PauseTimerEvent) {
      yield* _mapPauseTimerEventToState(event);
    } else if (event is ResumeTimerEvent) {
      yield* _mapResumeTimerEventToState(event);
    } else if (event is FinishTimerEvent) {
      yield* _mapFinishTimerEventToState(event);
    } else if (event is ResetTimerEvent) {
      yield* _mapResetTimerEventToState(event);
    } else if (event is StopTimerEvent) {
      yield* _mapStopTimerEventToState(event);
    } else if (event is TickEvent) {
      yield* _mapTickEventToState(event);
    }
  }

  Stream<TimerState> _mapStartTimerEventToState(StartTimerEvent start) async* {
    yield RunningTimerState(duration: start.duration);
    _tickerSubscription?.cancel();
    _tickerSubscription = _tickerService
        .tick(
          ticks: start.duration,
          periodicDuration: _periodicDuration,
          timeoutDuration: _timeoutDuration,
        )
        .listen((duration) => add(TickEvent(duration: duration)));
  }

  Stream<TimerState> _mapPauseTimerEventToState(PauseTimerEvent pause) async* {
    if (state is RunningTimerState) {
      _tickerSubscription?.pause();
      yield PausedTimerState(duration: state.duration);
    }
  }

  Stream<TimerState> _mapResumeTimerEventToState(
      ResumeTimerEvent pause) async* {
    if (state is PausedTimerState) {
      _tickerSubscription?.resume();
      yield RunningTimerState(duration: state.duration);
    }
  }

  Stream<TimerState> _mapFinishTimerEventToState(
      FinishTimerEvent finish) async* {
    _tickerSubscription?.cancel();
    yield const FinishedTimerState();
  }

  Stream<TimerState> _mapResetTimerEventToState(ResetTimerEvent reset) async* {
    _tickerSubscription?.cancel();
    yield ReadyTimerState(duration: _duration);
  }

  Stream<TimerState> _mapStopTimerEventToState(StopTimerEvent reset) async* {
    _tickerSubscription?.cancel();
    yield RunningTimerState(duration: state.duration);
  }

  Stream<TimerState> _mapTickEventToState(TickEvent tick) async* {
    if (tick.duration == null) {
      _tickerSubscription?.cancel();
      yield TimeoutTimerState(duration: state.duration);
    } else if (tick.duration! < 96) {
      yield RunningTimerState(duration: tick.duration);
    } else {
      yield RunningTimerState(duration: state.duration);
    }
  }
}
