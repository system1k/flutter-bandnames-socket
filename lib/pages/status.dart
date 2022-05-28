import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:band_names/services/socket.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: const Text('Estado de Conexión', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.grey
      ),
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('ServerStatus: ${socketService.serverStatus}'),
          ],
        ),
      ),
      
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        child: const Icon(Icons.message),
        onPressed: (){
          socketService.socket.emit('emit-message', {
            'nombre' : 'Flutter',
            'mensaje' : 'Emitido desde Flutter' 
          });
        },
      ),
    );
  }
}