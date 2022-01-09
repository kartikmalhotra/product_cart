/// The TickerService will be our data source for the timer. It will expose a stream of ticks which we can subscribe and react to.
class TickerService {
  /// This function takes the tick (0 seconds) we want and returns a stream which emits the tick by increasing the tick count at an interval of [periodicDuration]
  ///
  /// [timeoutDuration] is decreased every second and if [timeoutDuration] is equal to zero then null tick value is returned
  Stream<int?> tick({required int periodicDuration, int? ticks = 0, int? timeoutDuration}) {
    int? _timeoutDuration = timeoutDuration;
    return Stream.periodic(Duration(seconds: periodicDuration), (x) {
      if (_timeoutDuration! > 0) {
        _timeoutDuration = _timeoutDuration! - (periodicDuration);
        return (ticks! + x + 1);
      } else {
        return null;
      }
    });
  }

  /// This function takes the tick (0 seconds) we want and returns a stream which emits the tick by increasing the tick count at an interval of [periodicDuration]
  ///
  /// Default value of [periodicDuration] is 5 seconds i.e by default rescan job status check will be in interval of 5 seconds.
  Stream<int> jobStatusTick({int ticks = 0, int periodicDuration = 5}) {
    return Stream.periodic(
        Duration(seconds: periodicDuration), (x) => ticks + x + 1);
  }

  /// This function takes the tick  we want and returns a stream which emits the tick by increasing the tick count at an interval of [duration]
  Stream<int> tickWithoutTimeout({required Duration duration, int ticks = 0}) {
    return Stream.periodic(duration, (x) {
      return (ticks + x + 1);
    });
  }
}
