import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:band_names/services/socket.dart';
import 'package:band_names/models/band.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.on('active-bands', _handlerActiveBands);     
    super.initState();
  }

  _handlerActiveBands(dynamic payload) {
    bands = (payload as List).map((band) => Band.fromMap(band)).toList();
    setState(() {});  
  }

  @override
  void dispose() {    
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');    
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: const Text('BandNames', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'status'),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              child: (socketService.serverStatus == ServerStatus.online)
                ? Icon(Icons.check_circle, color: Colors.blue[300])
                : const Icon(Icons.offline_bolt, color: Colors.red)              
            ),
          )
        ],
      ),
      body: Column(
        children: [

          _ShowGraph(bands),

          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (context, index) => _bandTile(bands[index])
            ),

          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        child: const Icon(Icons.add),
        onPressed: _addNewBand
      ),
    );
  }  
  
  Widget _bandTile(Band band) {

    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      background: _background(),
      onDismissed: (_) => setState(() => socketService.socket.emit('delete-band', {'id' : band.id})),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0,2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.name),
        trailing: Text('${band.votes}', style: const TextStyle(fontSize: 20)),
        onTap: () => setState(() => socketService.socket.emit('vote-band', {'id' : band.id}))      
      ),
    );
  }

  _background() {
    return Container(
      padding: const EdgeInsets.only(left: 8.0),
      color: Colors.red,
      child: const Align(
        alignment: Alignment.centerLeft,
        child: Text('Delete Band', style: TextStyle(color: Colors.white))
      ),
    );
  }

  _addNewBand(){

    final textController = TextEditingController();

    if(Platform.isAndroid) {
      // Android
      return showDialog(
        context: context, 
        builder: (context) {
          return AlertDialog(
            title: const Text('New band name:'),
            content: TextField(
              controller: textController
            ),
            actions: [

              MaterialButton(
                elevation: 5,
                textColor: Colors.blue,
                child: const Text('Add'),
                onPressed: () => setState(() => _addBandToList(textController.text))
              )

            ],
          );
        }
      );  
    } else {
      // iOS
      return showCupertinoDialog(
        context: context, 
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('New band name:'),
            content: CupertinoTextField(
              controller: textController,
            ),
            actions: [

              CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text('Add'),
                onPressed: () => setState(() => _addBandToList(textController.text))
              ),

              CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text('Dismiss'),
                onPressed: () => Navigator.pop(context)
              )

            ],
          );
        }
      );
    }
    
  }

  void _addBandToList(String name){
    
    if (name.length > 1) {
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.socket.emit('add-band', {'name' : name});
    }

    Navigator.pop(context);
  } 

}

class _ShowGraph extends StatelessWidget {
  
  final List<Band> bands;
  const _ShowGraph(this.bands);

  @override
  Widget build(BuildContext context) {

    Map<String, double> dataMap = {};
    bands.forEach( (band) => dataMap.putIfAbsent(band.name, () => band.votes.toDouble()) );    

    return Container(
      padding: const EdgeInsets.only(top: 10),
      width: double.infinity,
      height: 200,
      child: PieChart(dataMap: dataMap)
    );
  }
}