import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { online, offline, connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;

  // * No entiendo muy bien la parte de colocar este código repetido aquí arriba pero
  // * si lo quito me marca error.
  IO.Socket _socket = IO.io('https://band-names-socket-server.onrender.com/', {
      'transports': ['websocket'],
      'autoConnect' : true
    });

  ServerStatus get serverStatus => _serverStatus;

  IO.Socket get socket => _socket;
  Function  get emit   => _socket.emit;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {

    // * Esta es la otra parte donde se repite el código de arriba
    // Dart client
    _socket = IO.io('https://band-names-socket-server.onrender.com/', {
      'transports': ['websocket'],
      'autoConnect' : true
    });

    _socket.on('connect', (_) {
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });
    _socket.on('disconnect', (_) {
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });
  }
}
