import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

enum ServerStatus {
  online,
  offline,
  connecting
}

class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.connecting;
  late io.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  io.Socket get socket => _socket;
  Function get emit => _socket.emit;

  // Contructor
  SocketService(){
    _initConfig();
  }

  // Metodo que se ejecuta cuando se inicializa la clase
  void _initConfig(){

    _socket = io.io('http://10.25.1.22:3000/', {
      'transports'  : ['websocket'],
      'autoConnect' : true
    });
    
    _socket.onConnect((_) {
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });  

    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });

    

    // _socket.on('new-message', (payload) {
    //   print('new message:');
    //   print('nombre: ' + payload['nombre']);
    //   print('mensaje: ' + payload['mensaje']);
    //   print(payload.constainsKey('mensaje2') ? payload['mensaje2'] : 'There\'s no message');
    // });    

  }

}