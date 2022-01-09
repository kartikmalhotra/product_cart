part of 'web_socket_bloc.dart';

abstract class WebSocketServiceState extends Equatable {
  final IO.Socket? connection;

  const WebSocketServiceState({this.connection});
}

class NoConnectionExistState extends WebSocketServiceState {
  const NoConnectionExistState();

  @override
  List<Object> get props => [];
}

class HandShakeConnectionMadeState extends WebSocketServiceState {
  final IO.Socket? connection;

  const HandShakeConnectionMadeState({required this.connection})
      : super(connection: connection);

  @override
  List<Object?> get props => [connection];
}

class HandShakeConnectionErrorState extends WebSocketServiceState {
  const HandShakeConnectionErrorState();

  @override
  List<Object> get props => [];
}
