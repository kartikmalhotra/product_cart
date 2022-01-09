import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:bwys/config/application.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

part 'web_socket_event.dart';
part 'web_socket_state.dart';

class WebSocketServiceBloc
    extends Bloc<WebSocketServiceEvent, WebSocketServiceState> {
  Socket? connection;

  WebSocketServiceBloc() : super(const NoConnectionExistState());

  @override
  Stream<WebSocketServiceState> mapEventToState(
    WebSocketServiceEvent event,
  ) async* {
    if (event is MakeHandshakeConnection) {
      yield* _mapMakeHandshakeConnectionEventToState(event);
    } else if (event is HandshakeConnectionMade) {
      yield HandShakeConnectionMadeState(connection: connection);
    } else if (event is HandshakeConnectionError) {
      yield const HandShakeConnectionErrorState();
    }
  }

  Stream<WebSocketServiceState> _mapMakeHandshakeConnectionEventToState(
      MakeHandshakeConnection event) async* {
    /// Make Handshake connection
    int _length = Application.storageService!.syncedWebUrl!.length;

    /// Check if syncedWebUrl contains / in last reduce the length
    if (Application.storageService!.syncedWebUrl![
            Application.storageService!.syncedWebUrl!.length - 1] ==
        '/') {
      _length--;
    }

    connection = IO.io(
        Application.storageService!.syncedWebUrl!.substring(0, _length),
        OptionBuilder()
            .setTransports(['websocket'])
            .setPath('/ws/')
            .setExtraHeaders({'Authorization': AppUser.userToken})
            .enableReconnection()
            .disableAutoConnect()
            .setReconnectionDelay(1000)
            .setReconnectionDelayMax(5000)
            .setReconnectionAttempts(double.infinity)
            .build());

    /// Request for connection
    connection!.connect();

    /// Check the status of the connection and yield the state
    yield* _mapConnectionStatusToState();
  }

  Stream<WebSocketServiceState> _mapConnectionStatusToState() async* {}

  void removeHandshake() {
    connection!.disconnect();
    connection!.dispose();
  }
}
