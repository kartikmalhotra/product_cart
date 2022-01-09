part of 'web_socket_bloc.dart';

@immutable
abstract class WebSocketServiceEvent extends Equatable {
  /// Passing class fields in a list to the Equatable super class
  const WebSocketServiceEvent([List props = const []]) : super();
}

class MakeHandshakeConnection extends WebSocketServiceEvent {
  const MakeHandshakeConnection();

  @override
  List<Object> get props => [];
}

class HandshakeConnectionMade extends WebSocketServiceEvent {
  const HandshakeConnectionMade();

  @override
  List<Object> get props => [];
}

class HandshakeConnectionError extends WebSocketServiceEvent {
  const HandshakeConnectionError();

  @override
  List<Object> get props => [];
}
